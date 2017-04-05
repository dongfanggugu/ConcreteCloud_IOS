//
//  PStatisticsResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PStatisticsResponse_h
#define PStatisticsResponse_h

#import "ResponseDictionary.h"
#import "PStatisticsList.h"

@interface PStatisticsResponse : ResponseDictionary

@property (strong, nonatomic) PStatisticsList *body;

@end

#endif /* PStatisticsResponse_h */
