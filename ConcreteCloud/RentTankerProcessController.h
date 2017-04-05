//
//  RentTankerProcessController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentTankerProcessController_h
#define RentTankerProcessController_h

#import "TitleViewController.h"
#import "RentVehicleInfo.h"

@protocol RentTankerProcessControllerDelegate<NSObject>

- (void)onGetVehicle:(RentVehicleInfo *)vehicleInfo;


@end

@interface RentTankerProcessController : TitleViewController

@property (weak, nonatomic) id<RentTankerProcessControllerDelegate> delegate;

@property (strong, nonatomic) UIViewController *controller;

@end


#endif /* RentTankerProcessController_h */
