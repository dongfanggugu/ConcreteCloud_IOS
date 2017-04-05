//
//  SupDisVehicleResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDisVehicleResponse_h
#define SupDisVehicleResponse_h

#import "ResponseArray.h"
#import "SupDisVehicleInfo.h"

@interface SupDisVehicleResponse : ResponseArray

- (NSArray<SupDisVehicleInfo *> *)getVehicles;

@end


#endif /* SupDisVehicleResponse_h */
