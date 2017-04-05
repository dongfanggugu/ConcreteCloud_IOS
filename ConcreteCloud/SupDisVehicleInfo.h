//
//  SupDisVehicleInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDisVehicleInfo_h
#define SupDisVehicleInfo_h

#import <Jastor.h>

@interface SupDisVehicleInfo : Jastor

//确认时间
@property (copy, nonatomic) NSString *confirmTime;

//确认人
@property (copy, nonatomic) NSString *confirmUser;

//创建时间
@property (copy, nonatomic) NSString *createTime;

//司机id
@property (copy, nonatomic) NSString *driverId;

@property (copy, nonatomic) NSString *driverName;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *grossWeightTime;

@property (copy, nonatomic) NSString *vehicleId;

@property (copy, nonatomic) NSString *plateNum;

@property (assign, nonatomic) CGFloat net;

@property (assign, nonatomic) CGFloat number;

@property (copy, nonatomic) NSString *startTime;

@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *supplierOrderId;

@property (copy, nonatomic) NSString *taskCode;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *userId;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *vehicleWeightTime;

@property (assign, nonatomic) CGFloat weight;

@property (assign, nonatomic) CGFloat loadWeight;

@end


#endif /* SupDisVehicleInfo_h */
