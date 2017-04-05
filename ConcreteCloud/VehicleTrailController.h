//
//  VehicleTrailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VehicleTrailController_h
#define VehicleTrailController_h

#import "TitleViewController.h"

@interface VehicleTrailController : TitleViewController

@property (assign, nonatomic) CGFloat siteLat;

@property (assign, nonatomic) CGFloat siteLng;

@property (assign, nonatomic) CGFloat supplierLat;

@property (assign, nonatomic) CGFloat supplierLng;

@property (copy, nonatomic) NSString *processId;

@property (copy, nonatomic) NSString *cls;

@end

#endif /* VehicleTrailController_h */
