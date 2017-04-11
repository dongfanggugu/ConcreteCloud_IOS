//
//  ProcessViewController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProcessViewController_h
#define ProcessViewController_h

#import "POrderInfo.h"

@protocol ProcessViewControllerDelegate <NSObject>

- (void)onClickMap;

- (void)onClickDetail;

- (void)onClickComplete:(NSString *)orderId;

@end

@interface ProcessViewController : UIViewController

@property (strong, nonatomic) POrderInfo *orderInfo;

@property (weak, nonatomic) id<ProcessViewControllerDelegate> delegate;

@property (assign, nonatomic) G_Order_Trace_Status traceStatus;

@end


#endif /* ProcessViewController_h */
