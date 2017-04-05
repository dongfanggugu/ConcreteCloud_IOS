//
//  SupStartUpRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupStartUpRequest_h
#define SupStartUpRequest_h

#import "Request.h"

@interface SupStartUpRequest : Request

@property (copy, nonatomic) NSString *taskId;

@property (copy, nonatomic) NSString *processId;

@end

#endif /* SupStartUpRequest_h */
