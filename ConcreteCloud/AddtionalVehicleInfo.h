//
//  AddtionalVehicleInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef AddtionalVehicleInfo_h
#define AddtionalVehicleInfo_h

#import <Jastor.h>

@interface AddtionalVehicleInfo : Jastor

@property (copy, nonatomic) NSString *brand;


//出厂日期
@property (copy, nonatomic) NSString *productionTime;

//1汽车泵 2车载泵 3拖式泵
@property (copy, nonatomic) NSString *type;

//理论输送方量,车载泵和拖式泵属性
@property (assign, nonatomic) CGFloat flow;

//臂长,汽车泵属性
@property (assign, nonatomic) CGFloat armLength;

@end

#endif /* AddtionalVehicleInfo_h */
