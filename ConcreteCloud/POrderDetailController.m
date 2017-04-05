//
//  POrderDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POrderDetailController.h"
#import "ProcessViewController.h"
#import "PDetailController.h"
#import "POrderTrackController.h"
#import "CarryDetailController.h"

@interface POrderDetailController()<ProcessViewControllerDelegate>
{
    UIViewController *_curController;
}

@end

@implementation POrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"订单跟踪" right:@"订单详情"];
    [self initView];
}


- (void)initView
{
    ProcessViewController *controller = [[ProcessViewController alloc] init];
    controller.orderInfo = _orderInfo;
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
    
    PDetailController *controller2 = [[PDetailController alloc] init];
    controller2.orderInfo = _orderInfo;
    [self addChildViewController:controller2];
    
    controller2.view.frame = frame;
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
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    POrderTrackController *controller = [board instantiateViewControllerWithIdentifier:@"p_order_track_controller"];
    controller.supplierId = _orderInfo.supplierId;
    controller.orderId = _orderInfo.orderId;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickDetail
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
    CarryDetailController *controller = [board instantiateViewControllerWithIdentifier:@"carry_detail_controller"];
    controller.supplierId = _orderInfo.supplierId;
    controller.orderId = _orderInfo.orderId;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickComplete:(NSString *)orderId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = orderId;
    
    param[@"userName"] = [[Config shareConfig] getName];
    
    [[HttpClient shareClient] view:self.view post:URL_B_COMPLETE parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"订单完成,您可以到历史订单中查看此订单" view:self.view];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
