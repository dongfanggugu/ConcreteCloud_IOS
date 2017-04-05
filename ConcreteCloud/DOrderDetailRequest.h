//
//  DOrderDetailRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderDetailRequest_h
#define DOrderDetailRequest_h

#import "Request.h"

@interface DOrderDetailRequest : Request

@property (copy, nonatomic) NSString *hzsOrderId;

@end


#endif /* DOrderDetailRequest_h */
