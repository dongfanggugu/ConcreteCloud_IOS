//
//  Response+PProcess.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Response_PProcess_h
#define Response_PProcess_h

#import "ResponseDictionary.h"
#import "PProcessData.h"

@interface ResponseDictionary(PProcess)

- (PProcessData *)getPProcessData:(NSDictionary *)body;

@end

#endif /* Response_PProcess_h */
