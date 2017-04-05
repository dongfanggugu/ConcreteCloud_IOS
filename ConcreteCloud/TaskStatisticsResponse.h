//
//  TaskStatisticsResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaskStatisticsResponse_h
#define TaskStatisticsResponse_h

#import "ResponseDictionary.h"
#import "TaskStatisticsInfo.h"

@interface TaskStatisticsResponse : ResponseDictionary

- (TaskStatisticsInfo *)getStatisticsInfo;

@end


#endif /* TaskStatisticsResponse_h */
