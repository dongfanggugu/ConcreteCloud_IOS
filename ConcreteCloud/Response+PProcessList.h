//
//  Response+PProcessList.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Response_PProcessList_h
#define Response_PProcessList_h

#import "ResponseDictionary.h"
#import "PProcessList.h"

@interface ResponseDictionary(PProcessList)

- (PProcessList *)getProcessList:(NSDictionary *)body;

@end


#endif /* Response_PProcessList_h */
