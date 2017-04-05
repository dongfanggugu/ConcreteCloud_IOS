//
//  RentBindRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentBindRequest_h
#define RentBindRequest_h

#import "Request.h"

@interface RentBindRequest : Request

@property (copy, nonatomic) NSString *vehicelId;

@property (copy, nonatomic) NSString *driverId;

@end


#endif /* RentBindRequest_h */
