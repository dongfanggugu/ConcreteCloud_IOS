//
//  SupplierDriverProcessController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplierDriverProcessController.h"
#import "PullTableView.h"
#import "SupDriverUnfinishedRequest.h"
#import "SupDriverUnfinishedResponse.h"
#import "KeyValueCell.h"
#import "SupStartUpRequest.h"
#import <AVFoundation/AVFoundation.h>
#import "JZLocationConverter.h"
#import <MapKit/MKMapItem.h>
#import <MapKit/MKTypes.h>
#import "Location.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "RoutePlanController.h"


@interface SupplierDriverProcessController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate,
                                            UIScrollViewDelegate, AVAudioPlayerDelegate, BMKRouteSearchDelegate>

@property (strong, nonatomic) PullTableView *tableView;

@property (assign, nonatomic) BOOL hasTask;

@property (assign, nonatomic) NSInteger dyIndex;

@property (strong, nonatomic) PTrackInfo *trackInfo;

@property (strong, nonatomic) HzsInfo *hzsInfo;

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;

@property (strong, nonatomic) UIButton *btnStart;

@property (strong, nonatomic) AVAudioPlayer *avAudioPlayer;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

@property (strong, nonatomic) CustomLocation *customLocation;

@end

@implementation SupplierDriverProcessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"执行中"];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTask];
}


- (void)routePlan:(CGFloat)lat lng:(CGFloat)lng
{
    BMKRouteSearch *routeSearch = [[BMKRouteSearch alloc] init];
    routeSearch.delegate = self;
    
    BMKDrivingRoutePlanOption *options = [[BMKDrivingRoutePlanOption alloc] init];
    
    options.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    
    CLLocationCoordinate2D coorStart;
    coorStart.latitude = lat;
    coorStart.longitude = lng;
    
    start.pt = coorStart;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    CLLocationCoordinate2D coorEnd;
    coorEnd.latitude = _hzsInfo.lat;
    coorEnd.longitude = _hzsInfo.lng;
    end.pt = coorEnd;
    
    options.from = start;
    options.to = end;
    
    BOOL suc = [routeSearch drivingSearch:options];
    
    if (suc) {
        NSLog(@"路线查找成功");
    }
    
}


#pragma mark - BMKRouteSearchDelegate

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    searcher.delegate = nil;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSInteger hour = 0;
        NSInteger minute = 0;
        NSInteger second = 0;
        
        NSInteger dis = 0;
        
        for (BMKDrivingRouteLine *node in result.routes) {
            
            hour += node.duration.hours;
            minute += node.duration.minutes;
            second += node.duration.seconds;
            
            dis += node.distance;
        }
        
        NSInteger duration = 60 * hour + minute;
        
        NSLog(@"duration:%ld分钟", duration);
        
        CGFloat distance = (CGFloat)dis / 1000;
        
        NSLog(@"distance:%lf公里", distance);
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"time"] = [NSNumber numberWithInteger:duration];
        
        param[@"distance"] = [NSNumber numberWithFloat:distance];
        
        param[@"supplierOrderProcessId"] = _trackInfo.processId;
        
        [[HttpClient shareClient] post:URL_B_DIS_TIME parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
            
        }];
        
    } else {
        NSLog(@"error code:%u", error);
    }
}

#pragma mark - 后台一直运行

/**
 *  检测后台时间是否到期，需要后台一直运行来进行定位
 */
- (void)startCheckBgRemain
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate.bgCheckTimer && delegate.bgCheckTimer.isValid) {
        return;
    }
    
    
    delegate.bgCheckTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                           selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
}

- (void)timerAdvanced:(NSTimer *)timer
{
    if([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0)
    {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"mp3"];
        NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
        
        if(!_avAudioPlayer) {
            _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            _avAudioPlayer.delegate = self;
            _avAudioPlayer.volume = 0.0f;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        }
        [self.avAudioPlayer play];
        
        __weak typeof (self) weakSelf = self;
        
        _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.bgTask != UIBackgroundTaskInvalid) {
                    weakSelf.bgTask = UIBackgroundTaskInvalid;
                }
            });
            
        }];
    } else {
        NSLog(@"left time >> 61");
    }
}


/**
 启动后台一直定位
 */
- (void)startBgLocation
{
    [[Location sharedLocation] startLocationService];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!delegate.locationTimer) {
        delegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [[Location sharedLocation] startLocationService];
        }];
    }
}

/**
 距离和时间预估定时器
 */
- (void)startDisAndTime
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _customLocation = [[CustomLocation alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomLocationComplete:)
                                                 name:Custom_Location_Complete object:nil];
    
    [_customLocation startLocationService];
    
    
    
    __weak typeof (self) weakSelf = self;
    
    if (!appDelegate.disAndTimeTimer)
    {
        appDelegate.disAndTimeTimer = [NSTimer scheduledTimerWithTimeInterval:3 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(onCustomLocationComplete:)
                                                         name:Custom_Location_Complete object:nil];
            
            [weakSelf.customLocation startLocationService];
        }];
        
    }
}

#pragma mark - 定位完成

- (void)onCustomLocationComplete:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Custom_Location_Complete object:nil];
    
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo) {
        NSLog(@"定位失败");
        return;
    } else {
        NSLog(@"定位成功");
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    [self routePlan:userLocation.location.coordinate.latitude lng:userLocation.location.coordinate.longitude];
}

- (void)onLocationComplete:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo)
    {
        NSLog(@"定位失败");
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *date = [Utils formatDate:[NSDate date]];
    
    dic[@"createTime"] = date;
    dic[@"orderProcessId"] = _trackInfo.processId;
    dic[@"plateNum"] = _vehicleInfo.plateNum;
    dic[@"lat"] = [NSNumber numberWithFloat:userLocation.location.coordinate.latitude];
    dic[@"lng"] = [NSNumber numberWithFloat:userLocation.location.coordinate.longitude];
    
    NSMutableArray *param = [NSMutableArray array];
    [param addObject:dic];
    
    [[HttpClient shareClient] post:URL_SUPPLIER_UPLOAD_LOCATION parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
        
    }];
    
}

- (void)dealloc
{
    
}

- (void)initData
{
    _dyIndex = 0;
}

- (void)setHasTask:(BOOL)hasTask
{
    _hasTask = hasTask;
    if (hasTask)
    {
        _btnStart.hidden = NO;
    }
    else
    {
        _btnStart.hidden = YES;
        [_tableView reloadData];
    }
    
    [self initTableTitleView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    
    [self.view addSubview:_tableView];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];
    
    _btnStart = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    _btnStart.layer.masksToBounds = YES;
    _btnStart.layer.cornerRadius = 5;
    
    _btnStart.backgroundColor = [Utils getColorByRGB:@"#2ecc71"];
    [_btnStart setTitle:@"启运" forState:UIControlStateNormal];
    _btnStart.titleLabel.font = [UIFont systemFontOfSize:13];
    [_btnStart addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footView;
    
    _btnStart.center = CGPointMake(self.view.frame.size.width / 2, 40);
    [footView addSubview:_btnStart];
    
}

- (void)initTableTitleView
{
    if (_hasTask)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        headerView.backgroundColor = [Utils getColorByRGB:@"#AAAAAA"];
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 25)];
        view.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
        view.center = CGPointMake(20, 20);
        [headerView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"正在执行的运输单";
        label.center = CGPointMake(90, 20);
        [headerView addSubview:label];
        
        UIButton *btnNavi = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
        [btnNavi setTitle:@"导航" forState:UIControlStateNormal];
        btnNavi.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnNavi setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
        btnNavi.center = CGPointMake(self.screenWidth - 20, 20);
        
        [btnNavi addTarget:self action:@selector(navigation) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btnNavi];
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 30)];
        sepView.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
        sepView.center = CGPointMake(self.screenWidth - 44, 20);
        [headerView addSubview:sepView];
        
        UIButton *btnPlan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
        [btnPlan setTitle:@"路径规划" forState:UIControlStateNormal];
        btnPlan.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnPlan setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
        btnPlan.center = CGPointMake(self.screenWidth - 83, 20);
        
        [btnPlan addTarget:self action:@selector(routePlan) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:btnPlan];
        
        
        _tableView.tableHeaderView = headerView;
    }
    else
    {
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}


- (void)clickStart
{
    
    NSInteger state = _trackInfo.state.integerValue;
    
    if (1 == state) {
        SupStartUpRequest *request = [[SupStartUpRequest alloc] init];
        
        
        request.taskId = _trackInfo.processId;
        
        [[HttpClient shareClient] view:self.view post:URL_SUP_START parameters:[request parsToDictionary]
                               success:^(NSURLSessionDataTask *task, id responseObject) {
            _trackInfo.state = @"2";
            [self start];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        
    } else if (state >= 2) {
        [self clickFinish];
    }
}



- (void)startLocationService
{
    //注册接收定位通知
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(onLocationComplete:)
                                                 name:Location_Complete object:nil];
    [self startCheckBgRemain];
    [self startBgLocation];
    [self startDisAndTime];
}

- (void)stopLocationService
{
    //取消接收定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.bgCheckTimer) {
        [appDelegate.bgCheckTimer invalidate];
        
        appDelegate.bgCheckTimer = nil;
    }
    
    
    if (appDelegate.locationTimer) {
        [appDelegate.locationTimer invalidate];
        appDelegate.locationTimer = nil;
    }
    
    if (appDelegate.disAndTimeTimer) {
        [appDelegate.disAndTimeTimer invalidate];
        appDelegate.disAndTimeTimer = nil;
    }
}

- (void)start
{
    [self startLocationService];
    _btnStart.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnStart setTitle:@"完成" forState:UIControlStateNormal];
    [_btnStart addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beStarted
{
    _btnStart.backgroundColor = [Utils getColorByRGB:@"#2ecc71"];
    [_btnStart setTitle:@"启运" forState:UIControlStateNormal];
    [_btnStart addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickFinish
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认完成该运输单?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SupStartUpRequest *request = [[SupStartUpRequest alloc] init];
        request.processId = _trackInfo.processId;
        
        [[HttpClient shareClient] view:self.view post:URL_SUP_COMPLETE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
            [self finish];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)finish
{
    self.hasTask = NO;
    [self stopLocationService];
}

#pragma mark - 网络请求

- (void)getTask
{
    SupDriverUnfinishedRequest *request = [[SupDriverUnfinishedRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing) {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        SupDriverUnfinishedResponse *response = [[SupDriverUnfinishedResponse alloc] initWithDictionary:responseObject];
        
        if (!response.body.count) {
            self.hasTask = NO;
            [self stopLocationService];
            
        } else {
            self.hasTask = YES;
            _hzsInfo = [response getHzs];
            _trackInfo = [response getTask];
            _vehicleInfo = [response getVehicle];
            
            if (_trackInfo.state.integerValue >= 2) {
                [self start];
                
            } else {
                [self beStarted];
            }
        }
        [_tableView reloadData];
        
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
    
    if (!_hasTask) {
        return 0;
    }
    
    NSString *goods = _trackInfo.goodsName;
    
    if ([goods isEqualToString:OTHERS]) {
        _dyIndex = 5;
        
    } else if ([goods isEqualToString:WAIJIAJI]
             || [goods isEqualToString:KUANGFEN]
             || [goods isEqualToString:FENMEIHUI]) {
        _dyIndex = 6;
        
    } else {
        _dyIndex = 7;
        
    }
    
    return _dyIndex + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"搅拌站";
        cell.lbValue.text = _hzsInfo.name;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"地址";
        cell.lbValue.text = _hzsInfo.address;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"联系人";
        cell.lbValue.text = [NSString stringWithFormat:@"%@ %@", _trackInfo.orderUser, _trackInfo.orderTel];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车牌号";
        cell.lbValue.text = _trackInfo.plateNum;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"商品";
        cell.lbValue.text = _trackInfo.goodsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        NSString *goods = _trackInfo.goodsName;
        if ([goods isEqualToString:SHIZI]
            || [goods isEqualToString:SHAZI]
            || [goods isEqualToString:SHUINI]
            || [goods isEqualToString:WAIJIAJI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"品种";
            cell.lbValue.text = _trackInfo.variety;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:KUANGFEN]
                 || [goods isEqualToString:FENMEIHUI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"等级标准";
            cell.lbValue.text = _trackInfo.standard;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (6 == indexPath.row)
    {
        NSString *goods = _trackInfo.goodsName;
        
        if ([goods isEqualToString:SHIZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"粒径规格";
            cell.lbValue.text = _trackInfo.kld;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:SHAZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"细度模数";
            cell.lbValue.text = _trackInfo.kld;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:SHUINI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"强度等级";
            cell.lbValue.text = _trackInfo.intensityLevel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    if (_dyIndex == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"毛重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.weight];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"皮重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.net];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"净重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.number];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row)
    {
        CGFloat height = [KeyValueCell cellHeightWithContent:_hzsInfo.address];
        
        return height;
    }
    else
    {
        return [KeyValueCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_hasTask) {
        return 0;
        
    } else {
        return 80;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_hasTask)
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无未完成运输单";
        
        return label;
    }
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getTask) withObject:nil afterDelay:0.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}

#pragma mark -- UIScrollViewDelegate

//禁止上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
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


#pragma mark - 导航


- (void)routePlan
{
    RoutePlanController *controller = [[RoutePlanController alloc] init];
    
    CLLocationCoordinate2D coorEnd;
    
    coorEnd.latitude = _hzsInfo.lat;
    coorEnd.longitude = _hzsInfo.lng;
    
    controller.destination = coorEnd;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navigation
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"导航" message:@"选择您的导航应用"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    //苹果地图
    [controller addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLLocationCoordinate2D coor;
        
        coor.latitude = _hzsInfo.lat;
        coor.longitude = _hzsInfo.lng;
        
        [self navAppleMapWithDes:coor];
    }]];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [controller addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving",
                                    _hzsInfo.lat, _hzsInfo.lng, _hzsInfo.name]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }]];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [controller addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor;
            
            coor.latitude = _hzsInfo.lat;
            coor.longitude = _hzsInfo.lng;
            
            CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:coor];
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",
                                    @"导航功能", _hzsInfo.name, gcj.latitude, gcj.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [controller addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor;
            
            coor.latitude = _hzsInfo.lat;
            coor.longitude = _hzsInfo.lng;
            
            CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:coor];
            
            
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=搅拌站&coord_type=1&policy=0",
                                    gcj.latitude, gcj.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
    }
    
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

//苹果地图
- (void)navAppleMapWithDes:(CLLocationCoordinate2D)destination
{
    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:destination];
    
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}


@end
