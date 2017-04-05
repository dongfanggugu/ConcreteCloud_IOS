//
//  DVehicleTrailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVehicleTrailController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "VehicleTrailInfo.h"
#import "VehicleTrailRequest.h"
#import "Response+VehicleTrail.h"

@interface DVehicleTrailController()<BMKMapViewDelegate>
{
    NSMutableArray<VehicleTrailInfo *> *_arrayTrail;
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation DVehicleTrailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆轨迹"];
    [self initData];
    [self initView];
    [self getVehicleTrail];
}

- (void)initData
{
    _arrayTrail = [NSMutableArray array];
}

- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
}

- (UIImage *)getVehicleImage
{
    NSInteger type = [_cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return [UIImage imageNamed:@"icon_tanker_trace"];
    }
    else if (3 == type)
    {
        NSInteger bcType = [_pumpType integerValue];
        
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

#pragma mark -- Network Request

- (void)getVehicleTrail
{
    VehicleTrailRequest *request = [[VehicleTrailRequest alloc] init];
    request.taskId = _processId;
    request.type = @"A";
    
    [[HttpClient shareClient] view:self.view post:URL_VEHICLE_TRAIL parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        ResponseArray *response = [[ResponseArray alloc] initWithDictionary:responseObject];
        [_arrayTrail addObjectsFromArray:[response getVehicleTrailArray]];
        [self markHzs];
        [self markSite];
        [self markVehicle];
        [self markTrail];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - mark on the map

- (void)markSite
{
    CLLocationCoordinate2D coor;
    coor.latitude = _siteLat;
    coor.longitude = _siteLng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    marker.title = @"site";
    [_mapView addAnnotation:marker];
}

- (void)markHzs
{
    
    CLLocationCoordinate2D coor;
    coor.latitude = _hzsLat;
    coor.longitude = _hzsLng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"hzs";
    [_mapView addAnnotation:marker];
    [_mapView setCenterCoordinate:coor animated:YES];
}

- (void)markVehicle
{
    if (0 == _arrayTrail.count)
    {
        return;
    }
    CLLocationCoordinate2D coor;
    coor.latitude = _arrayTrail[0].lat;
    coor.longitude = _arrayTrail[0].lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"vehicle";
    [_mapView addAnnotation:marker];
    [_mapView setCenterCoordinate:coor];
}

- (void)markTrail
{
    if (0 == _arrayTrail.count)
    {
        return;
    }
    
    NSInteger count = _arrayTrail.count;
    CLLocationCoordinate2D coor[count];
    for (int i = 0; i < count; i++)
    {
        coor[i].latitude = _arrayTrail[i].lat;
        coor[i].longitude = _arrayTrail[i].lng;
    }
    
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coor count:count];
    
    [_mapView addOverlay:polyline];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"site"])
    {
        BMKAnnotationView *supplierView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"site"];
        supplierView.image = [UIImage imageNamed:@"icon_build_site"];
        
        supplierView.canShowCallout = NO;
        return supplierView;
    }
    else if ([title isEqualToString:@"hzs"])
    {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hzs"];
        siteView.image = [UIImage imageNamed:@"icon_mix_point"];
        
        siteView.canShowCallout = NO;
        return siteView;
    }
    else if ([title isEqualToString:@"vehicle"])
    {
        BMKAnnotationView *vehicleView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"vehicle"];
        vehicleView.image = [self getVehicleImage];
        
        vehicleView.canShowCallout = NO;
        return vehicleView;
    }
    
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineDash = NO;
    polylineView.lineWidth = 4;
    
    return polylineView;
}

@end
