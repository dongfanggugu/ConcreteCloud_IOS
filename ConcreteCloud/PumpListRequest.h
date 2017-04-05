//
//  PumpListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PumpListRequest_h
#define PumpListRequest_h

#import "Request.h"

@interface PumpListRequest : Request

@property (copy, nonatomic) NSString *branchId;

@end

#endif /* PumpListRequest_h */
