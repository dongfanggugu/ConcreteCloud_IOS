//
//  Response+POrderInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Response_POrderInfo_h
#define Response_POrderInfo_h

#import "ResponseDictionary.h"
#import "POrderInfo.h"

@interface ResponseDictionary(POrderInfo)

- (POrderInfo *)pOrderInfo:(NSDictionary *)body;

@end

#endif /* Response_POrderInfo_h */
