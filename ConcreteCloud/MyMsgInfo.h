//
//  MyMsgInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MyMsgInfo_h
#define MyMsgInfo_h

#import <Jastor.h>
#import "MsgTypeInfo.h"

@interface MyMsgInfo : Jastor

@property (strong, nonatomic) NSArray<MsgTypeInfo *> *roleMsgTypes;

@property (copy, nonatomic) NSString *userMsgTypes;

@end

#endif /* MyMsgInfo_h */
