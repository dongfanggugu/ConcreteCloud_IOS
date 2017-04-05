//
//  HzsAddTaskRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsAddTaskRequest_h
#define HzsAddTaskRequest_h

#import "Request.h"

@interface HzsAddTaskRequest : Request

@property (copy, nonatomic) NSString *hzsOrderId;

@property (copy, nonatomic) NSString *vehicleId;

@property (assign, nonatomic) CGFloat number;

@end


#endif /* HzsAddTaskRequest_h */
