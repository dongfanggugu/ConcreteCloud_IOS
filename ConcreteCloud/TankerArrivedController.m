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
#import "JZLocationConverter.h"
#import <MapKit/MKMapItem.h>
#import <MapKit/MKTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "Location.h"
#import "AppDelegate.h"


@interface TankerArrivedController()<UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnNav;

@property (weak, nonatomic) IBOutlet UIButton *btnPlan;

@property (strong, nonatomic) IBOutlet UIButton *btnHzs;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

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
    
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
        
        if(!_avAudioPlayer)
        {
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
        appDelegate.locationTimer = [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [[Location sharedLocation] startLocationService];
        }];
        
    }
}

#pragma mark - 定位完成

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
    dic[@"hzsOrderProcessId"] = _trackInfo.trackId;
    dic[@"vehicleId"] = _trackInfo.vehicleId;
    dic[@"lat"] = [NSNumber numberWithFloat:userLocation.location.coordinate.latitude];
    dic[@"lng"] = [NSNumber numberWithFloat:userLocation.location.coordinate.longitude];
    
    NSArray *param = [NSArray arrayWithObjects:dic, nil];
    
    [[HttpClient shareClient] post:URL_VEHICLE_UPLOAD_LOCATION parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
        
    }];
    
}

- (void)dealloc
{
    NSLog(@"TankerArrivedController dealloc");
    
    //取消接收定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    if (_locationTimer)
//    {
//        [_locationTimer invalidate];
//    }
//    
//    if (_bgCheckTimer)
//    {
//        [_bgCheckTimer invalidate];
//    }
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
    
    _btnHzs.center = CGPointMake(self.view.frame.size.width / 2, 30);
    [footView addSubview:_btnHzs];
    
    CGFloat state = _trackInfo.state.floatValue;
    
    if (state != -1 && _arrayType == ARRIVED_TANKER)
    {
        _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        
        _btnBack.layer.masksToBounds = YES;
        _btnBack.layer.cornerRadius = 5;
        
        _btnBack.backgroundColor = [UIColor lightGrayColor];
        [_btnBack setTitle:@"工程退货" forState:UIControlStateNormal];
        _btnBack.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        
        _btnBack.center = CGPointMake(self.view.frame.size.width / 2, 80);
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
        
        if (appDelegate.bgCheckTimer)
        {
            [appDelegate.bgCheckTimer invalidate];
            
            appDelegate.bgCheckTimer = nil;
        }
        
        
        if (appDelegate.locationTimer)
        {
            [appDelegate.locationTimer invalidate];
            appDelegate.locationTimer = nil;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickHzs)])
        {
            [_delegate onClickHzs];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)clickBack
{
    TaskFinishRequest *request = [[TaskFinishRequest alloc] init];
    request.hzsOrderProcessId = _trackInfo.trackId;
    request.back = @"1";
    
    [[HttpClient shareClient] view:self.view post:URL_FINISH_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        _trackInfo.state = @"-1";
        
        if (_btnBack)
        {
            [_btnBack removeFromSuperview];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)record
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickRecord:)])
    {
        [_delegate onClickRecord:_trackInfo];
    }
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
        
        if (_trackInfo.spotVideo)
        {
            cell.url = _trackInfo.spotVideo;
        }
        else
        {
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
