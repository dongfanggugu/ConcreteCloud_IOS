//
//  Location.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Location_h
#define Location_h

#import <BaiduMapAPI_Location/BMKLocationComponent.h>


@interface Location : NSObject

- (void)startLocationService;

+ (instancetype)sharedLocation;

+ (CLLocationDistance)distancePoint:(CLLocationCoordinate2D)point1 with:(CLLocationCoordinate2D)point2;

@end

#endif /* Location_h */