//
//  SiteAOrderOverViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteAOrderOverViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HzsSiteListResponse.h"
#import "SiteMapAnnotation.h"
#import "SiteAnnotationView.h"
#import "VehicleMapAnnotation.h"
#import "VehicleAnnotationView.h"
#import "CustomAnnotationView.h"
#import "HzsMapAnnotation.h"
#import "HzsAnnotationView.h"

@interface SiteAOrderOverViewController()<BMKMapViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSMutableDictionary<NSString *, UIColor *> *dicColor;

@property (weak, nonatomic) CustomAnnotationView *annView;

@end


@implementation SiteAOrderOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"订单概览"];
    
    [self initData];
    [self initMap];
    
    [self getSiteList];
    
}

- (void)initData
{
    _dicColor = [NSMutableDictionary dictionary];
}

- (void)initMap
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    [self.view addSubview:_mapView];
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 12;
}


#pragma mark - 网络请求
- (void)getSiteList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"siteId"] = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_SITE_HZS parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        HzsSiteListResponse *response = [[HzsSiteListResponse alloc] initWithDictionary:responseObject];
        
        NSArray<HzsInfo *> *hzsList = [response getHzsSiteInfo].hzsList;
        
        NSArray<DTrackInfo *> *vehicleList = [response getHzsSiteInfo].taskList;
        
        [self markHzses:hzsList];
        
        [self markVehicles:vehicleList];
        
        [self markSite];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


- (UIColor *)getTagColor:(NSInteger)index
{
    NSString *color = TITLE_COLOR;
    switch (index % 5) {
        case 0:
            color = COLOR_SITE_1;
            break;
            
        case 1:
            color = COLOR_SITE_2;
            break;
            
        case 2:
            color = COLOR_SITE_3;
            break;
            
        case 3:
            color = COLOR_SITE_4;
            break;
            
        case 4:
            color =COLOR_SITE_5;
            break;
            
        default:
            break;
    }
    
    return [Utils getColorByRGB:color];
}


#pragma mark -  地图标记

- (void)markSite
{
    
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = [[Config shareConfig] getLat];
    coor.longitude = [[Config shareConfig] getLng];
    
    ann.coordinate = coor;
    ann.title = @"site";
    
    [_mapView addAnnotation:ann];
    
}

- (void)markVehicles:(NSArray<DTrackInfo *> *)vehicleList
{
    for (NSInteger i = 0; i < vehicleList.count; i++)
    {
        
        DTrackInfo *info = vehicleList[i];
        
        VehicleMapAnnotation *ann = [[VehicleMapAnnotation alloc] initWithLatitude:info.lat lng:info.lng];
        
        ann.dInfo = info;
        
        ann.color = _dicColor[info.hzs_Order.hzsId];
        
        ann.title = @"vehicle";
        
        [_mapView addAnnotation:ann];
    }
}

- (void)markHzses:(NSArray<HzsInfo *> *)hzsList
{
    for (NSInteger i = 0; i < hzsList.count; i++)
    {
        HzsInfo *info = hzsList[i];
        
        HzsMapAnnotation *ann = [[HzsMapAnnotation alloc] initWithLatitude:info.lat lng:info.lng];
        
        ann.info = info;
        
        ann.color = [self getTagColor:i];
        
        _dicColor[info.hzsId] = ann.color;
        
        ann.title = @"hzs";
        
        [_mapView addAnnotation:ann];
        
    }

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"hzs"])
    {
        HzsMapAnnotation *ann = (HzsMapAnnotation *)annotation;
        
        HzsAnnotationView *annView = (HzsAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"hzs"];
        
        if (!annView)
        {
            annView = [[HzsAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:@"hzs"];
        }
        
        annView.info = ann.info;
        
        annView.color = ann.color;
        
        annView.hideOperation = YES;
        
        return annView;
    }
    else if ([title isEqualToString:@"vehicle"])
    {
        VehicleMapAnnotation *ann = (VehicleMapAnnotation *)annotation;
        
        VehicleAnnotationView *annView = (VehicleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"vehicle"];
        
        if (!annView)
        {
            annView = [[VehicleAnnotationView alloc] initWithAnnotationAndTag:ann reuseIdentifier:@"vehicle"
                                                                        image:[self getVehicleImage:ann.dInfo]];
        }
        
        annView.type = Order_A;
        
        annView.dInfo = ann.dInfo;
        annView.color = ann.color;
        
        annView.hideOperation = YES;
        
        return annView;
    }
    else if ([title isEqualToString:@"site"])
    {
        BMKPinAnnotationView *annView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hzs"];
        
        annView.canShowCallout = NO;
        
        annView.image = [UIImage imageNamed:@"icon_build_site"];
        
        CGRect frame = annView.frame;
        
        frame.size.width = 25;
        frame.size.height = 25;
        
        annView.frame = frame;
        
        return annView;
    }
    
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[CustomAnnotationView class]])
    {
        CustomAnnotationView *annView = (CustomAnnotationView *)view;
        
        if (!_annView)
        {
            _annView = annView;
            [_annView showInfoWindow];
        }
        else
        {
            if (_annView == annView)
            {
                [_annView hideInfoWindow];
                _annView = nil;
            }
            else
            {
                [_annView hideInfoWindow];
                _annView = annView;
                [_annView showInfoWindow];
            }
        }
        
        
    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (_annView)
    {
        [_annView hideInfoWindow];
        _annView = nil;
    }
}

- (UIImage *)getVehicleImage:(DTrackInfo *)info
{
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return [UIImage imageNamed:@"icon_tanker_trace"];
    }
    else if (3 == type)
    {
        NSInteger bcType = [info.vehicleType integerValue];
        
        if (1 == bcType)
        {
            return [UIImage imageNamed:@"icon_pump"];
        }
        else if (2 == bcType)
        {
            return [UIImage imageNamed:@"icon_pump2"];
        }
        else if (3 == bcType)
        {
            return [UIImage imageNamed:@"icon_pump3"];
        }
        else
        {
            return [UIImage imageNamed:@"icon_pump"];
        }
    }
    else
    {
        return [UIImage imageNamed:@"icon_tanker_trace"];
    }
}


@end
