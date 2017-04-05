//
//  POrderInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef POrderInfo_h
#define POrderInfo_h

#import <Jastor.h>

@interface POrderInfo : Jastor

//搅拌站地址
@property (strong, nonatomic) NSString *address;

//确认时间
@property (strong, nonatomic) NSString *confirmTime;

//确认人id
@property (strong, nonatomic) NSString *confirmUserId;

//确认人姓名
@property (strong, nonatomic) NSString *confirmUserName;

//确认人电话
@property (strong, nonatomic) NSString *confirmTel;

//创建时间
@property (strong, nonatomic) NSString *createTime;

//运达时间
@property (strong, nonatomic) NSString *arriveTime;

//商品名称
@property (strong, nonatomic) NSString *goodsName;

//搅拌站id
@property (strong, nonatomic) NSString *hzsId;

//搅拌站名称
@property (strong, nonatomic) NSString *hzsName;

//订单id
@property (strong, nonatomic) NSString *orderId;

//订单确认状态 0待确认 1确认 2拒绝
@property (strong, nonatomic) NSString *isAffirm;

//订单状态 0待确认 1已经审核 2运送中 3已完成 4不合格
@property (strong, nonatomic) NSString *isComplete;

//是否已经撤销
@property (strong, nonatomic) NSString *isDelete;

//订货量
@property (strong, nonatomic) NSString *number;

//等级标准 粉煤灰和矿粉使用
@property (strong, nonatomic) NSString *standard;

//品种 石子 砂子 水泥 外加剂
@property (strong, nonatomic) NSString *variety;

//强度等级 水泥
@property (strong, nonatomic) NSString *intensityLevel;

//细度模数/径粒规格 mm 石子 砂子
@property (strong, nonatomic) NSString *kld;

//含量
@property (strong, nonatomic) NSString *contents;

//供应商id
@property (strong, nonatomic) NSString *supplierId;

//供应商名字
@property (strong, nonatomic) NSString *supplierName;

//供应商地址
@property (strong, nonatomic) NSString *supplierAddress;

//下单员id
@property (strong, nonatomic) NSString *userId;

//下单员电话
@property (strong, nonatomic) NSString *tel;

//下单员姓名
@property (strong, nonatomic) NSString *userName;

//完成时间
@property (strong, nonatomic) NSString *completeTime;

//供应商负责人
@property (strong, nonatomic) NSString *administratorName;

//负责人电话
@property (strong, nonatomic) NSString *administratorTel;

//特殊要求
@property (strong, nonatomic) NSString *techReq;


@end



#endif /* POrderInfo_h */
