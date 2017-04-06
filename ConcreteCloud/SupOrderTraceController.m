//
//  SupOrderTraceController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderTraceController.h"
#import "PullTableView.h"
#import "SupOrderReceiveCell.h"
#import "PProcess2Cell.h"
#import "PProcess3Cell.h"
#import "PProcess4Cell.h"
#import "POrderDetailRequest.h"
#import "Response+POrderInfo.h"
#import "PProcessRequest.h"
#import "Response+PProcess.h"
#import "POrderTrackController.h"
#import "PProcessListRequest.h"
#import "PProcessList.h"
#import "Response+PProcessList.h"
#import "SupOrderDealCell.h"
#import "SupOrderDisCell.h"
#import "KeyValueCell.h"
#import "SupOrderConfirmRequest.h"


@interface SupOrderTraceController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate,
            PProcess3CellDelegate, SupOrderDisCellDelegate, SupOrderDealCellDelegate>

@property (strong, nonatomic) IBOutlet PullTableView *tableView;

@property (assign, nonatomic) CGFloat complete;

@property (assign, nonatomic) CGFloat way;

@property (weak, nonatomic) PProcess3Cell *cell;

@end


@implementation SupOrderTraceController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)initData
{
    _complete = 0;
    _way = 0;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //在所有的View画好之后，加载完成进度
    CGFloat total = [_orderInfo.number floatValue];
    [_cell setTotal:total complete:_complete way:_way];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"appear");
    
    //获取运送进度
    [self getProcess];
}

#pragma mark - Network Request

- (void)refresh
{
    POrderDetailRequest *request = [[POrderDetailRequest alloc] init];
    request.orderId = _orderInfo.orderId;
    
    __weak typeof (self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:URL_P_DETAIL parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (weakSelf.tableView.pullTableIsRefreshing)
        {
            weakSelf.tableView.pullTableIsRefreshing = NO;
        }
        weakSelf.orderInfo = [[ResponseDictionary alloc] pOrderInfo:responseObject[@"body"]];
        [self getProcess];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


//获取运送进度
- (void)getProcess
{
    PProcessRequest *request = [[PProcessRequest alloc] init];
    request.orderId = _orderInfo.orderId;
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:URL_P_PROCESS parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        PProcessData *process = [[ResponseDictionary alloc] getPProcessData:[responseObject objectForKey:@"body"]];
        weakSelf.complete = process.number > 0 ? process.number : 0;
        weakSelf.way = [process.suppOrder.is floatValue];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

//获取运输信息
- (void)getTask:(PProcess3Cell *)cell
{
    PProcessListRequest *request = [[PProcessListRequest alloc] init];
    request.supplierId = _orderInfo.supplierId;
    request.supplierOrderId = _orderInfo.orderId;
    request.finish = @"1";
    
    [[HttpClient shareClient] view:nil post:URL_P_VEHICLE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        PProcessList *taskInfo = [[ResponseDictionary alloc] getProcessList:[responseObject objectForKey:@"body"]];
        [cell markOnMap:taskInfo];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger state = [_orderInfo.isComplete integerValue];
    
    if (0 == indexPath.row)
    {
        SupOrderReceiveCell *cell = [SupOrderReceiveCell cellFromNib];
        
        cell.lbDate.text = _orderInfo.createTime;
        cell.lbHzs.text = _orderInfo.hzsName;
        cell.lbName.text = _orderInfo.userName;
        cell.lbTel.text = _orderInfo.tel;
        cell.lbAddress.text = _orderInfo.address;
        
        if (0 == state)
        {
            [cell setCurrentMode];
        }
        else
        {
            [cell setPassMode];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        SupOrderDealCell *cell = [SupOrderDealCell cellFromNib];
        
        cell.delegate = self;
        
        if (state < 1)
        {
            [cell setCurrentMode];
        }
        else
        {
            NSInteger confirm = [_orderInfo.isAffirm integerValue];
            [cell setPassMode:2 == confirm ? NO : YES];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        SupOrderDisCell *cell = [SupOrderDisCell cellFromNib];
        cell.delegate = self;
        
        if (state < 1)
        {
            [cell setFutureMode];
        }
        else if (1 == state)
        {
            //确认结果
            NSInteger confirm = [_orderInfo.isAffirm integerValue];
            
            if (1 == confirm)
            {
                [cell setCurrentMode];
            }
            else if (2 == confirm)
            {
                [cell setFutureMode];
            }

            
        }
        else
        {
            [cell setPassMode];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        PProcess3Cell *cell = [PProcess3Cell cellFromNib];
        cell.goodsName = _orderInfo.goodsName;
        
        _cell = cell;
        
        [cell setTotal:100 complete:0 way:0];
        
        
        if (state < 2)
        {
            [cell setFutureMode];
        }
        else if (2 == state)
        {
            [cell setCurrentMode];
            CGFloat total = [_orderInfo.number floatValue];
            [cell setTotal:total complete:_complete way:_way];
        }
        else
        {
            [cell setPassMode];
            CGFloat total = [_orderInfo.number floatValue];
            [cell setTotal:total complete:_complete way:_way];
        }
        
        cell.delegate = self;
        
        [self getTask:cell];
        
        [cell setSupplierMode];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (4 == indexPath.row)
    {
        PProcess4Cell *cell = [PProcess4Cell cellFromNib];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (3 == state)
        {
            cell.lbDate.text = _orderInfo.completeTime;
            [cell setPassMode];
        }
        
        [cell setSupplierMode];
        return cell;
    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return [SupOrderReceiveCell cellHight];
    }
    else if (1 == indexPath.row)
    {
        return [SupOrderDealCell cellHeight];
    }
    else if (2 == indexPath.row)
    {
        return [SupOrderDisCell cellHeight];
    }
    else if (3 == indexPath.row)
    {
        return [PProcess3Cell cellHeight];
    }
    else if (4 == indexPath.row)
    {
        return [PProcess4Cell cellHeight];
    }
    
    return 0;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self refresh];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}

#pragma mark -- UIScrollViewDelegate

//禁止上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        CGPoint offset = scrollView.contentOffset;
        CGPoint newOffset = CGPointMake(offset.x, scrollView.contentSize.height - scrollView.bounds.size.height);
        scrollView.contentOffset = newOffset;
    }
}


#pragma mark - PProcess3CellDelegate

- (void)onClickMap
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickMap)])
    {
        [_delegate onClickMap];
    }
}

- (void)onClickDetail
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDetail)])
    {
        [_delegate onClickDetail];
    }
}

#pragma mark - SupOrderDisCellDelegate

- (void)onClickDispatch
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDispatch)])
    {
        [_delegate onClickDispatch];
    }
}

#pragma mark - SupOrderDealCellDelegate

- (void)onClickOk
{
    SupOrderConfirmRequest *request = [[SupOrderConfirmRequest alloc] init];
    request.orderId = _orderInfo.orderId;
    request.userName = [[Config shareConfig] getName];
    request.is = @"1";
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_CONFIRM parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"订单已经确认" view:self.view];
        [self refresh];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)onClickCancel
{
    SupOrderConfirmRequest *request = [[SupOrderConfirmRequest alloc] init];
    request.orderId = _orderInfo.orderId;
    request.userName = [[Config shareConfig] getName];
    request.is = @"2";
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_CONFIRM parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"订单已经拒绝" view:self.view];
        [self refresh];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
