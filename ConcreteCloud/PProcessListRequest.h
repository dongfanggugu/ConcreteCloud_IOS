//
//  PProcessListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PProcessListRequest_h
#define PProcessListRequest_h

#import "Request.h"

@interface PProcessListRequest : Request

@property (copy, nonatomic) NSString *supplierOrderId;

@property (copy, nonatomic) NSString *supplierId;

//1 未完成 2 全部
@property (copy, nonatomic) NSString *finish;

@end



#endif /* PProcessListRequest_h */
