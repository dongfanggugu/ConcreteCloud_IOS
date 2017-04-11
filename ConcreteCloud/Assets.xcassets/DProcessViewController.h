//
//  DProcessViewController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcessViewController_h
#define DProcessViewController_h

#import "DOrderInfo.h"

@protocol DProcessViewControllerDelegate <NSObject>

- (void)onClickMap;

- (void)onClickDetail;

- (void)onClickComplete;

@end

@interface DProcessViewController : UIViewController

@property (strong, nonatomic) DOrderInfo *orderInfo;

@property (weak, nonatomic) id<DProcessViewControllerDelegate> delegate;

@property (assign, nonatomic) G_Role role;

@property (assign, nonatomic) G_Order_Trace_Status traceStatus;

@end




#endif /* DProcessViewController_h */
