//
//  PwdModifyRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PwdModifyRequest_h
#define PwdModifyRequest_h

#import "Request.h"

@interface PwdModifyRequest : Request

@property (copy, nonatomic) NSString  *passedPwd;

@property (copy, nonatomic) NSString *curPwd;

@end

#endif /* PwdModifyRequest_h */