//
//  DOrderInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderInfo_h
#define DOrderInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface DOrderInfo : Jastor

@property (copy, nonatomic) NSString *orderId;

//浇筑部位
@property (copy, nonatomic) NSString *castingPart;

//强度等级
@property (copy, nonatomic) NSString *intensityLevel;

//抗渗等级
@property (copy, nonatomic) NSString *ksdj;

//完成时间
@property (copy, nonatomic) NSString *completeTime;

//订单完成确认人
@property (copy, nonatomic) NSString *completeUserName;

//商品名称
@property (copy, nonatomic) NSString *goodsName;

//搅拌站id
@property (copy, nonatomic) NSString *hzsId;

//搅拌站名称
@property (copy, nonatomic) NSString *hzsName;

//是否完成
@property (copy, nonatomic) NSString *isComplete;

//订单号
@property (copy, nonatomic) NSString *orderCode;

//下单人id
@property (copy, nonatomic) NSString *orderUserId;

//下单人姓名
@property (copy, nonatomic) NSString *orderUserName;

//项目名称
@property (copy, nonatomic) NSString *projectName;

//订单确认状态 1通过 2不通过
@property (copy, nonatomic) NSString *reviewState;

//订单确认时间
@property (copy, nonatomic) NSString *reviewTime;

//订单确认人id
@property (copy, nonatomic) NSString *reviewUserId;

//订单确认人姓名
@property (copy, nonatomic) NSString *reviewUserName;

//订单确认人电话
@property (copy, nonatomic) NSString *reviewTel;

//工地id
@property (copy, nonatomic) NSString *siteId;

//工地名称
@property (copy, nonatomic) NSString *siteName;

//订单状态
@property (copy, nonatomic) NSString *state;

//状态名称
@property (copy, nonatomic) NSString *stateName;

//技术要求
@property (copy, nonatomic) NSString *techReq;

//泵送要求
@property (copy, nonatomic) NSString *pumpUpReq;

//浇筑时间
@property (copy, nonatomic) NSString *useTime;

//塌落度
@property (copy, nonatomic) NSString *slump;

//塌落度偏差
@property (copy, nonatomic) NSString *dev;

//数量
@property (assign, nonatomic) CGFloat number;

//创建时间
@property (copy, nonatomic) NSString *createTime;

//工地地址
@property (copy, nonatomic) NSString *siteAddress;

//下单员电话
@property (copy, nonatomic) NSString *orderUserTel;

//搅拌站地址
@property (copy, nonatomic) NSString *hzsAddrress;

//工地纬度
@property (assign, nonatomic) CGFloat siteLat;

//工地经度
@property (assign, nonatomic) CGFloat siteLng;

//搅拌站纬度
@property (assign, nonatomic) CGFloat hzsLat;

//搅拌站经度
@property (assign, nonatomic) CGFloat hzsLng;

//是否发送完成 1完成 0未完成
@property (copy, nonatomic) NSString *sendComplete;

//发送完成时间
@property (copy, nonatomic) NSString *sendCompleteTime;

//公司名称
@property (copy, nonatomic) NSString *companyName;


- (NSString *)getKey;

- (NSString *)getShowContent;

@end

#endif /* DOrderInfo_h */
