//
//  RenterListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RenterListResponse_h
#define RenterListResponse_h

#import "ResponseArray.h"
#import "RenterInfo.h"

@interface RenterListResponse : ResponseArray

- (NSArray<RenterInfo *> *)getRenterList;

@end


#endif /* RenterListResponse_h */
