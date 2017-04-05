//
//  VehicleTrailInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VehicleTrailInfo_h
#define VehicleTrailInfo_h

#import <Jastor.h>

@interface VehicleTrailInfo : Jastor

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *plateNum;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@end


#endif /* VehicleTrailInfo_h */
