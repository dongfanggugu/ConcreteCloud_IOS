//
//  SupDriverUnfinishedResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDriverUnfinishedResponse_h
#define SupDriverUnfinishedResponse_h

#import "ResponseDictionary.h"
#import "HzsInfo.h"
#import "PTrackInfo.h"
#import "RentVehicleInfo.h"
#import "SupplierInfo.h"

@interface SupDriverUnfinishedResponse : ResponseDictionary

- (HzsInfo *)getHzs;

- (PTrackInfo *)getTask;

- (RentVehicleInfo *)getVehicle;

- (SupplierInfo *)getSupplier;

@end


#endif /* SupDriverUnfinishedResponse_h */
