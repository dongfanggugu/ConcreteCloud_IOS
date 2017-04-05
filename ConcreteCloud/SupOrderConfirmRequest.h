//
//  SupOrderConfirmRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupOrderConfirmRequest_h
#define SupOrderConfirmRequest_h

#import "Request.h"

@interface SupOrderConfirmRequest : Request

@property (copy, nonatomic) NSString *orderId;

@property (copy, nonatomic) NSString *userName;

//1确认 2拒绝
@property (copy, nonatomic) NSString *is;

@end


#endif /* SupOrderConfirmRequest_h */
