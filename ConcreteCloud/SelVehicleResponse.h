//
//  SelVehicleResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SelVehicleResponse_h
#define SelVehicleResponse_h

#import "ResponseArray.h"
#import "SelVehicleInfo.h"

@interface SelVehicleResponse : ResponseArray

- (NSArray<SelVehicleInfo *> *)getSelVehicles;

@end

#endif /* SelVehicleResponse_h */
