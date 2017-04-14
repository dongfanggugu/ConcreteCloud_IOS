//
//  SupOrderTraceController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupOrderTraceController_h
#define SupOrderTraceController_h

#import "POrderInfo.h"
#import "BaseViewController.h"

@protocol SupOrderTraceControllerDelegate <NSObject>

- (void)onClickMap;

- (void)onClickDetail;

- (void)onClickDispatch;

@end

@interface SupOrderTraceController : BaseViewController

@property (strong, nonatomic) POrderInfo *orderInfo;

@property (weak, nonatomic) id<SupOrderTraceControllerDelegate> delegate;

@property (assign, nonatomic) G_Order_Trace_Status traceStatus;

@end

#endif /* SupOrderTraceController_h */
