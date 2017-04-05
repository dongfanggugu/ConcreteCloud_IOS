//
//  DProcessInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcessInfo_h
#define DProcessInfo_h

#import <Jastor.h>

@interface DProcessInfo : Jastor

@property (copy, nonatomic) NSString *castingPart;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *hzsName;

@property (copy, nonatomic) NSString *processId;

@property (copy, nonatomic) NSString *orderCode;

@property (copy, nonatomic) NSString *siteName;

//完成量
@property (assign, nonatomic) CGFloat finishedNum;

//订单总量
@property (assign, nonatomic) CGFloat number;

//运送中数量
@property (assign, nonatomic) CGFloat transportingNum;


@end

#endif /* DProcessInfo_h */
