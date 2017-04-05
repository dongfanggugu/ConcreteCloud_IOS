//
//  SupDriverResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDriverResponse_h
#define SupDriverResponse_h

#import "ResponseArray.h"
#import "SupDriverInfo.h"

@interface SupDriverResponse : ResponseArray

- (NSArray<SupDriverInfo *> *)getSupDrivers;

@end


#endif /* SupDriverResponse_h */
