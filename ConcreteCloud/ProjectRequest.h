//
//  ProjectRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProjectRequest_h
#define ProjectRequest_h

#import "Request.h"

@interface ProjectRequest : Request

@property (copy, nonatomic) NSString *hzsId;

//1已授权 0未授权 空全部
@property (copy, nonatomic) NSString *auth;

@end


#endif /* ProjectRequest_h */
