//
//  CustomLocation.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CustomLocation.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface CustomLocation () <BMKLocationServiceDelegate>

@property (strong ,nonatomic) BMKLocationService *locService;

@property (strong, nonatomic) NSDictionary *customInfo;

@end

@implementation CustomLocation

- (instancetype)initLocationWith:(NSDictionary *)info
{
    self = [super init];
    
    if (self) {
        self.customInfo = info;
    }
    
    return self;
}

- (void)startLocationService
{
    _locService = [[BMKLocationService alloc]init];
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locService.distanceFilter = 1.0f;
    
    
    _locService.delegate = self;
    
    [_locService startUserLocationService];
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //关闭定位
    [_locService stopUserLocationService];
    
    _locService = nil;
    
    NSLog(@"custom before send notify");
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[User_Location] = userLocation;
    
    userInfo[User_Custom] = _customInfo;
    
    
    NSNotification *notification =[NSNotification notificationWithName:Custom_Location_Complete object:nil userInfo:userInfo];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"custom after send notify");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locService stopUserLocationService];
    
    _locService = nil;
    
    NSNotification *notification =[NSNotification notificationWithName:Custom_Location_Complete object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@", userLocation.heading);
}

+ (CLLocationDistance)distancePoint:(CLLocationCoordinate2D)point1 with:(CLLocationCoordinate2D)point2
{
    BMKMapPoint p1 = BMKMapPointForCoordinate(point1);
    BMKMapPoint p2 = BMKMapPointForCoordinate(point2);
    
    return  BMKMetersBetweenMapPoints(p1,p2);
}

@end
