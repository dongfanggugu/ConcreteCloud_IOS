//
//  SupOrderListController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderListController.h"
#import "PullTableView.h"
#import "POrderItemView2.h"
#import "POrderListRequest.h"
#import "POrderListResponse.h"
#import "POrderInfo.h"
#import "SupOrderProcessController.h"

@interface SupOrderListController()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PullTableViewDelegate>

@property (strong, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSMutableArray<POrderInfo *> *arrayOrder;

@property G_Segment curSel;

@property NSInteger curPage;

@end


@implementation SupOrderListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"进行中" right:@"历史订单"];
    
    [self initView];
    
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    if (Segment_Left == _curSel) {
        [self getUnfinishedOrder];
        
    } else {
        [self getFinishedOrder];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)initData
{
    _curSel = Segment_Left;
    _arrayOrder = [[NSMutableArray alloc] init];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width,
                                                                 self.view.frame.size.height - 94 - 49)];
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - network request

- (void)getUnfinishedOrder
{
    POrderListRequest *request = [[POrderListRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    request.type = [[Config shareConfig] getType];
    request.page = -1;
    request.rows = 10;
    request.ing = @"1";
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               
                               POrderListResponse *response = [[POrderListResponse alloc] initWithDictionary:responseObject];
                               
                               [weakSelf.arrayOrder removeAllObjects];
                               [weakSelf.arrayOrder addObjectsFromArray:response.body];
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
    
}

- (void)getFinishedOrder
{
    POrderListRequest *request = [[POrderListRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    request.type = [[Config shareConfig] getType];
    request.page = _curSel;
    request.rows = 10;
    request.ing = @"2";
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing) {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               POrderListResponse *response = [[POrderListResponse alloc] initWithDictionary:responseObject];
                               
                               [_arrayOrder removeAllObjects];
                               [weakSelf.arrayOrder addObjectsFromArray:response.body];
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

- (void)getMoreFinishedOrder
{
    POrderListRequest *request = [[POrderListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.is = @"2";
    request.type = [[Config shareConfig] getType];
    request.page = _curPage;
    request.rows = 2;
    request.ing = @"2";
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               if (weakSelf.tableView.pullTableIsLoadingMore)
                               {
                                   weakSelf.tableView.pullTableIsLoadingMore = NO;
                               }
                               
                               POrderListResponse *response = [[POrderListResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arrayOrder addObjectsFromArray:response.body];
                               
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

#pragma mark - segment click callback

- (void)onClickLeftSegment
{
    _curSel = Segment_Left;
    [_arrayOrder removeAllObjects];
    [self getUnfinishedOrder];
}

- (void)onClickRightSegment
{
    _curSel = Segment_Right;
    _curPage = 1;
    [_arrayOrder removeAllObjects];
    [self getFinishedOrder];
}

#pragma mark - UIScrollViewDelegate

//禁止上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (Segment_Left == _curSel)
    {
        //内容大于屏幕，并且向上滑动
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
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POrderItemView2 *cell = [tableView dequeueReusableCellWithIdentifier:[POrderItemView2 getIdentifier]];
    
    if (nil == cell) {
        cell = [POrderItemView2 viewFromNib];
    }
    
    POrderInfo *info = _arrayOrder[indexPath.row];
    
    cell.lbSupplier.text = info.hzsName;
    cell.lbDate.text = _arrayOrder[indexPath.row].createTime;
    
    NSString *goods = info.goodsName;
    
    NSString *amount = info.number;
    
    
    if ([goods isEqualToString:SHUINI]
        || [goods isEqualToString:SHAZI]
        || [goods isEqualToString:SHIZI]
        || [goods isEqualToString:WAIJIAJI]) {
        NSString *variety = info.variety;
        
        cell.lbGoods.text = [NSString stringWithFormat:@"商品:%@ 品种:%@ 数量:%@吨", goods, variety, amount];
        
    } else {
        cell.lbGoods.text = [NSString stringWithFormat:@"商品:%@ 数量:%@吨", goods, amount];
    }    
    
    return cell;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    _curPage++;
    
    [self performSelector:@selector(getMoreFinishedOrder) withObject:nil afterDelay:1.0f];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    if (Segment_Left == _curSel)
    {
        [self performSelector:@selector(getUnfinishedOrder) withObject:nil afterDelay:1.0f];
    }
    else
    {
        _curPage = 1;
        [self performSelector:@selector(getFinishedOrder) withObject:nil afterDelay:1.0f];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupOrderProcessController *controller = [[SupOrderProcessController alloc] init];
    controller.orderInfo = _arrayOrder[indexPath.row];
    
    if (Segment_Left == _curSel) {
        controller.traceStatus = Status_Process;
    } else {
        controller.traceStatus = Status_History;
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [POrderItemView2 itemHeight];
}

@end
