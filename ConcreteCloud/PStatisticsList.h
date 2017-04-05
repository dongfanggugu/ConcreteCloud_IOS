//
//  PStatisticsList.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PStatisticsList_h
#define PStatisticsList_h

#import <Jastor.h>
#import "PStatisticsInfo.h"
#import "TaskStatisticsInfo.h"

@interface PStatisticsList : Jastor

@property (strong, nonatomic) NSArray<PStatisticsInfo *> *list;


@end

#endif /* PStatisticsList_h */
