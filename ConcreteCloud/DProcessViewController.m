//
//  DProcessViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DProcessViewController.h"
#import "PullTableView.h"
#import "DProcess1Cell.h"
#import "DProcess2Cell.h"
#import "DProcess3Cell.h"
#import "PProcess4Cell.h"
#import "DOrderDetailRequest.h"
#import "DOrderDetailResponse.h"
#import "DProcessInfo.h"
#import "POrderTrackController.h"
#import "DProcessResponse.h"
#import "DProcessList.h"
#import "DProcessListResponse.h"
#import "DOrderConfirmRequest.h"
#import "SProcess1Cell.h"
#import "SProcess2Cell.h"
#import "AProcess3HistoryCell.h"


@interface DProcessViewController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate,
DProcess1CellDelegate, DProcess3CellDelegate, PProcess4CellDelegate, AProcess3HistoryCellDelegate>

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (assign, nonatomic) CGFloat complete;

@property (assign, nonatomic) CGFloat way;

@property (assign, nonatomic) CGFloat total;

@property (weak, nonatomic) DProcess3Cell *cell;

@end


@implementation DProcessViewController


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
    CGFloat total = _orderInfo.number;
    [_cell setTotal:total complete:_complete way:_way];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取运送进度
    [self getProcess];
    
}

#pragma mark - Network Request

- (void)refresh
{
    DOrderDetailRequest *request = [[DOrderDetailRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    
    __weak typeof (self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:URL_D_DETAIL parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (weakSelf.tableView.pullTableIsRefreshing)
        {
            weakSelf.tableView.pullTableIsRefreshing = NO;
        }
        DOrderDetailResponse *response = [[DOrderDetailResponse alloc] initWithDictionary:responseObject];
        weakSelf.orderInfo = [response getOrderInfo];
        [self getProcess];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


//获取运送进度
- (void)getProcess
{
    DOrderDetailRequest *request = [[DOrderDetailRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:URL_D_PROCESS parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        DProcessResponse *response = [[DProcessResponse alloc] initWithDictionary:responseObject];
        DProcessInfo *process = [response getProcessInfo];
        
        weakSelf.complete = process.finishedNum;
        weakSelf.way = process.transportingNum;
        weakSelf.total = process.number;
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

//获取运输信息
- (void)getTask:(DProcess3Cell *)cell
{
    DOrderDetailRequest *request = [[DOrderDetailRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    
    [[HttpClient shareClient] view:nil post:URL_D_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        DProcessListResponse *response = [[DProcessListResponse alloc] initWithDictionary:responseObject];
        DProcessList *taskInfo = [response getProcessList];
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
    NSInteger state = [_orderInfo.state integerValue];
    
    if (0 == indexPath.row)
    {
        if (Role_Site_Staff == _role)
        {
            SProcess1Cell *cell = [SProcess1Cell cellFromNib];
            cell.lbDate.text = _orderInfo.createTime;
            
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
        else
        {
            DProcess1Cell *cell = [DProcess1Cell cellFromNib];
            cell.delegate = self;
            
            cell.lbDate.text = _orderInfo.createTime;
            cell.lbProject.text = _orderInfo.projectName;
            cell.lbCompany.text = _orderInfo.companyName;
            cell.lbLinkMan.text = _orderInfo.orderUserName;
            cell.lbTel.text = _orderInfo.orderUserTel;
            
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
        
    }
    else if (1 == indexPath.row)
    {
        
        if (Role_Site_Staff == _role)
        {
            SProcess2Cell *cell = [SProcess2Cell cellFromNib];
            
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
            
            cell.lbDate.text = _orderInfo.reviewTime;
            
            cell.lbConfirmUser.text = _orderInfo.reviewUserName;
            
            cell.lbTel.text = _orderInfo.reviewTel;
            
            //设置提示语
            NSInteger confirm = [_orderInfo.reviewState integerValue];
            
            if (1 == confirm)
            {
                cell.lbTip.text = @"搅拌站已经确认您的订单,请等待运送";
            }
            else if (2 == confirm)
            {
                cell.lbTip.text = @"搅拌站无法履行您的订单,详情请联系搅拌站";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            DProcess2Cell *cell = [DProcess2Cell cellFromNib];
            
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
            
            cell.lbDate.text = _orderInfo.reviewTime;
            
            //设置提示语
            NSInteger confirm = [_orderInfo.reviewState integerValue];
            
            if (1 == confirm)
            {
                cell.lbTip.text = @"订单已经确认";
            }
            else if (2 == confirm)
            {
                cell.lbTip.text = @"订单已经拒绝";
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
    } else if (2 == indexPath.row) {
        
        if (Status_History == _traceStatus) {
            AProcess3HistoryCell *cell = [AProcess3HistoryCell cellFromNib];
            
            cell.delegate = self;
            
            cell.lbDate.text = _orderInfo.reviewTime;
            
            return cell;
            
        } else {
            DProcess3Cell *cell = [DProcess3Cell cellFromNib];
            
            cell.lbDate.text = _orderInfo.reviewTime;
            
            _cell = cell;
            [cell setTotal:100 complete:0 way:0];
            
            
            
            if (state < 2)
            {
                [cell setFutureMode];
            }
            else if (2 == state)
            {
                [cell setCurrentMode];
                [cell setTotal:_total complete:_complete way:_way];
                
                NSInteger send = [_orderInfo.sendComplete integerValue];
                [cell setCarryHiden:send];
            }
            else
            {
                [cell setPassMode];
                [cell setTotal:_total complete:_complete way:_way];
            }
            
            if (Role_Site_Staff == _role)
            {
                [cell setSiteRole];
            }
            
            cell.delegate = self;
            
            [self getTask:cell];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else if (3 == indexPath.row)
    {
        PProcess4Cell *cell = [PProcess4Cell cellFromNib];
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (3 == state)
        {
            cell.lbDate.text = _orderInfo.completeTime;
            [cell setPassMode];
        }
        
        if (Role_Site_Staff == _role)
        {
            [cell setSiteRole];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        if (Role_Site_Staff == _role)
        {
            return [SProcess1Cell cellHeight];
        }
        else
        {
            return [DProcess1Cell cellHeight];
        }
    }
    else if (1 == indexPath.row) {
        if (Role_Site_Staff == _role) {
            return [SProcess2Cell cellHeight];
            
        } else {
            return [DProcess2Cell cellHeight];
            
        }
    } else if (2 == indexPath.row) {
        
        if (Role_Site_Staff == _role) {
            
            if (Status_Process == _traceStatus) {
                return [DProcess3Cell cellHeightSite];
                
            } else if (Status_History == _traceStatus) {
                return [AProcess3HistoryCell cellHeight];
            }
            
        } else {
            if (Status_Process == _traceStatus) {
                return [DProcess3Cell cellHeight];
                
            } else if (Status_History == _traceStatus) {
                return [AProcess3HistoryCell cellHeight];
            }
            
        }
    }
    else if (3 == indexPath.row)
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
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height
        && scrollView.contentSize.height >= scrollView.bounds.size.height)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = scrollView.contentSize.height - scrollView.bounds.size.height;
        
        scrollView.contentOffset = offset;
    }
    else if (scrollView.contentOffset.y >= 0
             && scrollView.contentSize.height <= scrollView.bounds.size.height) //内容小于屏幕，并且向上滑动
    {
        CGPoint offset = scrollView.contentOffset;
        offset.x = 0;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}


#pragma mark - DProcess3CellDelegate

- (void)onClickMap
{
    if (_delegate)
    {
        [_delegate onClickMap];
    }
}

- (void)onClickDetail
{
    if (_delegate)
    {
        [_delegate onClickDetail];
    }
}

- (void)onClickCarry
{
    DOrderDetailRequest *request = [[DOrderDetailRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    
    [[HttpClient shareClient] view:self.view post:URL_CARRY_FINISH parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"运送完成" view:self.view];
        [self refresh];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - DProcess1CellDelegate

- (void)onClickOK
{
    DOrderConfirmRequest *request = [[DOrderConfirmRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    request.userName = [[Config shareConfig] getName];
    request.reviewState = @"1";
    
    [[HttpClient shareClient] view:self.view post:URL_D_CONFIRM parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"已经确认订单" view:self.view];
        [self refresh];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)onClickCancel
{
    DOrderConfirmRequest *request = [[DOrderConfirmRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    request.userName = [[Config shareConfig] getName];
    request.reviewState = @"2";
    
    [[HttpClient shareClient] view:self.view post:URL_D_CONFIRM parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"已经拒绝订单" view:self.view];
        [self refresh];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - PProcess4CellDelegate

- (void)onClickComplete
{
    if (_delegate)
    {
        [_delegate onClickComplete];
    }
}

@end
