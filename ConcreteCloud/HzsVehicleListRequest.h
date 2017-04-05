//
//  HzsVehicleListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsVehicleListRequest_h
#define HzsVehicleListRequest_h

#import "Request.h"

@interface HzsVehicleListRequest : Request

@property (copy, nonatomic) NSString *hzsId;

//车辆类别 1混凝土罐车 2普通罐车 3泵车 4货车
@property (copy, nonatomic) NSString *cls;

@end

#endif /* HzsVehicleListRequest_h */
