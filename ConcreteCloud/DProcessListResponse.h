//
//  DProcessListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcessListResponse_h
#define DProcessListResponse_h

#import "ResponseDictionary.h"
#import "DProcessList.h"

@interface DProcessListResponse : ResponseDictionary

- (DProcessList *)getProcessList;

@end


#endif /* DProcessListResponse_h */
