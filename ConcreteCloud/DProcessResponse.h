//
//  DProcessResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcessResponse_h
#define DProcessResponse_h

#import "ResponseDictionary.h"
#import "DProcessInfo.h"


@interface DProcessResponse : ResponseDictionary

- (DProcessInfo *)getProcessInfo;

@end

#endif /* DProcessResponse_h */