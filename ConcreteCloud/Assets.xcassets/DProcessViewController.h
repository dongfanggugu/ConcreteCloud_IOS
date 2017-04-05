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

//1调度员 2工地下单员
@property (assign, nonatomic) NSInteger type;

@end




#endif /* DProcessViewController_h */
