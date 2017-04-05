//
//  LoginRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef LoginRequest_h
#define LoginRequest_h

#import "Request.h"


@interface LoginRequest : Request

@property (strong, nonatomic) NSString *tel;

@property (strong, nonatomic) NSString *password;

@end


#endif /* LoginRequest_h */
