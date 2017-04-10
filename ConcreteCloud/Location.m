//
//  Location.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface Location()<BMKLocationServiceDelegate>

@property (nonatomic ,strong) BMKLocationService *locService;

//@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation Location


+ (instancetype)sharedLocation
{
    static Location *_sharedLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      
                      _sharedLocation = [[Location alloc] init];
                      
                  });
    
    return _sharedLocation;
}


- (void)startLocationService
{
    
    NSLog(@"location start");
    
    if (!_locService)
    {
        NSLog(@"sevice is nil");
        
        _locService = [[BMKLocationService alloc]init];
        _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locService.distanceFilter = 1.0f;
        
        
        _locService.delegate = self;
        
        [_locService startUserLocationService];
        
    }
    else
    {
        NSLog(@"sevice is not nil");
    }
    
    
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    
    NSLog(@"lat:%lf  lng:%lf", coor.latitude, coor.longitude);
    
    //关闭定位
    [_locService stopUserLocationService];
    
    _locService = nil;
    
    
    NSLog(@"before send notify");
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userLocation forKey:User_Location];
    
    NSNotification *notification =[NSNotification notificationWithName:Location_Complete object:nil userInfo:userInfo];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"after send notify");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locService stopUserLocationService];
    
    _locService = nil;
    
    NSNotification *notification =[NSNotification notificationWithName:Location_Complete object:nil userInfo:nil];
    
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
