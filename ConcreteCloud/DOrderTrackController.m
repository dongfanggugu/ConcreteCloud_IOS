//
//  DOrderTrackController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOrderTrackController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "TrackInfoCell.h"
#import "VehicleAnnotationView.h"
#import "VehicleMapAnnotation.h"
#import "DVehicleTrailController.h"
#import "DOrderDetailRequest.h"
#import "DProcessListResponse.h"
#import "DProcessList.h"
#import "DProcessInfo.h"

@interface DOrderTrackController()<UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate>
{
    NSMutableArray<DTrackInfo *> *_arrayTrack;
    
    NSMutableDictionary<NSString*, VehicleAnnotationView *> *_dicAnnView;
    
    VehicleAnnotationView *_curAnnotationView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) DProcessList *processInfo;


@end

@implementation DOrderTrackController

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

- (NSString *)getVehicleName:(DTrackInfo *)info
{
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return @"混凝土运输车";
    }
    else if (3 == type)
    {
        NSInteger gcType = [info.vehicleType integerValue];
        
        if (1 == gcType)
        {
            return @"汽车泵";
        }
        else if (2 == gcType)
        {
            return @"车载泵";
        }
        else if (3 == gcType)
        {
            return @"拖式泵";
        }
        else
        {
            return @"泵车";
        }
    }
    else
    {
        return @"混凝土运输车";
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
#pragma mark - Network Request

- (void)getProcess
{
    
    DOrderDetailRequest *request = [[DOrderDetailRequest alloc] init];
    request.hzsOrderId = _orderId;
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:nil post:URL_D_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        DProcessListResponse *response = [[DProcessListResponse alloc] initWithDictionary:responseObject];
        DProcessList *taskInfo = [response getProcessList];
        weakSelf.processInfo = taskInfo;
        [_arrayTrack addObjectsFromArray:taskInfo.process];
        
        [weakSelf.tableView reloadData];
        [weakSelf markProject];
        [weakSelf markHzs];
        [weakSelf markVehicles];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - marker on the map

- (void)markProject
{
    CGFloat lat = _processInfo.site.lat;
    CGFloat lng = _processInfo.site.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    marker.title = @"project";
    [_mapView addAnnotation:marker];
}

- (void)markHzs
{
    CGFloat lat = _processInfo.hzs.lat;
    CGFloat lng = _processInfo.hzs.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"hzs";
    [_mapView addAnnotation:marker];
}

- (void)markVehicles
{
    for (DTrackInfo *info in _processInfo.process)
    {
        VehicleMapAnnotation *marker = [[VehicleMapAnnotation alloc] initWithLatitude:info.lat
                                                                                  lng:info.lng];
        marker.title = @"vehicle";
        marker.type = 2;
        marker.dInfo = info;
        [_mapView addAnnotation:marker];
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"project"])
    {
        BMKAnnotationView *supplierView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        supplierView.image = [UIImage imageNamed:@"icon_build_site"];
        
        supplierView.canShowCallout = NO;
        return supplierView;
    }
    else if ([title isEqualToString:@"hzs"])
    {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        siteView.image = [UIImage imageNamed:@"icon_mix_point"];
        
        siteView.canShowCallout = NO;
        return siteView;
    }
    else if ([title isEqualToString:@"vehicle"])
    {
        VehicleMapAnnotation *ann = (VehicleMapAnnotation *)annotation;
        DTrackInfo *info = ann.dInfo;
        
        VehicleAnnotationView *vehicleView = (VehicleAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"vehicle"];
        
        if (nil == vehicleView)
        {
            vehicleView = [[VehicleAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:@"vehicle" image:[self getVehicleImage:info]];
        }
        vehicleView.dInfo = info;
        vehicleView.type = 2;
        
        _dicAnnView[info.trackId] = vehicleView;
        
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
    
    if (nil == cell)
    {
        cell = [TrackInfoCell cellFromNib];
    }
    
    DTrackInfo *info = _arrayTrack[indexPath.row];
    
    cell.lbTime.text = [NSString stringWithFormat:@"%ld分钟", info.arriveTime];
    cell.lbType.text = [self getVehicleName:info];
    
    cell.lbPlate.text = info.plateNum;
    cell.lbDriver.text = info.driverName;
    //cell.lbDistance.text = [NSString stringWithFormat:@"%.1lf公里", info.distance.floatValue];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTrackInfo *info = _arrayTrack[indexPath.row];
    VehicleAnnotationView *annView = _dicAnnView[info.trackId];
    
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
        
        DVehicleTrailController *controller = [weakSelf.storyboard
                                               instantiateViewControllerWithIdentifier:@"d_vehicle_trail_controller"];
        controller.cls = info.cls;
        controller.pumpType = info.vehicleType;
        
        controller.processId = info.trackId;
        controller.hzsLat = weakSelf.processInfo.hzs.lat;
        controller.hzsLng = weakSelf.processInfo.hzs.lng;
        
        controller.siteLat = weakSelf.processInfo.site.lat;
        controller.siteLng = weakSelf.processInfo.site.lng;
        
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    CLLocationCoordinate2D coor;
    coor.latitude = info.lat;
    coor.longitude = info.lng;
    [_mapView setCenterCoordinate:coor animated:YES];
}

@end
