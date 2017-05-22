//
//  DicRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/13.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DicRequest_h
#define DicRequest_h

#import "Request.h"

@interface DicRequest : Request

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *hzsId;

@property (copy, nonatomic) NSString *siteName;

@end


#endif /* DicRequest_h */
