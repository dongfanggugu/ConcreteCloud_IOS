//
//  SupDriverUnfinishedResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDriverUnfinishedResponse.h"

@implementation SupDriverUnfinishedResponse

- (HzsInfo *)getHzs
{
    return [[HzsInfo alloc] initWithDictionary:[self.body objectForKey:@"hzs"]];
}

- (PTrackInfo *)getTask
{
    return [[PTrackInfo alloc] initWithDictionary:[self.body objectForKey:@"supplierOrderProcess"]];
}

- (RentVehicleInfo *)getVehicle
{
    return [[RentVehicleInfo alloc] initWithDictionary:[self.body objectForKey:@"vehicle"]];
}

- (SupplierInfo *)getSupplier
{
    return [[SupplierInfo alloc] initWithDictionary:[self.body objectForKey:@"supplier"]];
}

@end
