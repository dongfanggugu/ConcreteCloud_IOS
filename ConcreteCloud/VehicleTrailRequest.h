//
//  VehicleTrailRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VehicleTrailRequest_h
#define VehicleTrailRequest_h

#import "Request.h"

@interface VehicleTrailRequest : Request

@property (assign, nonatomic) NSString *taskId;

@property (assign, nonatomic) NSString *type;

@end

#endif /* VehicleTrailRequest_h */
