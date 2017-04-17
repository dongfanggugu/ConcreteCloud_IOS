//
//  TankerArrivedController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TankerArrivedController.h"
#import "KeyValueCell.h"
#import "ACheckVideoCell.h"
#import "TaskFinishRequest.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "JZLocationConverter.h"
#import <MapKit/MKMapItem.h>
#import <MapKit/MKTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "Location.h"
#import "AppDelegate.h"


@interface TankerArrivedController()<UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate,
                                    BMKRouteSearchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnNav;

@property (weak, nonatomic) IBOutlet UIButton *btnPlan;

@property (strong, nonatomic) IBOutlet UIButton *btnHzs;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

@property (strong, nonatomic) CustomLocation *customLocation;

@property (strong, nonatomic) CustomLocation *disAndTimeLocation;

@end

@implementation TankerArrivedController

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}



/**
 路径查找

 @param lat 起始点纬度
 @param lng 起始点经度
 */
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


#pragma mark - 后台一直运行

/**
 *  检测后台时间是否到期，需要后台一直运行来进行定位
 */
- (void)startCheckBgRemain
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.bgCheckTimer)
    {
    
        appDelegate.bgCheckTimer = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
       
            [self timerAdvanced];
        }];
    }
}

- (void)timerAdvanced
{
    
     NSLog(@"left time:%lf", [[UIApplication sharedApplication] backgroundTimeRemaining]);
    
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
        [_avAudioPlayer play];
        
        _bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_bgTask != UIBackgroundTaskInvalid) {
                    _bgTask = UIBackgroundTaskInvalid;
                }
            });
            
        }];
    }
    else
    {
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
    
    if (!appDelegate.locationTimer)
    {
        appDelegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"dis", @"key", nil];
    _disAndTimeLocation = [[CustomLocation alloc] initLocationWith:dic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomLocationComplete:)
                                                 name:Custom_Location_Complete object:nil];
    
    [_disAndTimeLocation startLocationService];
    
    __weak typeof (self) weakSelf = self;
    
    if (!appDelegate.disAndTimeTimer)
    {
        appDelegate.disAndTimeTimer = [NSTimer scheduledTimerWithTimeInterval:3 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            [weakSelf.disAndTimeLocation startLocationService];
        }];
        
    }
}

#pragma mark - 定位完成

- (void)onLocationComplete:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo) {
        NSLog(@"位置定位失败");
        return;
    } else {
        NSLog(@"位置定位完成");
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

- (void)onCustomLocationComplete:(NSNotification *)notify
{
    _customLocation = nil;
    
    NSDictionary *userInfo = notify.userInfo;
    
    
    if (!userInfo) {
        
        [HUDClass showHUDWithText:@"定位失败,请检查网络和定位设置再试!"];
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    NSDictionary *customInfo = userInfo[User_Custom];

    if (!customInfo) {
        [self getDisLimit:userLocation.location.coordinate];
        
    } else {
        [self routePlan:userLocation.location.coordinate.latitude lng:userLocation.location.coordinate.longitude];
    }
}

//- (void)uploaddisAndTime:(NSNotification *)notify
//{
//    NSDictionary *userInfo = notify.userInfo;
//    
//    if (!userInfo) {
//        NSLog(@"时间距离定位失败");
//        return;
//    } else {
//        NSLog(@"时间距离定位成功");
//    }
//    
//    BMKUserLocation *userLocation = userInfo[User_Location];
//    
//    
//}

- (void)dealloc
{
    NSLog(@"TankerArrivedController dealloc");
    
    //取消接收定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)initView
{
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    
     _tableView.tableFooterView = footView;
    
    _btnHzs = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    _btnHzs.layer.masksToBounds = YES;
    _btnHzs.layer.cornerRadius = 5;
    
    _btnHzs.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnHzs setTitle:@"到站" forState:UIControlStateNormal];
    _btnHzs.titleLabel.font = [UIFont systemFontOfSize:13];
    [_btnHzs addTarget:self action:@selector(clickHzs) forControlEvents:UIControlEventTouchUpInside];
    
    _btnHzs.center = CGPointMake(self.screenWidth / 2, 30);
    [footView addSubview:_btnHzs];
    
    CGFloat state = _trackInfo.state.floatValue;
    
    if (state != -1 && _arrayType == ARRIVED_TANKER) {
        _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        
        _btnBack.layer.masksToBounds = YES;
        _btnBack.layer.cornerRadius = 5;
        
        _btnBack.backgroundColor = [UIColor lightGrayColor];
        [_btnBack setTitle:@"工程退货" forState:UIControlStateNormal];
        _btnBack.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        
        _btnBack.center = CGPointMake(self.screenWidth / 2, 80);
        [footView addSubview:_btnBack];
    }
    
    //导航功能
    [_btnNav addTarget:self action:@selector(navigation) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 导航

- (void)navigation
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"导航" message:@"选择您的导航应用"
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    //苹果地图
    [controller addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLLocationCoordinate2D coor;
        
        coor.latitude = _trackInfo.hzs_Order.hzsLat;
        coor.longitude = _trackInfo.hzs_Order.hzsLng;
        
        [self navAppleMapWithDes:coor];
    }]];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [controller addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving",
                                    _trackInfo.hzs_Order.hzsLat, _trackInfo.hzs_Order.hzsLng, _trackInfo.hzs_Order.hzsName]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }]];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [controller addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor;
            
            coor.latitude = _trackInfo.hzs_Order.hzsLat;
            coor.longitude = _trackInfo.hzs_Order.hzsLng;
            
            CLLocationCoordinate2D gcj = [JZLocationConverter bd09ToGcj02:coor];
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",
                                    @"导航功能", _trackInfo.hzs_Order.hzsName, gcj.latitude, gcj.longitude]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
    {
        [controller addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLLocationCoordinate2D coor;
            
            coor.latitude = _trackInfo.hzs_Order.hzsLat;
            coor.longitude = _trackInfo.hzs_Order.hzsLng;
            
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

- (void)clickHzs
{
    TaskFinishRequest *request = [[TaskFinishRequest alloc] init];
    request.hzsOrderProcessId = _trackInfo.trackId;
    request.back = @"0";
    
    [[HttpClient shareClient] view:self.view post:URL_FINISH_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickHzs)]) {
            [_delegate onClickHzs];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


/**
 退货流程:三次确认,然后定位,获取距离限制,计算是否距离符合限制,最后退货
 */
- (void)clickBack
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"确定要退灰?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showBackAgain];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)showBackAgain
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"再次确定要退灰?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showBackLast];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showBackLast
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"最后确定要退灰?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self customLoaction];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)customLoaction
{
    _customLocation = [[CustomLocation alloc] initLocationWith:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomLocationComplete:)
                                                 name:Custom_Location_Complete object:nil];
    
    [_customLocation startLocationService];
}


- (void)taskBackWithLimit:(NSInteger)limit location:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D siteLocation;
    
    siteLocation.latitude = _trackInfo.hzs_Order.siteLat;
    siteLocation.longitude = _trackInfo.hzs_Order.siteLng;
    
    NSInteger dis = (NSInteger)[CustomLocation distancePoint:location with:siteLocation];
    
    if (dis > limit) {
        [HUDClass showHUDWithText:@"您距离工地太远,无法退灰"];
        return;
    }
    
    TaskFinishRequest *request = [[TaskFinishRequest alloc] init];
    request.hzsOrderProcessId = _trackInfo.trackId;
    request.back = @"1";
    
    [[HttpClient shareClient] view:self.view post:URL_FINISH_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        _trackInfo.state = @"-1";
        
        [HUDClass showHUDWithText:@"退灰成功!"];
        if (_btnBack) {
            [_btnBack removeFromSuperview];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)record
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickRecord:)]) {
        [_delegate onClickRecord:_trackInfo];
    }
}
#pragma mark - 网络请求

- (void)getDisLimit:(CLLocationCoordinate2D)coor
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"hzsId"] = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_START_UP_LIMIT parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSInteger limit = [[[responseObject objectForKey:@"body"] objectForKey:@"region"] integerValue];
                               
                               NSLog(@"limit:%ld", limit);
                               [self taskBackWithLimit:limit location:coor];
                               
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
    
    if (_arrayType == ARRIVED_TANKER)
    {
        return 5;
    }
    else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
    
        cell.lbKey.text = @"工程";
        cell.lbValue.text = _trackInfo.hzs_Order.siteName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"工程地址";
        cell.lbValue.text = _trackInfo.hzs_Order.siteAddress;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = _trackInfo.hzs_Order.castingPart;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = _trackInfo.hzs_Order.intensityLevel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        ACheckVideoCell *cell = [ACheckVideoCell cellFromNib];
        cell.lbKey.text = @"视频拍摄";
        
        if (_trackInfo.spotVideo) {
            cell.url = _trackInfo.spotVideo;
            
        } else {
            cell.btnRecord.hidden = NO;
            [cell.btnRecord addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row)
    {
        return [KeyValueCell cellHeightWithContent:_trackInfo.hzs_Order.siteAddress];
    }
    else if (4 == indexPath.row)
    {
        return [ACheckVideoCell cellHeight];
    }
    
    return [KeyValueCell cellHeight];
}

@end
