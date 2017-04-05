//
//  POrderListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/29.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef POrderListRequest_h
#define POrderListRequest_h

#import "Request.h"

@interface POrderListRequest : Request

//1自己订单 2其他人订单
@property (strong, nonatomic) NSString *is;

//搅拌站id
@property (strong, nonatomic) NSString *hzsId;

//供应商id
@property (strong, nonatomic) NSString *supplierId;

//角色类型
@property (strong, nonatomic) NSString *type;

//1进行中 2已完成
@property (strong, nonatomic) NSString *ing;

//货物类型
@property (strong, nonatomic) NSString *goodsName;

//下单人
@property (strong, nonatomic) NSString *userName;

//起始时间
@property (strong, nonatomic) NSString *createTimeStart;

//结束时间
@property (strong, nonatomic) NSString *createTimeEnd;

//订单号
@property (strong, nonatomic) NSString *orderCode;

//-1代表全部
@property NSInteger page;

//每页条目数
@property NSInteger rows;


@end


#endif /* POrderListRequest_h */
