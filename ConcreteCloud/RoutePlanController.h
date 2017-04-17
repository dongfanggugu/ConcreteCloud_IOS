//
//  RoutePlanController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "TitleViewController.h"
#import <BaiduMapAPI_Base/BMKUserLocation.h>

@interface RoutePlanController : TitleViewController

/** poi*/
@property (assign, nonatomic) CLLocationCoordinate2D destination;

/** 用户当前位置*/
@property(assign , nonatomic) CLLocationCoordinate2D start;

@end
