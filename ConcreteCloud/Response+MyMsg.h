//
//  Response+MyMsg.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Response_MyMsg_h
#define Response_MyMsg_h

#import "ResponseDictionary.h"
#import "MyMsgInfo.h"

@interface ResponseDictionary(MyMsg)

- (MyMsgInfo *)getMyMsgInfo;

@end

#endif /* Response_MyMsg_h */
