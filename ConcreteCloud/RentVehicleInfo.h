//
//  RentVehicleInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleInfo_h
#define RentVehicleInfo_h

#import <Jastor.h>
#import "AddtionalVehicleInfo.h"

@interface RentVehicleInfo : Jastor

@property (copy, nonatomic) NSString *vehicleId;

//1混凝土罐车 2普通罐车 3泵车 4砂石运输车 5外加剂运输车 6散装粉料运输车
@property (copy, nonatomic) NSString *cls;

@property (copy, nonatomic) NSString *driverName;

@property (copy, nonatomic) NSString *driverTel;

//负责人姓名
@property (copy, nonatomic) NSString *contactsUser;

//负责人电话
@property (copy, nonatomic) NSString *contactsTel;

//租赁商名称
@property (copy, nonatomic) NSString *leaseName;

@property (copy, nonatomic) NSString *plateNum;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

//运载量
@property (assign, nonatomic) CGFloat weight;

//自身车重
@property (assign, nonatomic) CGFloat selfNet;

//距离
@property (assign, nonatomic) CGFloat distance;

//附加车辆信息
@property (strong, nonatomic) AddtionalVehicleInfo *additionalInfo;

@end


#endif /* RentVehicleInfo_h */
