//
//  TaskStatisticsRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaskStatisticsRequest_h
#define TaskStatisticsRequest_h

#import "Request.h"

typedef NS_ENUM(NSInteger, Statistics_Type)
{
    MONTH = 1,
    YEAR,
    CUSTOM
};

@interface TaskStatisticsRequest : Request

//1单月统计 2全年统计 3自定义查询
@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *startDate;

@property (copy, nonatomic) NSString *endDate;

@end


#endif /* TaskStatisticsRequest_h */
