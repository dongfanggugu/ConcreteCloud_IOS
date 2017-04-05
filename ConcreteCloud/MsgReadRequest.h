//
//  MsgReadRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MsgReadRequest_h
#define MsgReadRequest_h

#import "Request.h"

@interface MsgReadRequest : Request

@property (assign, nonatomic) NSString *msgId;

@end

#endif /* MsgReadRequest_h */
