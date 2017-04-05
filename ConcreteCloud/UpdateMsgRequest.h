//
//  UpdateMsgRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef UpdateMsgRequest_h
#define UpdateMsgRequest_h

#import "Request.h"

@interface UpdateMsgRequest : Request

@property (copy, nonatomic) NSString *msgTypes;

@end


#endif /* UpdateMsgRequest_h */
