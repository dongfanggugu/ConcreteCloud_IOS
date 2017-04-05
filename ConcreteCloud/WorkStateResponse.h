//
//  WorkStateResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef WorkStateResponse_h
#define WorkStateResponse_h

#import "ResponseDictionary.h"

@interface WorkStateResponse : ResponseDictionary

- (NSString *)getState;

@end

#endif /* WorkStateResponse_h */
