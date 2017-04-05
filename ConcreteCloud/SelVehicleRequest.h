//
//  SelVehicleRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SelVehicleRequest_h
#define SelVehicleRequest_h

#import "Request.h"

@interface SelVehicleRequest : Request

@property (copy, nonatomic) NSString *supplierId;

@property (copy, nonatomic) NSString *cls;

@property (copy, nonatomic) NSString *type;

@end

#endif /* SelVehicleRequest_h */
