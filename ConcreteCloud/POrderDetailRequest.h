//
//  POrderDetailRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef POrderDetailRequest_h
#define POrderDetailRequest_h

#import "Request.h"

@interface POrderDetailRequest : Request

@property (assign, nonatomic) NSString *orderId;

@end

#endif /* POrderDetailRequest_h */
