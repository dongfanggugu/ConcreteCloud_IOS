//
//  RentWorkStateResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentWorkStateResponse_h
#define RentWorkStateResponse_h

#import "ResponseDictionary.h"
#import "RentVehicleInfo.h"


@interface RentWorkStateResponse : ResponseDictionary

- (RentVehicleInfo *)getVehicleInfo;

@end

#endif /* RentWorkStateResponse_h */
