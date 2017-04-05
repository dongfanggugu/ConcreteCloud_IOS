//
//  TaskStatisticsInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaskStatisticsInfo_h
#define TaskStatisticsInfo_h

#import <Jastor.h>

@interface TaskStatisticsInfo : Jastor

//累计车次
@property (assign, nonatomic) NSInteger count;

//累计方量
@property (assign, nonatomic) CGFloat weight;

//0-5公里累计车次和累计方量
@property (assign, nonatomic) NSInteger count0;

@property (assign, nonatomic) CGFloat weight0;

//5-10公里
@property (assign, nonatomic) NSInteger count5;

@property (assign, nonatomic) CGFloat weight5;

//10-15
@property (assign, nonatomic) NSInteger count10;

@property (assign, nonatomic) CGFloat weight10;

//15-20
@property (assign, nonatomic) NSInteger count15;

@property (assign, nonatomic) CGFloat weight15;

//20-25
@property (assign, nonatomic) NSInteger count20;

@property (assign, nonatomic) CGFloat weight20;

//25-30
@property (assign, nonatomic) NSInteger count25;

@property (assign, nonatomic) CGFloat weight25;

//30-35
@property (assign, nonatomic) NSInteger count30;

@property (assign, nonatomic) CGFloat weight30;

//35-40
@property (assign, nonatomic) NSInteger count35;

@property (assign, nonatomic) CGFloat weight35;

//40以上
@property (assign, nonatomic) NSInteger count40;

@property (assign, nonatomic) CGFloat weight40;

@end


#endif /* TaskStatisticsInfo_h */
