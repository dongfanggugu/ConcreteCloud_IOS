//
//  SupDriverHistoryResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDriverHistoryResponse_h
#define SupDriverHistoryResponse_h

#import "ResponseArray.h"
#import "PTrackInfo.h"

@interface SupDriverHistoryResponse : ResponseArray

- (NSArray<PTrackInfo *> *)getTask;

@end


#endif /* SupDriverHistoryResponse_h */
