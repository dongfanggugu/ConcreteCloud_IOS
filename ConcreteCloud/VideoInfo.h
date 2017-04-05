//
//  VideoInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VideoInfo_h
#define VideoInfo_h

#import <Jastor.h>

@interface VideoInfo : Jastor

@property (copy, nonatomic) NSString *castingPart;

@property (copy, nonatomic) NSString *currentNum;

@property (copy, nonatomic) NSString *plateNum;

@property (copy, nonatomic) NSString *siteName;

@property (copy, nonatomic) NSString *upTime;

@property (copy, nonatomic) NSString *url;

@property (copy, nonatomic) NSString *videoType;

@property (assign, nonatomic) NSInteger resId;

@property (copy, nonatomic) NSString *driverName;

@property (copy, nonatomic) NSString *examName;

@property (copy, nonatomic) NSString *firstFrame;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *standard;


@property (copy, nonatomic) NSString *supplierName;

@property (copy, nonatomic) NSString *taskCode;

@end

#endif /* VideoInfo_h */
