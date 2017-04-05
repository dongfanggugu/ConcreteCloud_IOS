//
//  PTrackInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PTrackInfo_h
#define PTrackInfo_h

#import <Jastor.h>

@interface PTrackInfo : Jastor

@property (copy, nonatomic) NSString *driverName;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *taskCode;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@property (copy, nonatomic) NSString *plateNum;

@property (copy, nonatomic) NSString *processId;

@property (copy, nonatomic) NSString *cls;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *startTime;

@property (strong, nonatomic) NSNumber *arrvieTime;

@property (strong, nonatomic) NSNumber *distance;

@property (assign, nonatomic) CGFloat loadWeight;

@property (copy, nonatomic) NSString *confirmVideo;

//强度等级
@property (copy, nonatomic) NSString *intensityLevel;

//颗粒度、细度模数
@property (copy, nonatomic) NSString *kld;

//等级标准
@property (strong, nonatomic) NSString *standard;

//品种
@property (copy, nonatomic) NSString *variety;

//毛重
@property (assign, nonatomic) CGFloat weight;

//皮重
@property (assign, nonatomic) CGFloat net;

//净重
@property (assign, nonatomic) CGFloat number;

//采购员
@property (copy, nonatomic) NSString *orderUser;

//采购员电话
@property (copy, nonatomic) NSString *orderTel;

//采购员,历史列表中使用
@property (copy, nonatomic) NSString *userTel;

//采购员电话,历史列表中使用
@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *hzsName;

@property (copy, nonatomic) NSString *hzsAddress;

//下单时间
@property (copy, nonatomic) NSString *createTime;

//状态 1指派 2启运 5退货 其他:合格
@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *supplierName;

@end


#endif /* PTrackInfo_h */
