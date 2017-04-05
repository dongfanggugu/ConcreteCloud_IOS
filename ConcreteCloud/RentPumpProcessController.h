//
//  RentPumpProcessController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentPumpProcessController_h
#define RentPumpProcessController_h

#import "TitleViewController.h"
#import "RentVehicleInfo.h"

@protocol RentPumpProcessControllerDelegate<NSObject>

- (void)onGetVehicle:(RentVehicleInfo *)vehicleInfo;


@end

@interface RentPumpProcessController : TitleViewController

@property (weak, nonatomic) id<RentPumpProcessControllerDelegate> delegate;

@end


#endif /* RentPumpProcessController_h */
