//
//  AdminProcessController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef AdminProcessController_h
#define AdminProcessController_h


#import "TitleViewController.h"
#import "RentTankerProcessController.h"
#import "RentPumpRelaxController.h"


@interface AdminProcessController : TitleViewController

@property (weak, nonatomic) id<RentTankerProcessControllerDelegate> delegate;

@property (weak, nonatomic) id<RentPumpProcessControllerDelegate> pumpDelegate;

@end


#endif /* AdminProcessController_h */
