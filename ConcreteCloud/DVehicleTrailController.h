//
//  DVehicleTrailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DVehicleTrailController_h
#define DVehicleTrailController_h

#import "TitleViewController.h"

@interface DVehicleTrailController : TitleViewController

@property (assign, nonatomic) CGFloat hzsLat;

@property (assign, nonatomic) CGFloat hzsLng;

@property (assign, nonatomic) CGFloat siteLat;

@property (assign, nonatomic) CGFloat siteLng;

@property (copy, nonatomic) NSString *processId;

@property (copy, nonatomic) NSString *cls;

@property (copy, nonatomic) NSString *pumpType;

@end

#endif /* DVehicleTrailController_h */
