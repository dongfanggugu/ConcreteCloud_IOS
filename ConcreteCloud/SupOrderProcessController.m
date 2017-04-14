//
//  SupOrderProcessController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderProcessController.h"
#import "SupOrderTraceController.h"
#import "SupOrderDetailController.h"
#import "POrderTrackController.h"
#import "CarryDetailController.h"
#import "VehicleDispatchController.h"

@interface SupOrderProcessController()<SupOrderTraceControllerDelegate>
{
    __weak UIViewController *_curController;
}

@end

@implementation SupOrderProcessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"订单跟踪" right:@"订单详情"];
    [self initView];
}


- (void)initView
{
    SupOrderTraceController *controller = [[SupOrderTraceController alloc] init];
    controller.orderInfo = _orderInfo;
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
    
    SupOrderDetailController *controller2 = [[SupOrderDetailController alloc] init];
    controller2.orderInfo = _orderInfo;
    [self addChildViewController:controller2];
    
    controller2.view.frame = frame;
}

#pragma mark - switch viewController

- (void)onClickLeftSegment
{
    [self transitionFromViewController:[self.childViewControllers objectAtIndex:1]
                      toViewController:[self.childViewControllers objectAtIndex:0]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                                  
                              } completion:^(BOOL finished) {
                                  
                              }];
}

- (void)onClickRightSegment
{
    [self transitionFromViewController:[self.childViewControllers objectAtIndex:0]
                      toViewController:[self.childViewControllers objectAtIndex:1]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                                  
                              } completion:^(BOOL finished) {
                                  
                              }];
}


#pragma mark - ProcessViewControllerDelegate
- (void)onClickMap
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    POrderTrackController *controller = [board instantiateViewControllerWithIdentifier:@"p_order_track_controller"];
    controller.supplierId = _orderInfo.supplierId;
    controller.orderId = _orderInfo.orderId;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickDetail
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    CarryDetailController *controller = [board instantiateViewControllerWithIdentifier:@"carry_detail_controller"];
    controller.supplierId = _orderInfo.supplierId;
    controller.orderId = _orderInfo.orderId;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickDispatch
{
    VehicleDispatchController *controller = [[VehicleDispatchController alloc] init];
    controller.orderInfo = _orderInfo;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
