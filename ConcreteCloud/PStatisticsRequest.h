//
//  PStatisticsRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PStatisticsRequest_h
#define PStatisticsRequest_h

#import "Request.h"

@interface PStatisticsRequest : Request

@property (strong, nonatomic) NSString *branchId;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *supplierId;

@property (strong, nonatomic) NSString *siteId;

@end

#endif /* PStatisticsRequest_h */
