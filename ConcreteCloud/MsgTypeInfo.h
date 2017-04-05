//
//  MsgTypeInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MsgTypeInfo_h
#define MsgTypeInfo_h

#import <Jastor.h>

@interface MsgTypeInfo : Jastor

@property (copy, nonatomic) NSString *des;

@property (copy, nonatomic) NSString *msgId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *value;

@end

#endif /* MsgTypeInfo_h */
