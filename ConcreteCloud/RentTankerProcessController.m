//
//  RentTankerProcessController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentTankerProcessController.h"
#import "UpWorkRequest.h"
#import "WorkStateRequest.h"
#import "WorkStateResponse.h"
#import "RentVehicleController.h"
#import "RentTankerRelaxController.h"
#import "TankerOnWayController.h"
#import "TankerArrivedController.h"
#import "SPumpListResponse.h"
#import "RentBindRequest.h"
#import "RentVehicleInfo.h"
#import "RentWorkStateResponse.h"
#import "VideoRecordController.h"
#import <AVFoundation/AVFoundation.h>
#import "Location.h"

typedef NS_ENUM(NSInteger, RENT_WORK_STATE) {
    RELAX,
    BUSY
};

typedef NS_ENUM(NSInteger, RENT_VEHICLE_STATE) {
    VEHICLE_RELAX,
    VEHICLE_BUSY
};

@interface RentTankerProcessController()<RentVehicleControllerDelegate, RentTankerRelaxControllerDelegate,
                        TankerOnWayControllerDelegate, TankerArrivedControllerDelegate,
                        VideoRecordControllerDelegate, AVAudioPlayerDelegate> {
    UIButton *_btnState;
    
    UILabel *_lbState;
    
    __weak UIViewController *_curController;
    
    UIButton *_btnVehicleState;
    
    UILabel  *_lbVehicleState;
}

@property (assign, nonatomic) RENT_WORK_STATE workState;

@property (assign, nonatomic) RENT_VEHICLE_STATE vehicleState;

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic) __block UIBackgroundTaskIdentifier bgTask;

@end


@implementation RentTankerProcessController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"执行运输单"];
    
    //[self initNavRightWithImage:[UIImage imageNamed:@"icon_msg"]];
    
    [self initView];
    [self initData];
    [self getCurWorkState];
}

- (void)onClickNavRight
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_message_controller"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    dic[@"id"] = _vehicleInfo.vehicleId;
    dic[@"lat"] = [NSNumber numberWithFloat:userLocation.location.coordinate.latitude];
    dic[@"lng"] = [NSNumber numberWithFloat:userLocation.location.coordinate.longitude];
    
    NSArray *param = [NSArray arrayWithObjects:dic, nil];
    
    [[HttpClient shareClient] post:URL_RENT_RELAX_UPLOAD_LOCATION parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
        
    }];

}

- (void)dealloc
{
    [self stopLocationService];
}

- (void)initData
{
}

- (void)initView
{
    [self initNaviLeftAndRight];
}

- (void)relax
{
    if (_curController)
    {
        [_curController.view removeFromSuperview];
        [_curController removeFromParentViewController];
        _curController = nil;
    }
    
    RentTankerRelaxController *controller = [[RentTankerRelaxController alloc] init];
    controller.delegate = self;
    controller.vehicleInfo = _vehicleInfo;
    self.delegate = controller;
    
    _curController = controller;
    [self addChildViewController:controller];
    
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 94;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - 94 - 49;
    
    controller.view.frame = frame;
    
    [self.view addSubview:controller.view];
}

- (void)onWay:(DTrackInfo *)trackInfo
{
    if (_curController)
    {
        [_curController.view removeFromSuperview];
        [_curController removeFromParentViewController];
        _curController = nil;
    }
    
    TankerOnWayController *controller = [[TankerOnWayController alloc] init];
    controller.trackInfo = trackInfo;
    controller.delegate = self;
    
    _curController = controller;
    [self addChildViewController:controller];
    
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 94;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - 94 - 49;
    
    controller.view.frame = frame;
    
    [self.view addSubview:controller.view];
}

- (void)arrived:(DTrackInfo *)trackInfo
{
    if (_curController)
    {
        [_curController.view removeFromSuperview];
        [_curController removeFromParentViewController];
        _curController = nil;
    }
    
    TankerArrivedController *controller = [[TankerArrivedController alloc] init];
    controller.trackInfo = trackInfo;
    controller.arrayType = ARRIVED_TANKER;
    controller.delegate = self;
    
    _curController = controller;
    [self addChildViewController:controller];
    
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 94;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - 94 - 49;
    
    controller.view.frame = frame;
    
    [self.view addSubview:controller.view];
}

- (void)initNaviLeftAndRight
{
    UIView *naviBar = [self getNavigationBar];
    
    CGRect frame = naviBar.frame;
    
    //上下班
    _btnState = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_btnState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
    [_btnState addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
    
    _btnState.center = CGPointMake(40, frame.size.height - 44 / 2);
    
    _lbState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _lbState.textColor = [UIColor whiteColor];
    _lbState.text = @"下班";
    _lbState.font = [UIFont systemFontOfSize:13];
    _lbState.center = CGPointMake(80, frame.size.height - 44 / 2);
    
    
    [naviBar addSubview:_btnState];
    [naviBar addSubview:_lbState];
    
    //忙闲
    _btnVehicleState = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_btnVehicleState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
    [_btnVehicleState addTarget:self action:@selector(changeVehicleState) forControlEvents:UIControlEventTouchUpInside];
    
    _btnVehicleState.center = CGPointMake(frame.size.width - 60, frame.size.height - 44 / 2);
    
    _lbVehicleState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    _lbVehicleState.textColor = [UIColor whiteColor];
    _lbVehicleState.text = @"闲";
    _lbVehicleState.font = [UIFont systemFontOfSize:13];
    _lbVehicleState.center = CGPointMake(frame.size.width - 30, frame.size.height - 44 / 2);
    
    
    [naviBar addSubview:_btnVehicleState];
    [naviBar addSubview:_lbVehicleState];
    
    
    //初始化状态
    self.workState = RELAX;
    self.vehicleState = VEHICLE_RELAX;
}


- (void)setWorkState:(RENT_WORK_STATE)state
{
    _workState = state;
    
    if (RELAX == _workState) {
        [_btnState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
        _lbState.text = @"下班";
        
        _btnVehicleState.hidden = YES;
        _lbVehicleState.hidden = YES;
        
        [[Config shareConfig] setOperable:NO];
        
    } else {
        [_btnState setImage:[UIImage imageNamed:@"icon_busy"] forState:UIControlStateNormal];
        _lbState.text = @"上班";
        
        _btnVehicleState.hidden = NO;
        _lbVehicleState.hidden = NO;
        
        self.vehicleState = VEHICLE_RELAX;
    }
}

- (void)setVehicleState:(RENT_VEHICLE_STATE)vehicleState
{
    _vehicleState = vehicleState;
    
    if (VEHICLE_RELAX == _vehicleState) {
        [_btnVehicleState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
        _lbVehicleState.text = @"闲";
        
        [[Config shareConfig] setOperable:NO];
        [self startLocationService];
        
    } else {
        [_btnVehicleState setImage:[UIImage imageNamed:@"icon_busy"] forState:UIControlStateNormal];
        _lbVehicleState.text = @"忙";
        
        [[Config shareConfig] setOperable:YES];
        
        [self stopLocationService];
    }
    
}


- (void)startLocationService
{
    //注册接收定位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:)
                                                 name:Location_Complete object:nil];
    [self startCheckBgRemain];
    [self startBgLocation];
}

- (void)stopLocationService
{
    //取消接收定位通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)changeVehicleState
{
    if (VEHICLE_RELAX == self.vehicleState)
    {
        self.vehicleState = VEHICLE_BUSY;
    }
    else
    {
        self.vehicleState = VEHICLE_RELAX;
    }
}

- (void)changeState
{
    if (RELAX == _workState) {
        RentVehicleController *controller = [[RentVehicleController alloc] init];
        controller.vehicleType = TANKER;
        controller.delegate = self;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    } else {
        if (![_curController isKindOfClass:[RentTankerRelaxController class]]) {
            [HUDClass showHUDWithText:@"运输单执行中,无法下班"];
            return;
        }
        //下班
        RentBindRequest *request = [[RentBindRequest alloc] init];
        request.vehicelId = _vehicleInfo.vehicleId;
        request.driverId = [[Config shareConfig] getUserId];
        
        [[HttpClient shareClient] view:self.view post:URL_RENT_UNBIND parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
            self.workState = RELAX;
            
            _vehicleInfo = nil;
            
            if (_delegate && [_delegate respondsToSelector:@selector(onGetVehicle:)]) {
                [_delegate onGetVehicle:nil];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
    }
}

#pragma mark - RentVehicleControllerDelegate

- (void)onSelectVehicle:(RentVehicleInfo *)vehicleInfo
{
    _vehicleInfo = vehicleInfo;
    RentBindRequest *request = [[RentBindRequest alloc] init];
    request.vehicelId = vehicleInfo.vehicleId;
    request.driverId = [[Config shareConfig] getUserId];
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_BIND parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        self.workState = BUSY;
        
        if (_delegate && [_delegate respondsToSelector:@selector(onGetVehicle:)])
        {
            [_delegate onGetVehicle:vehicleInfo];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

#pragma mark - Network Request

- (void)getCurWorkState
{
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_CUR_VEHICLE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RentWorkStateResponse *response = [[RentWorkStateResponse alloc] initWithDictionary:responseObject];
        
        _vehicleInfo = [response getVehicleInfo];
        
        if (_vehicleInfo) {
            self.workState = BUSY;
            
            [self getUnfinishedTask];
            
        } else {
            self.workState = RELAX;
            [self relax];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getUnfinishedTask
{
    [[HttpClient shareClient] view:self.view post:URL_UNFINISHED_TASK parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SPumpListResponse *response = [[SPumpListResponse alloc] initWithDictionary:responseObject];
        NSArray<DTrackInfo *> *array = [response getPumpList];
        
        if (!array || 0 == array.count) {
            self.vehicleState = VEHICLE_RELAX;
            [self relax];
            
        } else {
            self.vehicleState = VEHICLE_BUSY;
            
            DTrackInfo *info = array[0];
            
            CGFloat state = info.state.floatValue;
            
            if (state < 2.5 && state > 0) {
                [self onWay:info];
                
            } else {
                [self arrived:info];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


#pragma mark - RentTankerRelaxControllerDelegate


- (void)onClickStartUp:(DTrackInfo *)trackInfo
{
    [self onWay:trackInfo];
}

#pragma mark - TankerOnWayControllerDelegate

- (void)onClickArrived:(DTrackInfo *)trackInfo
{
    [self arrived:trackInfo];
}

#pragma mark - TankerArrivedControllerDelegate

- (void)onClickHzs
{
    [self relax];
}

- (void)onClickRecord:(DTrackInfo *)trackInfo
{
    VideoRecordController *controller = [[VideoRecordController alloc] init];
    controller.videoKey = trackInfo.trackId;
    controller.delegate = self;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - VideoRecordControllerDelegate

- (void)onUploadVideo:(NSString *)url videoKey:(NSString *)videoKey
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"spotVideo"] = url;
    dic[@"hzsOrderProcessId"] = videoKey;
    
    [[HttpClient shareClient] view:self.view post:URL_A_CHECK_SPOT parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"现场视频上传成功"];
        [self getUnfinishedTask];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
