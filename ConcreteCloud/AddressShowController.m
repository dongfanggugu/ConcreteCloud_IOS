//
//  AddressShowController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AddressShowController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "AddressModifyController.h"

@interface AddressShowController () <BMKMapViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) UILabel *lbAddress;

@end

@implementation AddressShowController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"位置信息"];
    [self initRightNav];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_lbAddress) {
        _lbAddress.text = [[Config shareConfig] getBranchAddress];
    }
    
    [self markAddress];
}
- (void)initRightNav
{
    NSString *role = [[Config shareConfig] getRole];
    
    if ([role isEqualToString:SUP_ADMIN]) {
        [self initNavRightWithText:@"修改"];
    }
}

- (void)onClickNavRight
{
    AddressModifyController *controller = [[AddressModifyController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initView
{
    _lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, 40)];
    _lbAddress.textAlignment = NSTextAlignmentCenter;
    
    _lbAddress.font = [UIFont systemFontOfSize:14];
    
    
    [self.view addSubview:_lbAddress];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 134, self.screenWidth, self.screenHeight - 134)];
    
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 13;
    
    [self.view addSubview:_mapView];
    
    [self markAddress];
}

- (void)markAddress
{
    if (!_mapView) {
        return;
    }
    [_mapView removeAnnotations:_mapView.annotations];
    CLLocationCoordinate2D coor;
    coor.latitude = [[Config shareConfig] getLat];
    coor.longitude = [[Config shareConfig] getLng];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    
    _mapView.centerCoordinate = coor;
    
    annotation.coordinate = coor;
    
    annotation.title = [[Config shareConfig] getBranchName];
    
    [_mapView addAnnotation:annotation];
}

#pragma mark -- BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"marker"];
        
        if (nil == annotationView)
        {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"marker"];
        }
        
        
        [annotationView setBounds:CGRectMake(0, 0, 20, 20)];
        [annotationView setBackgroundColor:[UIColor clearColor]];
        
        annotationView.image = [UIImage imageNamed:@"marker_current_location"];
        
        
        return annotationView;
    }
    
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




@end
