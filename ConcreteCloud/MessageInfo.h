//
//  MessageInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/5.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MessageInfo_h
#define MessageInfo_h

#import <Jastor.h>

@interface MessageInfo : Jastor

//0未读 1已读
@property (strong, nonatomic) NSString *isRead;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *createTime;

@property (strong, nonatomic) NSString *msgId;

@property (strong, nonatomic) NSString *type;


@end


#endif /* MessageInfo_h */
