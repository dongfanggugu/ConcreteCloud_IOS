//
//  UnAuthorizeRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef UnAuthorizeRequest_h
#define UnAuthorizeRequest_h

#import "Request.h"

@interface UnAuthorizeRequest : Request

@property (assign, nonatomic) NSString *authId;

@end


#endif /* UnAuthorizeRequest_h */
