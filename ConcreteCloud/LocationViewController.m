//
//  LocationViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#import <Foundation/Foundation.h>
#import "LocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "Location.h"

#pragma mark -- AddressCell

@interface AddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end

@implementation AddressCell



@end

#pragma mark -- LocationViewController

@interface LocationViewController()<BMKMapViewDelegate, BMKPoiSearchDelegate, UITableViewDelegate,
                                    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *tipLable;

@property (strong, nonatomic) BMKPoiSearch *poiSearch;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) BMKPointAnnotation *annotation;

@property (strong, nonatomic) MBProgressHUD *progress;

@property (strong, nonatomic) BMKPinAnnotationView *annotationView;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"地址选择"];
    [self initNavRightWithText:@"确定"];
    
    [self initView];
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
    _mapView.delegate = self;
    
    [_mapView setZoomLevel:12];
    
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
        [HUDClass showHUDWithLabel:@"查询失败,请稍后再试!" view:self.view];
    }
}

#pragma mark -- BMKSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    [HUDClass hideLoadingHUD:_progress];
    _progress = nil;
    
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        _dataArray = poiResult.poiInfoList;
        [_tableView reloadData];
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self setSelection:0];
    }
    else
    {
        NSLog(@"error code:%ud", errorCode);
        [HUDClass showHUDWithLabel:@"查找失败,请退出再次进入!" view:self.view];
    }
}

- (void)submit
{
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseAddressLat:lng:)])
    {
        [_delegate onChooseAddressLat:_mapView.centerCoordinate.latitude lng:_mapView.centerCoordinate.longitude];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSelection:(NSInteger)index
{
    if (_tipLable.hidden)
    {
        _tipLable.hidden = NO;
    }
    
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
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address_cell"];
    
    BMKPoiInfo *info = _dataArray[indexPath.row];
    
    cell.addLabel.text = info.address;
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
