//
//  CustomLocation.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface CustomLocation : NSObject

- (void)startLocationService;

- (instancetype)initLocationWith:(NSDictionary *)info;

+ (CLLocationDistance)distancePoint:(CLLocationCoordinate2D)point1 with:(CLLocationCoordinate2D)point2;

@end
