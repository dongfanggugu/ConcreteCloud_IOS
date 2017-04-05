//
//  RentVehicleAddRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleAddRequest_h
#define RentVehicleAddRequest_h

#import "Request.h"

@interface RentVehicleAddRequest : Request

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *leaseId;

@property (copy, nonatomic) NSString *plateNum;

@property (copy, nonatomic) NSString *cls;

@property (assign, nonatomic) CGFloat selfNet;

@property (assign, nonatomic) CGFloat weight;

@property (copy, nonatomic) NSString *mold;

@property (copy, nonatomic) NSString *brand;

@property (copy, nonatomic) NSString *productionTime;

@property (assign, nonatomic) CGFloat armLength;

@property (assign, nonatomic) CGFloat flow;

@end


#endif /* RentVehicleAddRequest_h */
