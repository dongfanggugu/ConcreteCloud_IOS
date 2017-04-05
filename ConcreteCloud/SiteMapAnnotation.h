//
//  SiteMapAnnotation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SiteMapAnnotation_h
#define SiteMapAnnotation_h


#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ProjectInfo.h"


@interface SiteMapAnnotation : NSObject<BMKAnnotation>

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;

@property (strong, nonatomic) ProjectInfo *info;

@property (assign, nonatomic) CLLocationDegrees lat;

@property (assign, nonatomic) CLLocationDegrees lng;

@property (assign, nonatomic) NSString *title;

@property (strong, nonatomic) UIColor *color;

@end


#endif /* SiteMapAnnotation_h */
