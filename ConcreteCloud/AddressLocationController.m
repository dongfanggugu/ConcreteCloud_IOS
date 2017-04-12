//
//  AddressLocationController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AddressLocationController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "Location.h"

@interface AddressLocationController () <BMKMapViewDelegate, UITableViewDelegate, UITableViewDataSource,
                                            BMKPoiSearchDelegate>

@property (strong, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BMKPoiSearch *poiSearch;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) BMKPointAnnotation *annotation;

@property (strong, nonatomic) MBProgressHUD *progress;

@property (strong, nonatomic) BMKPinAnnotationView *annotationView;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@end

@implementation AddressLocationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"地址选择"];
    [self initNavRightWithText:@"确定"];
    [self initData];
    [self initView];
}

- (void)initData
{
    _dataArray = [NSMutableArray array];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:)
                                                 name:Location_Complete object:nil];
    [[Location sharedLocation] startLocationService];
    
    [self initPoiSearch];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Location_Complete object:nil];
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    
    [_mapView setZoomLevel:12];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, 40)];
    
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"拖动地图定位到地址位置";
    [self.view addSubview:label];
    
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    centerView.image = [UIImage imageNamed:@"icon_location_pin.png"];
    
    centerView.center = _mapView.center;
    
    [self.view addSubview:centerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.screenHeight - 120, self.screenWidth, 120)];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView.bounces = NO;
    
    _btnLocation.hidden = YES;
    [_btnLocation addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
}


- (void)location
{
    [[Location sharedLocation] startLocationService];
}

- (void)onLocationComplete:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo)
    {
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    annotation.coordinate = userLocation.location.coordinate;
    
    annotation.title = @"您的位置";
    
    [_mapView addAnnotation:annotation];
}


- (void)initPoiSearch
{
    _poiSearch = [[BMKPoiSearch alloc] init];
    
    _poiSearch.delegate = self;
    
    [self search];
}


- (void)onClickNavRight
{
    [self submit];
}
- (void)search
{
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 30;
    option.city = @"北京市";
    option.keyword = _address;
    
    _progress = [HUDClass showLoadingHUD:self.view];
    
    BOOL result = [_poiSearch poiSearchInCity:option];
    
    if (!result)
    {
        [HUDClass hideLoadingHUD:_progress];
        _progress = nil;
        [HUDClass showHUDWithText:@"查询失败,请稍后再试!"];
    }
}

#pragma mark -- BMKSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    [HUDClass hideLoadingHUD:_progress];
    _progress = nil;
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        [_dataArray removeAllObjects];
        
        [_dataArray addObjectsFromArray:poiResult.poiInfoList];
        
        if (0 == _dataArray.count) {
            _tableView.hidden = YES;
            
        } else {
            _tableView.hidden = NO;
            [_tableView reloadData];
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self setSelection:0];
        }
    }
    else
    {
        NSLog(@"error code:%ud", errorCode);
        [HUDClass showHUDWithText:@"查找失败,请退出再次进入!"];
    }
}

- (void)submit
{
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseAddressLat:lng:)]) {
        [_delegate onChooseAddressLat:_mapView.centerCoordinate.latitude lng:_mapView.centerCoordinate.longitude];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelection:(NSInteger)index
{
    
    BMKPoiInfo *info = _dataArray[index];
    
    _mapView.centerCoordinate = info.pt;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.screenWidth - 16, 44)];
        label.font = [UIFont systemFontOfSize:13];
        
        label.tag = 1001;
        
        [cell.contentView addSubview:label];

    }
    
    
    BMKPoiInfo *info = _dataArray[indexPath.row];
    
    UILabel *label = [cell.contentView viewWithTag:1001];
    
    label.text = info.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelection:indexPath.row];
    
}

#pragma mark -- BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        _annotationView = (BMKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"marker"];
        
        if (nil == _annotationView)
        {
            _annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"marker"];
        }
        
        
        [_annotationView setBounds:CGRectMake(0, 0, 20, 20)];
        [_annotationView setBackgroundColor:[UIColor clearColor]];
        
        _annotationView.image = [UIImage imageNamed:@"marker_current_location"];
        
        
        return _annotationView;
    }
    
    return nil;
}



@end
