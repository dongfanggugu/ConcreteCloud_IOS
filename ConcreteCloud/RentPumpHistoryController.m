//
//  RentPumpHistoryController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentPumpHistoryController.h"
#import "PullTableView.h"
#import "ACheckListRequest.h"
#import "ACheckListResponse.h"
#import "RentTaskCell.h"
#import "TankerTaskDetailController.h"
#import "TaskStatisticsController.h"
#import "RentTankerDetailController.h"


@interface RentPumpHistoryController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>
{
    PullTableView *_tableView;
    
    NSMutableArray<DTrackInfo *> *_arrayCheck;
    
    NSInteger _curPage;
    
}

@end


@implementation RentPumpHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"历史运输单"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_search"]];
    
    [self initView];
    [self initData];
    
    [self getCheck];
    
}

- (void)onClickNavRight
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_message_controller"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)initData
{
    _curPage = 1;
    
    _arrayCheck = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width,
                                                                 self.view.frame.size.height - 94)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.pullDelegate = self;
    
    [self.view addSubview:_tableView];
}


#pragma mark - Network Request

- (void)getCheck
{
    _curPage = 1;
    
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.rows = 10;
    request.page = _curPage;
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_HISTORY parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        ACheckListResponse *response = [[ACheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayCheck removeAllObjects];
        [_arrayCheck addObjectsFromArray:[response getCheckList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getMoreCheck
{
    _curPage++;
    
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.rows = 10;
    request.page = _curPage;
    
    [[HttpClient shareClient] view:self.view post:URL_HZS_TASK_HISTORY parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsLoadingMore)
        {
            _tableView.pullTableIsLoadingMore = NO;
        }
        
        ACheckListResponse *response = [[ACheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayCheck addObjectsFromArray:[response getCheckList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        _curPage--;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayCheck.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:[RentTaskCell identifier]];
    
    if (!cell)
    {
        cell = [RentTaskCell cellFromNib];
    }
    
    DTrackInfo *info = _arrayCheck[indexPath.row];
    
    cell.lbSite.text = info.hzs_Order.siteName;
    
    cell.lbDate.text = info.startTime;
    
    cell.lbDriver.text = [NSString stringWithFormat:@"司机:%@", info.driverName];
    
    cell.lbTel.text = info.driverTel;
    
    cell.lbPart.text = [NSString stringWithFormat:@"部位:%@", info.hzs_Order.castingPart];
    
    cell.lbLevel.text = [NSString stringWithFormat:@"强度:%@", info.hzs_Order.intensityLevel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RentTaskCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RentTankerDetailController *controller = [[RentTankerDetailController alloc] init];
    controller.trackInfo = _arrayCheck[indexPath.row];
    controller.vehicleType = PUMP;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -- PullTableVeiwDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getCheck) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getMoreCheck) withObject:nil afterDelay:1.5f];
}


@end
