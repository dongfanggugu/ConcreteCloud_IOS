//
//  DOrderDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOrderDetailController.h"
#import "DDetailController.h"
#import "DProcessViewController.h"
#import "DOrderTrackController.h"
#import "DOrderDetailRequest.h"
#import "SDetailController.h"
#import "ACarryDetailController.h"

@interface DOrderDetailController()<DProcessViewControllerDelegate>
{
    UIViewController *_curController;
}

@end

@implementation DOrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"订单跟踪" right:@"订单详情"];
    [self initView];
}


- (void)initView
{
    DProcessViewController *controller = [[DProcessViewController alloc] init];
    controller.orderInfo = _orderInfo;
    controller.role = _role;
    controller.traceStatus = _traceStatus;
    
    [self addChildViewController:controller];
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 94;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - 94;
    
    controller.view.frame = frame;
    controller.delegate = self;
    
    [self.view addSubview:controller.view];
    _curController = controller;
    
    if (Role_Site_Staff == _role)
    {
        SDetailController *controller2 = [[SDetailController alloc] init];
        controller2.orderInfo = _orderInfo;
        [self addChildViewController:controller2];
        controller2.view.frame = frame;
    }
    else
    {
        DDetailController *controller2 = [[DDetailController alloc] init];
        controller2.orderInfo = _orderInfo;
        [self addChildViewController:controller2];
        controller2.view.frame = frame;
    }
    
    
}

#pragma mark - switch viewController

- (void)onClickLeftSegment
{
    NSLog(@"amount:%ld", self.childViewControllers.count);
    [self transitionFromViewController:[self.childViewControllers objectAtIndex:1]
                      toViewController:[self.childViewControllers objectAtIndex:0]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                                  
                              } completion:^(BOOL finished) {
                                  
                              }];
}

- (void)onClickRightSegment
{
    NSLog(@"amount:%ld", self.childViewControllers.count);
    [self transitionFromViewController:[self.childViewControllers objectAtIndex:0]
                      toViewController:[self.childViewControllers objectAtIndex:1]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                                  
                              } completion:^(BOOL finished) {
                                  
                              }];
}


#pragma mark - ProcessViewControllerDelegate
- (void)onClickMap
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
    DOrderTrackController *controller = [board instantiateViewControllerWithIdentifier:@"d_order_track_controller"];
    controller.orderId = _orderInfo.orderId;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickDetail
{
    ACarryDetailController *controller = [[ACarryDetailController alloc] init];
    controller.orderId = _orderInfo.orderId;
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickComplete
{
    DOrderDetailRequest *request = [[DOrderDetailRequest alloc] init];
    request.hzsOrderId = _orderInfo.orderId;
    
    [[HttpClient shareClient] view:self.view post:URL_D_FINISH parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"订单完成" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
