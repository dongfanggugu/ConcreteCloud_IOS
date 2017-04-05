//
//  TaskFinishRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaskFinishRequest_h
#define TaskFinishRequest_h

#import "Request.h"

@interface TaskFinishRequest : Request

@property (assign, nonatomic) NSString *hzsOrderProcessId;

//0完成 1退货
@property (assign, nonatomic) NSString *back;

@end


#endif /* TaskFinishRequest_h */
