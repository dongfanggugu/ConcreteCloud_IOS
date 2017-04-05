//
//  RenterInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RenterInfo_h
#define RenterInfo_h

#import "Jastor.h"

@interface RenterInfo : Jastor

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *contactsUser;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *renterId;

@property (copy, nonatomic) NSString *isRelease;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *tel;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@end

#endif /* RenterInfo_h */
