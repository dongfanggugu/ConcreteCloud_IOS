//
//  SiteMapAnnotation.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteMapAnnotation.h"

@implementation SiteMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng
{
    self = [super init];
    
    if (self)
    {
        _lat = lat;
        _lng =lng;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coor;
    coor.latitude = _lat;
    coor.longitude = _lng;
    return coor;
}


@end
