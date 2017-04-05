//
//  HzsMapAnnotation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsMapAnnotation_h
#define HzsMapAnnotation_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HzsInfo.h"


@interface HzsMapAnnotation : NSObject<BMKAnnotation>

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;

@property (strong, nonatomic) HzsInfo *info;

@property (assign, nonatomic) CLLocationDegrees lat;

@property (assign, nonatomic) CLLocationDegrees lng;

@property (assign, nonatomic) NSString *title;

@property (strong, nonatomic) UIColor *color;

@end



#endif /* HzsMapAnnotation_h */
