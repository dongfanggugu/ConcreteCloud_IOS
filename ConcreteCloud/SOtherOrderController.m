//
//  SOtherOrderController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOtherOrderController.h"
#import "DOrderInfo.h"
#import "PullTableView.h"
#import "SOrderItemCell2.h"
#import "DOrderRequest.h"
#import "DOrderListResponse.h"
#import "DOrderDetailController.h"

@interface SOtherOrderController()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PullTableViewDelegate>

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSMutableArray<DOrderInfo *> *arrayOrder;

@property NSInteger curSel;

@property NSInteger curPage;


@end


@implementation SOtherOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"进行中" right:@"历史订单"];
    
    [self initTableView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (0 == _curSel)
    {
        [self getUnfinishedOrder];
    }
    else
    {
        [self getFinishedOrder];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)initData
{
    _curSel = 0;
    _arrayOrder = [[NSMutableArray alloc] init];
}

- (void)initTableView
{
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.dataSource = self;
    
    
    //    UIEdgeInsets padding = _tableView.contentInset;
    //    padding.top = padding.top - 20;
    //    _tableView.contentInset = padding;
    
}

#pragma overload super method

- (void)onClickNavRight
{
    //    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    //    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"p_order_add"];
    //    self.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:controller animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - network request

- (void)getUnfinishedOrder
{
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.siteId = [[Config shareConfig] getBranchId];
    request.isComplete = @"0";
    request.page = -1;
    request.rows = 10;
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_D_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               
                               DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
                               
                               [weakSelf.arrayOrder removeAllObjects];
                               
                               [weakSelf.arrayOrder addObjectsFromArray:[response getOrderList]];
                               
                               [weakSelf.tableView reloadData];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
    
}

- (void)getFinishedOrder
{
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.siteId = [[Config shareConfig] getBranchId];
    request.isComplete = @"1";
    request.page = _curSel;
    request.rows = 10;
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_D_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
                               
                               [weakSelf.arrayOrder removeAllObjects];
                               
                               [weakSelf.arrayOrder addObjectsFromArray:[response getOrderList]];
                               
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

- (void)getMoreFinishedOrder
{
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.siteId = [[Config shareConfig] getBranchId];
    request.orderUserName = [[Config shareConfig] getName];
    request.isComplete = @"1";
    request.page = _curSel;
    request.rows = 10;
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               if (weakSelf.tableView.pullTableIsLoadingMore)
                               {
                                   weakSelf.tableView.pullTableIsLoadingMore = NO;
                               }
                               
                               DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
                               
                               [weakSelf.arrayOrder addObjectsFromArray:[response getOrderList]];
                               
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

#pragma mark - segment click callback

- (void)onClickLeftSegment
{
    NSLog(@"click left");
    _curSel = 0;
    [_arrayOrder removeAllObjects];
    [self getUnfinishedOrder];
}

- (void)onClickRightSegment
{
    NSLog(@"click right");
    _curSel = 1;
    _curPage = 1;
    [_arrayOrder removeAllObjects];
    [self getFinishedOrder];
}

#pragma mark - UIScrollViewDelegate

//禁止上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (0 == _curSel)
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
    SOrderItemCell2 *cell = [tableView dequeueReusableCellWithIdentifier:[SOrderItemCell2 identifier]];
    
    
    if (nil == cell)
    {
        cell = [SOrderItemCell2 cellFromNib];
    }
    
    DOrderInfo *info = _arrayOrder[indexPath.row];
    
    NSString *goods = info.goodsName;
    NSString *hzs = info.hzsName;
    NSString *part = info.castingPart;
    NSString *level = info.intensityLevel;
    NSString *date = info.createTime;
    
    cell.lbGoods.text = [NSString stringWithFormat:@"商品:%@", goods];
    cell.lbDate.text = date;
    cell.lbHzs.text = hzs;
    cell.lbPart.text = [NSString stringWithFormat:@"部位:%@", part];
    cell.lbStrength.text = [NSString stringWithFormat:@"强度:%@", level];
    
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
    
    if (0 == _curSel)
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
    DOrderDetailController *controller = [[DOrderDetailController alloc] init];
    controller.orderInfo = _arrayOrder[indexPath.row];
    controller.role = Role_Site_Staff;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SOrderItemCell2 cellHeight];
}

@end
