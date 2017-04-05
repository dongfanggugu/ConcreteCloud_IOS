//
//  PMyOrderController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMyOrderController.h"
#import "PullTableView.h"
#import "POrderItemView2.h"
#import "POrderListRequest.h"
#import "POrderListResponse.h"
#import "POrderInfo.h"
#import "POrderDetailController.h"

@interface PMyOrderController()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PullTableViewDelegate>

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSMutableArray<POrderInfo *> *arrayOrder;

@property NSInteger curSel;

@property NSInteger curPage;

@end

@implementation PMyOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"进行中" right:@"历史订单"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_add"]];
    
    [self initTableView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

#pragma overload super method

- (void)onClickNavRight
{
    NSLog(@"on click right");
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"p_order_add"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - network request

- (void)getUnfinishedOrder
{
    POrderListRequest *request = [[POrderListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.is = @"1";
    request.type = [[Config shareConfig] getType];
    request.page = -1;
    request.rows = 10;
    request.ing = @"1";
    
    __weak typeof (self) weakSelf = self;
    
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
    request.hzsId = [[Config shareConfig] getBranchId];
    request.is = @"1";
    request.type = [[Config shareConfig] getType];
    request.page = _curSel;
    request.rows = 10;
    request.ing = @"2";
    
    __weak PMyOrderController *weakSelf = self;
    
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

- (void)getMoreFinishedOrder
{
    POrderListRequest *request = [[POrderListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.is = @"1";
    request.type = [[Config shareConfig] getType];
    request.page = _curPage;
    request.rows = 10;
    request.ing = @"2";
    
    __weak PMyOrderController *weakSelf = self;
    
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
    POrderItemView2 *cell = [tableView dequeueReusableCellWithIdentifier:[POrderItemView2 getIdentifier]];
    
    
    if (nil == cell)
    {
        cell = [POrderItemView2 viewFromNib];
    }
    
    cell.lbSupplier.text = _arrayOrder[indexPath.row].supplierName;
    cell.lbGoods.text = [NSString stringWithFormat:@"商品类型:%@", _arrayOrder[indexPath.row].goodsName];
    cell.lbDate.text = _arrayOrder[indexPath.row].createTime;

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
    POrderDetailController *controller = [[POrderDetailController alloc] init];
    controller.orderInfo = _arrayOrder[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [POrderItemView2 itemHeight];
}

@end
