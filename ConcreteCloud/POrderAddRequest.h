//
//  POrderAddRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef POrderAddRequest_h
#define POrderAddRequest_h

#import "Request.h"

@interface POrderAddRequest : Request

//用户名
@property (strong, nonatomic) NSString *userName;

//商品名称
@property (strong, nonatomic) NSString *goodsName;

//订货量
@property CGFloat number;

//等级标准
@property (strong, nonatomic) NSString *standard;

//品种
@property (strong, nonatomic) NSString *variety;

//强度等级
@property (strong, nonatomic) NSString *intensityLevel;

//细度模数/径粒规格 mm
@property (strong, nonatomic) NSString *kld;

//含量
@property (strong, nonatomic) NSString *contents;

//搅拌站id
@property (strong, nonatomic) NSString *hzsId;

//供应商id
@property (strong, nonatomic) NSString *supplierId;

//运达时间
@property (strong, nonatomic) NSString *arriveTime;

//特殊要求
@property (strong, nonatomic) NSString *techReq;

@end

#endif /* POrderAddRequest_h */
