//
//  VehicleMapAnnotation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VehicleMapAnnotation_h
#define VehicleMapAnnotation_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "PTrackInfo.h"
#import "DTrackInfo.h"

@interface VehicleMapAnnotation : NSObject<BMKAnnotation>

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;

@property (strong, nonatomic) PTrackInfo *info;

@property (strong, nonatomic) DTrackInfo *dInfo;

//1:B单  2:A单
@property (assign, nonatomic) Order_Type type;

@property (assign, nonatomic) CLLocationDegrees lat;

@property (assign, nonatomic) CLLocationDegrees lng;

@property (assign, nonatomic) NSString *title;

@property (strong, nonatomic) UIColor *color;

@end


#endif /* VehicleMapAnnotation_h */
