//
//  StaffListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef StaffListRequest_h
#define StaffListRequest_h

#import "Request.h"

@interface StaffListRequest : Request

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *leaseId;

@end

#endif /* StaffListRequest_h */
