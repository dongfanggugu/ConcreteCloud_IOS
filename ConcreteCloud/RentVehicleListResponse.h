//
//  RentVehicleListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleListResponse_h
#define RentVehicleListResponse_h

#import "ResponseArray.h"
#import "RentVehicleInfo.h"

@interface RentVehicleListResponse : ResponseArray

- (NSArray<RentVehicleInfo *> *)getRentVehicleList;

@end

#endif /* RentVehicleListResponse_h */
