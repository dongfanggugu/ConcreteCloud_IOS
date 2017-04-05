//
//  RentVehicleDelRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleDelRequest_h
#define RentVehicleDelRequest_h

#import "Request.h"

@interface RentVehicleDelRequest : Request

@property (copy, nonatomic) NSString *vehicleId;

@end


#endif /* RentVehicleDelRequest_h */
