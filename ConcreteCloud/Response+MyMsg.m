//
//  Response+MyMsg.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response+MyMsg.h"

@implementation ResponseDictionary(MyMsg)

- (MyMsgInfo *)getMyMsgInfo
{
    MyMsgInfo *myMsg = [[MyMsgInfo alloc] initWithDictionary:self.body];
    
    return myMsg;
}

@end
