//
//  PersonInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PersonInfo_h
#define PersonInfo_h

#import <Jastor.h>

@interface PersonInfo : Jastor

@property NSInteger age;

@property (copy, nonatomic) NSString *branchId;

@property (copy, nonatomic) NSString *branchName;

@property (copy, nonatomic) NSString *code;

@property (copy, nonatomic) NSString *duty;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *roleId;

@property (copy, nonatomic) NSString *sex;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *userId;

@property (copy, nonatomic) NSString *isBing;

@property (copy, nonatomic) NSString *companyAddress;

@property (copy, nonatomic) NSString *operable;

@property (copy, nonatomic) NSString *logo;

@property (assign, nonatomic) double lat;

@property (assign, nonatomic) double lng;

@property (copy, nonatomic) NSString *helpUrl;


@end

#endif /* PersonInfo_h */
