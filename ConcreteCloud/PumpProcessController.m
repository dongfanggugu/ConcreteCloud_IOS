//
//  PumpProcessController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PumpProcessController.h"
#import "WorkStateResponse.h"
#import "WorkStateRequest.h"
#import "UpWorkRequest.h"
#import "TankerOnWayController.h"
#import "SPumpListResponse.h"
#import "TankerArrivedController.h"
#import "PumpRelaxController.h"


typedef NS_ENUM(NSInteger, WORK_STATE)
{
    RELAX,
    BUSY
};

@interface PumpProcessController()<PumpRelaxControllerDelegate, TankerOnWayControllerDelegate, TankerArrivedControllerDelegate>
{
    UIButton *_btnState;
    
    UILabel *_lbState;
    
    UIViewController *_curController;
}

@property (assign, nonatomic) WORK_STATE workState;

@end


@implementation PumpProcessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"执行运输单"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_msg"]];
    
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

- (void)initData
{
    [self getUnfinishedTask];
}

- (void)initView
{
    [self initNaviBarLeft];
}

- (void)relax
{
    if (_curController)
    {
        [_curController.view removeFromSuperview];
        [_curController removeFromParentViewController];
        _curController = nil;
    }
    
    PumpRelaxController *controller = [[PumpRelaxController alloc] init];
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
    controller.arrayType = ARRIVED_PUMP;
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

- (void)initNaviBarLeft
{
    UIView *naviBar = [self getNavigationBar];
    
    self.workState = RELAX;
    
    CGRect frame = naviBar.frame;
    
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
}

- (void)setWorkState:(WORK_STATE)state
{
    _workState = state;
    
    if (RELAX == _workState) {
        [_btnState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
        _lbState.text = @"下班";
        
        [[Config shareConfig] setOperable:NO];
        
    } else {
        [_btnState setImage:[UIImage imageNamed:@"icon_busy"] forState:UIControlStateNormal];
        _lbState.text = @"上班";
        
        [[Config shareConfig] setOperable:YES];
    }
}

- (WORK_STATE)getWorkState
{
    return _workState;
}

- (void)changeState
{
    if (RELAX == _workState)
    {
        //上班
        UpWorkRequest *request = [[UpWorkRequest alloc] init];
        request.handOverId = @"";
        
        [[HttpClient shareClient] view:self.view post:URL_UP_WORK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
            self.workState = BUSY;
            [[Config shareConfig] setOperable:1];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        
    }
    else
    {
        //下班
        UpWorkRequest *request = [[UpWorkRequest alloc] init];
        request.handOverId = @"";
        
        [[HttpClient shareClient] view:self.view post:URL_DOWN_WORK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
            self.workState = RELAX;
            [[Config shareConfig] setOperable:0];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        self.workState = RELAX;
    }
}

#pragma mark - Network Request

- (void)getCurWorkState
{
    WorkStateRequest *request = [[WorkStateRequest alloc] init];
    request.userId = [[Config shareConfig] getUserId];
    
    [[HttpClient shareClient] view:self.view post:URL_WORK_STATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        WorkStateResponse *response = [[WorkStateResponse alloc] initWithDictionary:responseObject];
        
        NSInteger operable = [[response getState] integerValue];
        
        [[Config shareConfig] setOperable:operable];
        self.workState = operable;
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getUnfinishedTask
{
    [[HttpClient shareClient] view:self.view post:URL_UNFINISHED_TASK parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SPumpListResponse *response = [[SPumpListResponse alloc] initWithDictionary:responseObject];
        NSArray<DTrackInfo *> *array = [response getPumpList];
        
        if (!array || 0 == array.count)
        {
            [self relax];
        }
        else
        {
            DTrackInfo *info = array[0];
            
            CGFloat state = info.state.floatValue;
            
            if (state < 2.5 && state > 0)
            {
                [self onWay:info];
            }
            else
            {
                [self arrived:info];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


#pragma mark - PumpRelaxControllerDelegate

- (void)onClickVehicleModify:(UILabel *)lbVehicle type:(Vehicle_type)type
{
    HzsVehicleListController *controller = [[HzsVehicleListController alloc] init];
    controller.vehicleType = type;
    controller.lbVehicle = lbVehicle;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

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

@end
