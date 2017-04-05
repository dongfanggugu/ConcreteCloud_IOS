//
//  SiteStaffAddRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SiteStaffAddRequest_h
#define SiteStaffAddRequest_h

#import "Request.h"

@interface SiteStaffAddRequest : Request

@property (copy, nonatomic) NSString *siteId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString * sex;

@property (assign, nonatomic) NSInteger age;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *isOrder;

@property (copy, nonatomic) NSString *duty;

@property (copy, nonatomic) NSString *code;

@property (copy, nonatomic) NSString *roleId;

@end


#endif /* SiteStaffAddRequest_h */
