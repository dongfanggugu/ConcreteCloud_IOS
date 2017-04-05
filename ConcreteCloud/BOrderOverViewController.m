//
//  BOrderOverViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "BOrderOverViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CustomAnnotationView.h"
#import "HzsMapAnnotation.h"
#import "HzsAnnotationView.h"
#import "SupplierMapAnnotation.h"
#import "SupplierAnnotationView.h"
#import "HzsSupplierListResponse.h"
#import "VehicleMapAnnotation.h"
#import "VehicleAnnotationView.h"


@interface BOrderOverViewController () <BMKMapViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSMutableDictionary<NSString *, UIColor *> *dicColor;

@property (weak, nonatomic) CustomAnnotationView *annView;

@end

@implementation BOrderOverViewController

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
    param[@"hzsId"] = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_HZS_SUPPLIER parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        HzsSupplierListResponse *response = [[HzsSupplierListResponse alloc] initWithDictionary:responseObject];
        
        NSArray<SupplierInfo *> *supplierList = [response getHzsSupllierInfo].supplierList;
        
        NSArray<PTrackInfo *> *vehicleList = [response getHzsSupllierInfo].taskList;
        
        [self markSuppliers:supplierList];
        
        [self markVehicles:vehicleList];
        
        [self markHzs];
        
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

- (void)markSuppliers:(NSArray<SupplierInfo *> *)supplierList
{
    for (NSInteger i = 0; i < supplierList.count; i++)
    {
        SupplierInfo *info = supplierList[i];
        
        SupplierMapAnnotation *ann = [[SupplierMapAnnotation alloc] initWithLatitude:info.lat lng:info.lng];
        
        ann.info = info;
        
        ann.color = [self getTagColor:i];
        
        _dicColor[info.name] = ann.color;
        
        ann.title = @"supplier";
        
        [_mapView addAnnotation:ann];
        
    }
}

- (void)markVehicles:(NSArray<PTrackInfo *> *)vehicleList
{
    for (NSInteger i = 0; i < vehicleList.count; i++)
    {
        
        PTrackInfo *info = vehicleList[i];
        
        VehicleMapAnnotation *ann = [[VehicleMapAnnotation alloc] initWithLatitude:info.lat lng:info.lng];
        
        ann.info = info;
        
        ann.color = _dicColor[info.supplierName];
        
        ann.title = @"vehicle";
        
        [_mapView addAnnotation:ann];
    }
}

- (void)markHzs
{
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = [[Config shareConfig] getLat];
    coor.longitude = [[Config shareConfig] getLng];
    
    ann.coordinate = coor;
    ann.title = @"hzs";
    
    [_mapView addAnnotation:ann];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"supplier"])
    {
        SupplierMapAnnotation *ann = (SupplierMapAnnotation *)annotation;
        
        SupplierAnnotationView *annView = (SupplierAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"supplier"];
        
        if (!annView)
        {
            annView = [[SupplierAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:@"supplier"];
        }
        
        annView.info = ann.info;
        annView.color = ann.color;
        
        return annView;
    }
    else if ([title isEqualToString:@"vehicle"])
    {
        VehicleMapAnnotation *ann = (VehicleMapAnnotation *)annotation;
        
        VehicleAnnotationView *annView = (VehicleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"vehicle"];
        
        if (!annView)
        {
            annView = [[VehicleAnnotationView alloc] initWithAnnotationAndTag:ann reuseIdentifier:@"vehicle"
                                                                        image:[self getVehicleImage:ann.info]];
        }
        
        annView.type = Order_B;
        
        annView.info = ann.info;
        annView.color = ann.color;
        
        return annView;
    }
    else if ([title isEqualToString:@"hzs"])
    {
        BMKPinAnnotationView *annView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hzs"];
        
        annView.canShowCallout = NO;
        
        annView.image = [UIImage imageNamed:@"icon_mix_point"];
        
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

- (UIImage *)getVehicleImage:(PTrackInfo *)taskInfo
{
    NSInteger type = [taskInfo.cls integerValue];
    
    if (4 == type)
    {
        return [UIImage imageNamed:@"icon_car_type4"];
    }
    else if (5 == type)
    {
        return [UIImage imageNamed:@"icon_car_type5"];
    }
    else if (6 == type)
    {
        return [UIImage imageNamed:@"icon_car_type6"];
    }
    
    return nil;
}

@end
