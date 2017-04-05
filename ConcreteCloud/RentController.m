//
//  RentController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RenterListResponse.h"
#import "RenterInfo.h"
#import "RentMapAnnotation.h"
#import "RentAnnotationView.h"
#import "RentInfoView.h"
#import "RentVehicleListResponse.h"
#import "RentVehicleMapAnnotation.h"
#import "RentVehicleAnnotationView.h"
#import "RentVehicleType.h"
#import "ListDialogView.h"

#pragma mark - RentVehicleCell

@interface RentVehicelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbType;

@property (weak, nonatomic) IBOutlet UILabel *lbDriver;

@property (weak, nonatomic) IBOutlet UILabel *lbDis;

@end

@implementation RentVehicelCell



@end

#pragma mark - RentController

@interface RentController()<BMKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, ListDialogViewDelegate>
{
    NSMutableArray<RenterInfo *> *_arrayRenter;
    
    NSMutableArray<RentVehicleInfo *> *_arrayVehicle;
    
    NSMutableArray<RentVehicleInfo *> *_arrayResult;
    
    NSMutableDictionary<NSString *, RentVehicleAnnotationView *> *_dicAnnView;
    
    RentAnnotationView *_renterView;
    
    RentVehicleAnnotationView *_vehicleView;
    
}

@property (weak,  nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lbChoose;

@end

@implementation RentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆租赁"];
    [self initNavRightWithText:@"刷新"];
    [self initData];
    [self initView];
    [self getRenter];
    [self getRentVehicles];
}


- (void)onClickNavRight
{
    [_arrayRenter removeAllObjects];
    [_arrayVehicle removeAllObjects];
    [_arrayResult removeAllObjects];
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_dicAnnView removeAllObjects];
    
    if (_renterView)
    {
        [_renterView hideInfoWindow];
    }
    
    if (_vehicleView)
    {
        [_vehicleView hideInfoWindow];
    }
    
    [self getRenter];
    [self getRentVehicles];
}
- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _lbChoose.text = @"全部";
    _lbChoose.userInteractionEnabled = YES;
    [_lbChoose addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vehicelFilter)]];
}

- (void)initData
{
    _arrayRenter = [NSMutableArray array];
    _arrayVehicle = [NSMutableArray array];
    _arrayResult = [NSMutableArray array];
    _dicAnnView = [NSMutableDictionary dictionary];
}

- (void)vehicelFilter
{
    NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
    RentVehicleType *type0 = [[RentVehicleType alloc] initWithKey:@"0" content:@"全部"];
    RentVehicleType *type1 = [[RentVehicleType alloc] initWithKey:@"1" content:@"罐车"];
    RentVehicleType *type2 = [[RentVehicleType alloc] initWithKey:@"2" content:@"汽车泵"];
    RentVehicleType *type3 = [[RentVehicleType alloc] initWithKey:@"3" content:@"车载泵"];
    RentVehicleType *type4 = [[RentVehicleType alloc] initWithKey:@"4" content:@"拖式泵"];
    
    [array addObject:type0];
    [array addObject:type1];
    [array addObject:type2];
    [array addObject:type3];
    [array addObject:type4];
    
    ListDialogView *dialog = [ListDialogView viewFromNib];
    dialog.delegate = self;
    [dialog setData:array];
    [self.view addSubview:dialog];
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    _lbChoose.text = content;
    
    NSInteger keyI = [key integerValue];
    
    [_arrayResult removeAllObjects];
    
    if (0 == keyI)
    {
        [_arrayResult addObjectsFromArray:_arrayVehicle];
    }
    else if (1 == keyI)
    {
        for (RentVehicleInfo *info in _arrayVehicle)
        {
            NSInteger type = [info.cls integerValue];
            
            if (1 == type || 2 == type)
            {
                [_arrayResult addObject:info];
            }
        }
    }
    else if (2 == keyI)
    {
        for (RentVehicleInfo *info in _arrayVehicle)
        {
            NSInteger type = [info.cls integerValue];
            
            if (3 == type)
            {
                NSInteger bcType = [info.additionalInfo.type integerValue];
                
                if (1 == bcType)
                {
                    [_arrayResult addObject:info];
                }
            }
        }
    }
    else if (3 == keyI)
    {
        for (RentVehicleInfo *info in _arrayVehicle)
        {
            NSInteger type = [info.cls integerValue];
            
            if (3 == type)
            {
                NSInteger bcType = [info.additionalInfo.type integerValue];
                
                if (2 == bcType)
                {
                    [_arrayResult addObject:info];
                }
            }
        }
    }
    else if (4 == keyI)
    {
        for (RentVehicleInfo *info in _arrayVehicle)
        {
            NSInteger type = [info.cls integerValue];
            
            if (3 == type)
            {
                NSInteger bcType = [info.additionalInfo.type integerValue];
                
                if (3 == bcType)
                {
                    [_arrayResult addObject:info];
                }
            }
        }
    }
    
    [_tableView reloadData];
}


#pragma mark - Network Request

- (void)getRenter
{
    [[HttpClient shareClient] view:self.view post:URL_GET_RENTER parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RenterListResponse *response = [[RenterListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayRenter addObjectsFromArray:[response getRenterList]];
        [self markRenter];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getRentVehicles
{
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] view:self.view post:URL_RENT_VIHICLES parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RentVehicleListResponse *response = [[RentVehicleListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayVehicle addObjectsFromArray:[response getRentVehicleList]];
        [_arrayResult addObjectsFromArray:[response getRentVehicleList]];
        [weakSelf.tableView reloadData];
        [weakSelf markVehicles];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - mark on the map

- (void)markRenter
{
    for (RenterInfo *info in _arrayRenter)
    {
        RentMapAnnotation *ann = [[RentMapAnnotation alloc] init];
        ann.lat = info.lat;
        ann.lng = info.lng;
        
        ann.info = info;
        ann.title = @"renter";
        [_mapView addAnnotation:ann];
    }
    
}

- (void)markVehicles
{
    for (RentVehicleInfo *info in _arrayVehicle)
    {
        RentVehicleMapAnnotation *ann = [[RentVehicleMapAnnotation alloc] init];
        ann.lat = info.lat;
        ann.lng = info.lng;
        
        ann.info = info;
        ann.title = @"vehicle";
        [_mapView addAnnotation:ann];
    }
}

- (UIImage *)getVehicleImage:(RentVehicleInfo *)info
{
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return [UIImage imageNamed:@"icon_tanker_trace"];
    }
    else if (3 == type)
    {
        NSInteger bcType = [info.additionalInfo.type integerValue];
        
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


- (NSString *)getVehicleName:(RentVehicleInfo *)info
{
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return @"混凝土运输车";
    }
    else if (3 == type)
    {
        NSInteger gcType = [info.additionalInfo.type integerValue];
        
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


#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"renter"])
    {
        RentMapAnnotation *rentAnn = (RentMapAnnotation *)annotation;
        RentAnnotationView *rentView = [[RentAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"renter"];
        rentView.info = rentAnn.info;
        
        [rentView setRenterName];
        
        rentView.canShowCallout = NO;
        
        return rentView;
    }
    else if ([title isEqualToString:@"vehicle"])
    {
        RentVehicleMapAnnotation *ann = (RentVehicleMapAnnotation *)annotation;
        
        
        RentVehicleAnnotationView *vehicleView = [[RentVehicleAnnotationView alloc] initWithAnnotation:annotation
                                                                                       reuseIdentifier:@"vehicle"
                                                                                                 image:[self getVehicleImage:ann.info]];
        
        vehicleView.info = ann.info;
        vehicleView.canShowCallout = NO;
        
        _dicAnnView[vehicleView.info.plateNum] = vehicleView;
        return vehicleView;
    }
    
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    RentAnnotationView *annView = (RentAnnotationView *)view;
    
    if (nil == _renterView)
    {
        [annView showInfoWindow];
        _renterView = annView;
        return;
    }
    
    if (_renterView != nil && _renterView == annView)
    {
        return;
    }
    
    if (_renterView != nil && _renterView != annView)
    {
        [_renterView hideInfoWindow];
        [annView showInfoWindow];
        _renterView = annView;
    }
    
}


- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (_renterView)
    {
        [_renterView hideInfoWindow];
        _renterView = nil;
    }
    
    if (_vehicleView)
    {
        [_vehicleView hideInfoWindow];
        _vehicleView = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentVehicelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rent_vehicle_cell"];
    
    RentVehicleInfo *info = _arrayResult[indexPath.row];
    if (cell)
    {
        cell.lbPlate.text = info.plateNum;
        cell.lbType.text = [self getVehicleName:info];
        cell.lbDriver.text = info.driverName;
        cell.lbDis.text = [NSString stringWithFormat:@"%.1lf米", info.distance];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentVehicleInfo *info = _arrayResult[indexPath.row];
    RentVehicleAnnotationView *annView = _dicAnnView[info.plateNum];
    
    if (nil == _vehicleView)
    {
        [annView showInfoWindow];
        _vehicleView = annView;
    }
    else if (annView == _vehicleView)
    {
        return;
    }
    else
    {
        [_vehicleView hideInfoWindow];
        [annView showInfoWindow];
        _vehicleView = annView;
    }
    
    
    [_vehicleView setOnClickTelListener:^{
        
    }];
    
    CLLocationCoordinate2D coor;
    coor.latitude = info.lat;
    coor.longitude = info.lng;
    [_mapView setCenterCoordinate:coor animated:YES];
}

@end
