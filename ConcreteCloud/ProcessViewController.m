//
//  ProcessViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProcessViewController.h"
#import "PullTableView.h"
#import "PSubmitCell.h"
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
#import "AProcess3HistoryCell.h"


@interface ProcessViewController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate,
PProcess3CellDelegate, PProcess4CellDelegate, AProcess3HistoryCellDelegate>

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (assign, nonatomic) CGFloat complete;

@property (assign, nonatomic) CGFloat way;

@property (weak, nonatomic) PProcess3Cell *cell;

@property (assign, nonatomic) NSInteger taskCount;

@end


@implementation ProcessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
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
    [[HttpClient shareClient] view:self.view post:URL_P_DETAIL parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    
    [[HttpClient shareClient] view:nil post:URL_P_VEHICLE parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        
                               PProcessList *taskInfo = [[ResponseDictionary alloc] getProcessList:[responseObject objectForKey:@"body"]];
                               
                               _taskCount = taskInfo.info.count;
                               
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger state = [_orderInfo.isComplete integerValue];
    
    if (0 == indexPath.row)
    {
        PSubmitCell *cell = [PSubmitCell cellFromNib];
                
        cell.lbDate.text = _orderInfo.createTime;
        cell.lbSupplier.text = _orderInfo.supplierName;
        cell.lbName.text = _orderInfo.administratorName;
        cell.lbTel.text = _orderInfo.administratorTel;
        cell.lbAddress.text = _orderInfo.supplierName;
        
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
        PProcess2Cell *cell = [PProcess2Cell cellFromNib];
        
        if (state < 1)
        {
            [cell setFutureMode];
        }
        else if (1 == state)
        {
            [cell setCurrentMode];
        }
        else
        {
            [cell setPassMode];
        }
        
        cell.lbDate.text = _orderInfo.confirmTime;
        cell.lbName.text = _orderInfo.confirmUserName;
        cell.lbTel.text = _orderInfo.confirmTel;
        
        //设置提示语
        NSInteger confirm = [_orderInfo.isAffirm integerValue];
        
        if (1 == confirm)
        {
            cell.lbTip.text = @"订单已经确认，请等待供应商安排运送";
        }
        else if (2 == confirm)
        {
            cell.lbTip.text = @"供应商拒绝了您的订单，请及时和供应商沟通";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (2 == indexPath.row) {
        
        if (Status_History == _traceStatus) {
            
            AProcess3HistoryCell *cell = [AProcess3HistoryCell cellFromNib];
            
            cell.lbDate.text = _orderInfo.confirmTime;
            
            cell.delegate = self;
            
            return cell;
            
        } else {
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
            
            cell.lbDate.text = _orderInfo.confirmTime;
            
            [self getTask:cell];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }
    }
    else if (3 == indexPath.row)
    {
        PProcess4Cell *cell = [PProcess4Cell cellFromNib];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (3 == state) {
            cell.lbDate.text = _orderInfo.completeTime;
            [cell setPassMode];
            
        } else if (0 == state) {
            [cell setFutureMode];
        
        } else {
            [cell setCurrentMode];
        }
        
        
        //没有操作权限        
        if (![[Config shareConfig] getOperable]) {
            [cell setFutureMode];
        }
        
        cell.delegate = self;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return [PSubmitCell cellHight];
        
    } else if (1 == indexPath.row) {
        return [PProcess2Cell cellHeight];
        
    } else if (2 == indexPath.row) {
        
        if (Status_History == _traceStatus) {
            return [AProcess3HistoryCell cellHeight];
            
        } else {
            return [PProcess3Cell cellHeight];
        }
        
    } else if (3 == indexPath.row) {
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
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height
        && scrollView.contentSize.height >= scrollView.bounds.size.height) {
        CGPoint offset = scrollView.contentOffset;
        offset.y = scrollView.contentSize.height - scrollView.bounds.size.height;
        
        scrollView.contentOffset = offset;
        
    } else if (scrollView.contentOffset.y >= 0
             && scrollView.contentSize.height <= scrollView.bounds.size.height) {  //内容小于屏幕，并且向上滑动
        CGPoint offset = scrollView.contentOffset;
        offset.x = 0;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}


#pragma mark - PProcess3CellDelegate

- (void)onClickMap
{
    if (!_taskCount) {
        [HUDClass showHUDWithText:@"当前没有运输中车辆"];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickMap)]) {
        [_delegate onClickMap];
    }
}

- (void)onClickDetail
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDetail)]) {
        [_delegate onClickDetail];
    }
}

#pragma mark - PProcess4CellDelegate

- (void)onClickComplete
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickComplete:)])
    {
        [_delegate onClickComplete:_orderInfo.orderId];
    }
}

@end
