//
//  RentTankerDetailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentTankerDetailController_h
#define RentTankerDetailController_h

#import "TitleViewController.h"
#import "DTrackInfo.h"

typedef NS_ENUM(NSInteger, Vehicle_Type)
{
    TANKER = 1,
    PUMP = 3
};

@interface RentTankerDetailController : TitleViewController

@property (strong, nonatomic) DTrackInfo *trackInfo;

@property (assign, nonatomic) Vehicle_Type vehicleType;

@end

#endif /* RentTankerDetailController_h */
