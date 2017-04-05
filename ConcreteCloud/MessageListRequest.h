//
//  MessageListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/5.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MessageListRequest_h
#define MessageListRequest_h

#import "Request.h"

@interface MessageListRequest : Request

@property NSInteger page;

@property NSInteger rows;

//0已读 1未读 -1全部
@property (strong, nonatomic) NSString *isRead;

@end


#endif /* MessageListRequest_h */
