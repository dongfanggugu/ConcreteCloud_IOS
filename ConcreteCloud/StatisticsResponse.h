//
//  StatisticsResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef StatisticsResponse_h
#define StatisticsResponse_h

#import "ResponseDictionary.h"
#import "PStatisticsList.h"
#import "TaskStatisticsInfo.h"

@interface StatisticsResponse : ResponseDictionary

- (TaskStatisticsInfo *)getAStatistics;

@end


#endif /* StatisticsResponse_h */
