//
//  SupDisRequestInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDisRequestInfo_h
#define SupDisRequestInfo_h

#import <Jastor.h>

@interface SupDisRequestInfo : Jastor

@property (copy, nonatomic) NSString *driverId;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *supplierOrderId;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *plateNum;

@end

#endif /* SupDisRequestInfo_h */
