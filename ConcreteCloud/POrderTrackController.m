//
//  POrderTrackController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POrderTrackController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "TrackInfoCell.h"
#import "PTrackInfo.h"
#import "PProcessListRequest.h"
#import "Response+PProcessList.h"
#import "PProcessList.h"
#import "VehicleAnnotationView.h"
#import "VehicleMapAnnotation.h"
#import "VehicleTrailController.h"

@interface POrderTrackController()<UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate>
{
    NSMutableArray<PTrackInfo *> *_arrayTrack;
    
    NSMutableDictionary<NSString*, VehicleAnnotationView *> *_dicAnnView;
    
    VehicleAnnotationView *_curAnnotationView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) PProcessList *processInfo;


@end

@implementation POrderTrackController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆跟踪"];
    [self initNavRightWithText:@"刷新"];
    [self initData];
    [self initView];
    [self getProcess];
}

- (void)initData
{
    _arrayTrack = [NSMutableArray array];
    _dicAnnView = [NSMutableDictionary dictionary];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;

}

- (void)onClickNavRight
{
    [_arrayTrack removeAllObjects];
    
    [_mapView removeAnnotations:_mapView.annotations];

    if (_curAnnotationView)
    {
        [_curAnnotationView hideInfoWindow];
        _curAnnotationView = nil;
    }

    [self getProcess];
}

- (NSString *)getVehicleType:(NSString *)cls
{
    NSString *result = @"砂石运输车";
    NSInteger type = [cls integerValue];
    if (4 == type)
    {
        result = @"砂石运输车";
    }
    else if (5 == type)
    {
        result = @"外加剂运输车";
    }
    else if (6 == type)
    {
        result = @"散装粉料运输车";
    }
    
    return result;
}

- (UIImage *)getVehicleImage:(NSString *)cls
{
    NSInteger type = [cls integerValue];
    
    if (4 == type)
    {
        return [UIImage imageNamed:@"icon_car_type4"];
        
    } else if (5 == type) {
        return [UIImage imageNamed:@"icon_car_type5"];
        
    } else if (6 == type) {
        return [UIImage imageNamed:@"icon_car_type6"];
    }
    
    return [UIImage imageNamed:@"icon_car_type4"];
}
#pragma mark - Network Request

- (void)getProcess
{
    PProcessListRequest *request = [[PProcessListRequest alloc] init];
    request.supplierId = _supplierId;
    request.supplierOrderId = _orderId;
    request.finish = @"1";
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:URL_P_VEHICLE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.processInfo = [[ResponseDictionary alloc] getProcessList:[responseObject objectForKey:@"body"]];
        [_arrayTrack addObjectsFromArray:weakSelf.processInfo.info];
        [weakSelf.tableView reloadData];
        [weakSelf markSupplier];
        [weakSelf markSite];
        [weakSelf markVehicles];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - marker on the map

- (void)markSupplier
{
    CGFloat lat = _processInfo.supplier.lat;
    CGFloat lng = _processInfo.supplier.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    marker.title = @"supplier";
    [_mapView addAnnotation:marker];
}

- (void)markSite
{
    CGFloat lat = _processInfo.hzs.lat;
    CGFloat lng = _processInfo.hzs.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"site";
    [_mapView addAnnotation:marker];
}

- (void)markVehicles
{
    for (PTrackInfo *info in _processInfo.info) {
        VehicleMapAnnotation *marker = [[VehicleMapAnnotation alloc] initWithLatitude:info.lat lng:info.lng ];
        marker.title = @"vehicle";
        marker.info = info;
        [_mapView addAnnotation:marker];
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"supplier"]) {
        BMKAnnotationView *supplierView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        supplierView.image = [UIImage imageNamed:@"icon_supplier"];
        
        supplierView.canShowCallout = NO;
        return supplierView;
        
    } else if ([title isEqualToString:@"site"]) {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        siteView.image = [UIImage imageNamed:@"icon_build_site"];
        
        siteView.canShowCallout = NO;
        return siteView;
        
    } else if ([title isEqualToString:@"vehicle"]) {
        VehicleMapAnnotation *ann = (VehicleMapAnnotation *)annotation;
        PTrackInfo *info = ann.info;
        
        VehicleAnnotationView *vehicleView = (VehicleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"vehicle"];
        
        if (nil == vehicleView) {
            vehicleView = [[VehicleAnnotationView alloc] initWithAnnotation:annotation
                                                                               reuseIdentifier:@"vehicle" image:[self getVehicleImage:info.cls]];
        }
        vehicleView.info = info;
        
        _dicAnnView[info.processId] = vehicleView;
        
        return vehicleView;
    }
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (nil == _curAnnotationView)
    {
        return;
    }
    
    [_curAnnotationView hideInfoWindow];
    _curAnnotationView = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTrack.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[TrackInfoCell identifier]];
    
    if (!cell) {
        cell = [TrackInfoCell cellFromNib];
    }
    
    PTrackInfo *info = _arrayTrack[indexPath.row];
    
    cell.lbTime.text = [NSString stringWithFormat:@"%ld分钟", info.arriveTime.integerValue];
    cell.lbType.text = [self getVehicleType:info.cls];
    
    cell.lbPlate.text = info.plateNum;
    cell.lbDriver.text = info.driverName;
    cell.lbDistance.text = [NSString stringWithFormat:@"%.1lf公里", info.distance];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTrackInfo *info = _arrayTrack[indexPath.row];
    VehicleAnnotationView *annView = _dicAnnView[info.processId];
    
    if (nil == _curAnnotationView)
    {
        [annView showInfoWindow];
        _curAnnotationView = annView;
    }
    else if (annView == _curAnnotationView)
    {
        return;
    }
    else
    {
        [_curAnnotationView hideInfoWindow];
        [annView showInfoWindow];
        _curAnnotationView = annView;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [_curAnnotationView.infoView setOnClickDetailListener:^{
        VehicleTrailController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"vehicle_trail_controller"];
        controller.cls = info.cls;
        controller.processId = info.processId;
        controller.siteLat = weakSelf.processInfo.hzs.lat;
        controller.siteLng = weakSelf.processInfo.hzs.lng;
        
        controller.supplierLat = weakSelf.processInfo.supplier.lat;
        controller.supplierLng = weakSelf.processInfo.supplier.lng;
        
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    CLLocationCoordinate2D coor;
    coor.latitude = info.lat;
    coor.longitude = info.lng;
    [_mapView setCenterCoordinate:coor animated:YES];
}

@end
