//
//  RentVehicleRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleRequest_h
#define RentVehicleRequest_h

#import "Request.h"

@interface RentVehicleRequest : Request

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *leaseId;

@property (copy, nonatomic) NSString *cls;

@end


#endif /* RentVehicleRequest_h */
