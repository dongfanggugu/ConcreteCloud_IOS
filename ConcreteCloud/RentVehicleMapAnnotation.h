//
//  RentVehicleMapAnnotation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleMapAnnotation_h
#define RentVehicleMapAnnotation_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RentVehicleInfo.h"


@interface RentVehicleMapAnnotation : NSObject<BMKAnnotation>

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng;

@property (strong, nonatomic) RentVehicleInfo *info;

//1:罐车  2:汽车泵  3:车载泵、拖式泵
@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) CLLocationDegrees lat;

@property (assign, nonatomic) CLLocationDegrees lng;

@property (assign, nonatomic) NSString *title;

@end



#endif /* RentVehicleMapAnnotation_h */
