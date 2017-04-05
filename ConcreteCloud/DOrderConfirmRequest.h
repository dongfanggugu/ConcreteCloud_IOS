//
//  DOrderConfirmRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderConfirmRequest_h
#define DOrderConfirmRequest_h

#import "Request.h"

@interface DOrderConfirmRequest : Request

@property (copy, nonatomic) NSString *hzsOrderId;

@property (copy, nonatomic) NSString *userName;

//1通过 2未通过
@property (copy, nonatomic) NSString *reviewState;

@property (copy, nonatomic) NSString *reviewRemark;

@end


#endif /* DOrderConfirmRequest_h */
