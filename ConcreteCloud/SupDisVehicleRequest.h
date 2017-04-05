//
//  SupDisVehicleRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDisVehicleRequest_h
#define SupDisVehicleRequest_h

#import "Request.h"

@interface SupDisVehicleRequest : Request

@property (copy, nonatomic) NSString *supplierOrderId;

@end

#endif /* SupDisVehicleRequest_h */
