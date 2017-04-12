//
//  RenterTaskListController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/30.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RenterTaskListController.h"
#import "PullTableView.h"
#import "DTrackInfo.h"
#import "TaskStatisticsController.h"
#import "ACheckListRequest.h"
#import "ACheckListResponse.h"
#import "RentTaskCell.h"
#import "RentTankerDetailController.h"

@interface RenterTaskListController ()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>
{
    PullTableView *_tableView;
    
    NSMutableArray<DTrackInfo *> *_arrayCheck;
    
    NSInteger _curPage;
}


@end

@implementation RenterTaskListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"历史运输单"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_search"]];
    
    [self initNaviBarLeft];
    
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

- (void)initNaviBarLeft
{
    UIView *naviBar = [self getNavigationBar];
    
    CGRect frame = naviBar.frame;
    
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"统计" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.center = CGPointMake(30, frame.size.height - 44 / 2);
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10;
    
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    
    [btn addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    
    [naviBar addSubview:btn];
}

- (void)onClickLeft
{
    TaskStatisticsController *controller = [[TaskStatisticsController alloc] init];
    
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
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth,
                                                                 self.screenHeight - 94 - 49)];
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
    controller.vehicleType = TANKER;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
