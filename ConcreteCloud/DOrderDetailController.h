//
//  DOrderDetailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderDetailController_h
#define DOrderDetailController_h

#import "TitleViewController.h"
#import "DOrderInfo.h"

@interface DOrderDetailController : TitleViewController

@property (strong, nonatomic) DOrderInfo *orderInfo;


//1调度员 2工地下单员
@property (assign, nonatomic) NSInteger type;

@end


#endif /* DOrderDetailController_h */
