//
//  HzsListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsListResponse_h
#define HzsListResponse_h

#import "ResponseArray.h"
#import "HzsInfo.h"

@interface HzsListResponse : ResponseArray

- (NSArray<HzsInfo *> *)getHzsList;

@end

#endif /* HzsListResponse_h */
