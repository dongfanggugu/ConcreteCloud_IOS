//
//  PumpTrailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PumpTrailController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "DVehicleTrailController.h"

@interface PumpTrailController()<BMKMapViewDelegate>
{
    __weak IBOutlet UILabel *_lbDate;
    
    __weak IBOutlet UILabel *_lbProject;
    
    __weak IBOutlet UILabel *_lbPart;
    
    __weak IBOutlet UILabel *_lbAddress;
    
    __weak IBOutlet UILabel *_lbLevel;
    
    __weak IBOutlet BMKMapView *_mapView;
    
    __weak IBOutlet NSLayoutConstraint *_conHeight;
    
}

@end


@implementation PumpTrailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"泵车轨迹"];
    [self initView];
}


- (void)initView
{
    _lbDate.text = _trackInfo.startTime;
    _lbProject.text = _trackInfo.hzs_Order.siteName;
    _lbAddress.text = _trackInfo.hzs_Order.siteAddress;
    _lbPart.text = _trackInfo.hzs_Order.castingPart;
    _lbLevel.text = _trackInfo.hzs_Order.intensityLevel;
    
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    _mapView.zoomEnabled = YES;
    
    [self markSite];
    [self markHzs];
    [self markPump];
}

- (void)markSite
{
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = _trackInfo.hzs_Order.siteLat;
    coor.longitude = _trackInfo.hzs_Order.siteLng;
    
    ann.coordinate = coor;
    ann.title = @"site";
    
    [_mapView addAnnotation:ann];
}

- (void)markHzs
{
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = _trackInfo.hzs_Order.hzsLat;
    coor.longitude = _trackInfo.hzs_Order.hzsLng;
    
    ann.coordinate = coor;
    ann.title = @"hzs";
    
    [_mapView addAnnotation:ann];

}

- (void)markPump
{
    BMKPointAnnotation *ann = [[BMKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coor;
    coor.latitude = _trackInfo.lat;
    coor.longitude = _trackInfo.lng;
    
    ann.coordinate = coor;
    ann.title = @"pump";
    
    _mapView.centerCoordinate = coor;
    
    [_mapView addAnnotation:ann];
}

- (UIImage *)getPumpImage:(NSString *)vehicleType
{
    NSInteger bcType = [vehicleType integerValue];
    
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
#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    BMKAnnotationView *annView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
    annView.canShowCallout = NO;
    
    if ([title isEqualToString:@"site"]) {
        annView.image = [UIImage imageNamed:@"icon_build_site"];
        
    } else if ([title isEqualToString:@"hzs"]) {
        annView.image = [UIImage imageNamed:@"icon_mix_point"];
        
    } else {
        annView.image = [self getPumpImage:_trackInfo.vehicleType];
    }
    
    return annView;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
    DVehicleTrailController *controller = [board instantiateViewControllerWithIdentifier:@"d_vehicle_trail_controller"];
    controller.cls = _trackInfo.cls;
    controller.pumpType = _trackInfo.vehicleType;
    
    controller.processId = _trackInfo.trackId;
    controller.hzsLat = _trackInfo.hzs_Order.hzsLat;
    controller.hzsLng = _trackInfo.hzs_Order.hzsLng;
    
    controller.siteLat = _trackInfo.hzs_Order.siteLat;
    controller.siteLng = _trackInfo.hzs_Order.siteLng;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
