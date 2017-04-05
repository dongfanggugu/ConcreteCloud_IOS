//
//  HzsVehicleListController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsVehicleListController_h
#define HzsVehicleListController_h

#import "TitleViewController.h"

typedef NS_ENUM(NSInteger, Vehicle_type)
{
    TANKER = 1,
    PUMP = 3
};

@interface HzsVehicleListController : TitleViewController

@property (unsafe_unretained, nonatomic) Vehicle_type vehicleType;

@property (weak, nonatomic) UILabel *lbVehicle;

@property (weak, nonatomic) UILabel *lbWeight;

@end


#endif /* HzsVehicleListController_h */
