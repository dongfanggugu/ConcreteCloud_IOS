//
//  DTrackInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DTrackInfo_h
#define DTrackInfo_h

#import <Jastor.h>
#import "DOrderInfo.h"

@interface DTrackInfo : Jastor

@property (copy, nonatomic) NSString *trackId;

//车次
@property (copy, nonatomic) NSString *currentNum;

//车辆id
@property (copy, nonatomic) NSString *vehicleId;

//司机id
@property (copy, nonatomic) NSString *driverId;

//司机
@property (copy, nonatomic) NSString *driverName;

//司机电话
@property (copy, nonatomic) NSString *driverTel;

//完成时间
@property (copy, nonatomic) NSString *endTime;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

//运载量
@property (assign, nonatomic) NSInteger number;

@property (copy, nonatomic) NSString *plateNum;

//到达工地时间
@property (copy, nonatomic) NSString *arriveSiteTime;

//回到搅拌站时间
@property (copy, nonatomic) NSString *backHzsTime;

//启运时间
@property (copy, nonatomic) NSString *startTime;

//状态  1:启运  2:出厂  3:工地检验   4:完成 -1:退货
@property (copy, nonatomic) NSString *state;

@property (copy, nonatomic) NSString *taskCode;

//1.混凝土罐车 2:普通罐车 3:泵车 4:货车
@property (copy, nonatomic) NSString *cls;

//泵车类型
@property (copy, nonatomic) NSString *vehicleType;

@property (copy, nonatomic) NSString *examName;

//工地视频
@property (copy, nonatomic) NSString *spotVideo;

//出厂视频
@property (copy, nonatomic) NSString *examVideo;

//剩余到达时间
@property (assign, nonatomic) NSInteger arriveTime;

@property (strong, nonatomic) DOrderInfo *hzs_Order;

@end


#endif /* DTrackInfo_h */
