//
//  SiteStaffInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SiteStaffInfo_h
#define SiteStaffInfo_h

#import <Jastor.h>

@interface SiteStaffInfo : Jastor

@property (assign, nonatomic) NSInteger age;

@property (copy, nonatomic) NSString *code;

//职务
@property (copy, nonatomic) NSString *duty;

@property (copy, nonatomic) NSString *staffId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *roleNames;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *sex;

@property (copy, nonatomic) NSString *isOrder;

@end


#endif /* SiteStaffInfo_h */
