//
//  SupDriverHistoryRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDriverHistoryRequest_h
#define SupDriverHistoryRequest_h


#import "Request.h"

@interface SupDriverHistoryRequest : Request

@property (copy, nonatomic) NSString *driverId;

@end


#endif /* SupDriverHistoryRequest_h */
