//
//  TankerOnWayController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TankerOnWayController.h"
#import "KeyValueCell.h"
#import "ArrivedSiteRequest.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "JZLocationConverter.h"
#import <MapKit/MKMapItem.h>
#import <MapKit/MKTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "Location.h"



@interface TankerOnWayController()<UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate,
                                    BMKRouteSearchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnNav;

@property (weak, nonatomic) IBOutlet UIButton *btnPlan;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

@property (strong, nonatomic) CustomLocation *customLocation;

@end

@implementation TankerOnWayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册接收定位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:)
                                                 name:Location_Complete object:nil];
    [self startCheckBgRemain];
    [self startBgLocation];
    [self startDisAndTime];
    
    [self initView];
    
}

- (void)dealloc
{
    //取消接收定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    coorEnd.latitude = _trackInfo.hzs_Order.siteLat;
    coorEnd.longitude = _trackInfo.hzs_Order.siteLng;
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
        
        param[@"hzsOrderProcessId"] = _trackInfo.trackId;
        
        [[HttpClient shareClient] post:URL_A_DIS_TIME parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
            
        }];
        
    } else {
        NSLog(@"error code:%u", error);
    }
}


- (void)initView
{
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [btn setTitle:@"到达工程" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickArrived) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footView;
    
    btn.center = CGPointMake(self.screenWidth / 2, 40);
    [footView addSubview:btn];
    
    //导航功能
    [_btnNav addTarget:self action:@selector(navigation) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 后台一直运行

/**
 *  检测后台时间是否到期，需要后台一直运行来进行定位
 */
- (void)startCheckBgRemain
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.bgCheckTimer) {
        
        appDelegate.bgCheckTimer = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            [self timerAdvanced];
        }];
    }
}

- (void)timerAdvanced
{
    
    NSLog(@"left time:%lf", [[UIApplication sharedApplication] backgroundTimeRemaining]);
    
    if([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"mp3"];
        NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
        
        if(!_avAudioPlayer) {
            _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            _avAudioPlayer.delegate = self;
            _avAudioPlayer.volume = 0.0f;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        }
        
        [_avAudioPlayer play];
        
        _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_bgTask != UIBackgroundTaskInvalid) {
                    _bgTask = UIBackgroundTaskInvalid;
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.locationTimer) {
        appDelegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer * _Nonnull timer) {
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
    
    if (!userInfo) {
        NSLog(@"定位失败");
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *date = [Utils formatDate:[NSDate date]];
    
    dic[@"createTime"] = date;
    dic[@"hzsOrderProcessId"] = _trackInfo.trackId;
    dic[@"vehicleId"] = _trackInfo.vehicleId;
    dic[@"lat"] = [NSNumber numberWithFloat:userLocation.location.coordinate.latitude];
    dic[@"lng"] = [NSNumber numberWithFloat:userLocation.location.coordinate.longitude];
    
    NSArray *param = [NSArray arrayWithObjects:dic, nil];
    
    [[HttpClient shareClient] post:URL_VEHICLE_UPLOAD_LOCATION parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
        
    }];
    
}


#pragma mark - 导航

- (void)navigation
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"导航" message:@"选择您的导航应用"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    //苹果地图
    [controller addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLLocationCoordinate2D coor;
        
        coor.latitude = _trackInfo.hzs_Order.siteLat;
        coor.longitude = _trackInfo.hzs_Order.siteLng;
        
        [self navAppleMapWithDes:coor];
    }]];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [controller addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving",
                                    _trackInfo.hzs_Order.siteLat, _trackInfo.hzs_Order.siteLng, _trackInfo.hzs_Order.siteName]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }]];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [controller addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor;
            
            coor.latitude = _trackInfo.hzs_Order.siteLat;
            coor.longitude = _trackInfo.hzs_Order.siteLng;
            
            CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:coor];
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",
                                    @"导航功能", _trackInfo.hzs_Order.siteName, gcj.latitude, gcj.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
    {
        [controller addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor;
            
            coor.latitude = _trackInfo.hzs_Order.siteLat;
            coor.longitude = _trackInfo.hzs_Order.siteLng;
            
            CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:coor];
            
            
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=电梯报警&coord_type=1&policy=0",
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

- (void)clickArrived
{
    ArrivedSiteRequest *request = [[ArrivedSiteRequest alloc] init];
    
    request.taskId = _trackInfo.trackId;
    
    [[HttpClient shareClient] view:self.view post:URL_ARRIVED_SITE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
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
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickArrived:)]) {
            [_delegate onClickArrived:_trackInfo];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

#pragma mark - UITableViewDelegate

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
    KeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:[KeyValueCell getIdentifier]];
    
    if (!cell)
    {
        cell = [KeyValueCell viewFromNib];
    }
    
    if (0 == indexPath.row)
    {
        cell.lbKey.text = @"工程";
        cell.lbValue.text = _trackInfo.hzs_Order.siteName;
    }
    else if (1 == indexPath.row)
    {
        cell.lbKey.text = @"工程地址";
        cell.lbValue.text = _trackInfo.hzs_Order.siteAddress;
    }
    else if (2 == indexPath.row)
    {
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = _trackInfo.hzs_Order.castingPart;
    }
    else if (3 == indexPath.row)
    {
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = _trackInfo.hzs_Order.intensityLevel;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row)
    {
        return [KeyValueCell cellHeightWithContent:_trackInfo.hzs_Order.siteAddress];
    }
    
    return [KeyValueCell cellHeight];
}

@end
