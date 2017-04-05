//
//  RentMapAnnotation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentMapAnnotation_h
#define RentMapAnnotation_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RenterInfo.h"

@interface RentMapAnnotation : NSObject<BMKAnnotation>

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;

@property (strong, nonatomic) RenterInfo *info;

@property (assign, nonatomic) CLLocationDegrees lat;

@property (assign, nonatomic) CLLocationDegrees lng;

@property (assign, nonatomic) NSString *title;

@end


#endif /* RentMapAnnotation_h */
