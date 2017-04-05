//
//  SelVehicleInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SelVehicleInfo_h
#define SelVehicleInfo_h

#import <Jastor.h>

@interface SelVehicleInfo : Jastor

@property (copy, nonatomic) NSString *vehicleId;

@property (copy, nonatomic) NSString *plateNum;

@property (copy, nonatomic) NSString *driverId;

@property (copy, nonatomic) NSString *driverName;

@property (copy, nonatomic) NSString *driverTel;

@property (assign, nonatomic) CGFloat weight;

@end


#endif /* SelVehicleInfo_h */
