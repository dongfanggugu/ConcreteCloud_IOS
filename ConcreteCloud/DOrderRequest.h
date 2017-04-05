//
//  DOrderRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderRequest_h
#define DOrderRequest_h

#import "Request.h"

@interface DOrderRequest : Request

@property (copy, nonatomic) NSString *hzsId;

@property (copy, nonatomic) NSString *siteId;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *orderCode;

@property (copy, nonatomic) NSString *createTimeStart;

@property (copy, nonatomic) NSString *createTimeEnd;

@property (copy, nonatomic) NSString *orderUserName;

//0未完成 1完成
@property (copy, nonatomic) NSString *isComplete;

@property (assign, nonatomic) NSInteger page;

@property (assign, nonatomic) NSInteger rows;

@property (assign, nonatomic) NSString *intensityLevel;

@end

#endif /* DOrderRequest_h */
