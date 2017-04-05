//
//  RentVehicleController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleController_h
#define RentVehicleController_h

#import "TitleViewController.h"
#import "RentVehicleInfo.h"


typedef NS_ENUM(NSInteger, Rent_Vehicle_Type)
{
    TANKER = 1,
    PUMP = 3
};

@protocol RentVehicleControllerDelegate<NSObject>

- (void)onSelectVehicle:(RentVehicleInfo *)vehicleInfo;

@end

@interface RentVehicleController : TitleViewController

@property (assign, nonatomic) Rent_Vehicle_Type vehicleType;

@property (weak, nonatomic) id<RentVehicleControllerDelegate> delegate;

@end


#endif /* RentVehicleController_h */
