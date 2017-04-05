//
//  AuthorizeRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef AuthorizeRequest_h
#define AuthorizeRequest_h

#import "Request.h"

@interface AuthorizeRequest : Request

@property (copy, nonatomic) NSString *hzsId;

@property (copy, nonatomic) NSString *siteId;

@property (copy, nonatomic) NSString *userName;

@end


#endif /* AuthorizeRequest_h */
