//
//  Response+VehicleTrail.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Response_VehicleTrail_h
#define Response_VehicleTrail_h

#import "ResponseArray.h"
#import "VehicleTrailInfo.h"

@interface ResponseArray(VehicleTrail)

- (NSArray<VehicleTrailInfo *> *)getVehicleTrailArray;

@end

#endif /* Response_VehicleTrail_h */
