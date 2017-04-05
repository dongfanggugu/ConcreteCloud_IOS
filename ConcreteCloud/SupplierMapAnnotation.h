//
//  SupplierMapAnnotation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SupplierInfo.h"

@interface SupplierMapAnnotation : NSObject <BMKAnnotation>

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;

@property (strong, nonatomic) SupplierInfo *info;

@property (assign, nonatomic) CLLocationDegrees lat;

@property (assign, nonatomic) CLLocationDegrees lng;

@property (assign, nonatomic) NSString *title;

@property (strong, nonatomic) UIColor *color;

@end
