
//
//  ProjectDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDetailController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "ProjectView.h"
#import "AuthorizeRequest.h"
#import "UnAuthorizeRequest.h"

@interface ProjectDetailController()<BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *viewProject;

@end

@implementation ProjectDetailController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"工程详情"];
    
    if ([[Config shareConfig] getOperable]) {
        if (_isAuthed) {
            [self initNavRightWithText:@"解除授权"];
            
        } else {
            [self initNavRightWithText:@"授权"];
        }
    }
    
    [self initView];
}

- (void)onClickNavRight
{
    if (_isAuthed)
    {
        [self unAuthorize];
    }
    else
    {
        [self authorize];
    }
}

- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    _mapView.zoomEnabled = YES;
    
    ProjectView *infoView = [ProjectView viewFromNib];
    infoView.lbProject.text = _projectInfo.name;
    infoView.lbName.text = _projectInfo.contactsUser;
    infoView.lbTel.text = _projectInfo.tel;
    infoView.lbAddress.text = _projectInfo.address;
    

    CLLocationCoordinate2D coorHzs;
    coorHzs.latitude = [[Config shareConfig] getLat];
    coorHzs.longitude = [[Config shareConfig] getLng];
    
    BMKMapPoint hzs = BMKMapPointForCoordinate(coorHzs);
    
    CLLocationCoordinate2D coorPro;
    coorPro.latitude = _projectInfo.lat;
    coorPro.longitude = _projectInfo.lng;
    BMKMapPoint project = BMKMapPointForCoordinate(coorPro);
    
    CLLocationDistance distance = BMKMetersBetweenMapPoints(hzs, project);
    
    infoView.lbDistance.text = [NSString stringWithFormat:@"%.1lf公里", distance / 1000];
    
    [_viewProject addSubview:infoView];
    
    [self markHzs];
    [self markProject];
}

#pragma mark - Network Request

- (void)authorize
{
    AuthorizeRequest *request = [[AuthorizeRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.siteId = _projectInfo.projectId;
    request.userName = [[Config shareConfig] getName];
    
    [[HttpClient shareClient] view:self.view post:URL_AUTHORIZE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"授权成功!" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)unAuthorize
{
    UnAuthorizeRequest *request = [[UnAuthorizeRequest alloc] init];
    request.authId = _projectInfo.authId;
    
    [[HttpClient shareClient] view:self.view post:URL_UNAUTHORIZE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"解除授权成功!" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - mark on the map

- (void)markHzs
{
    CLLocationCoordinate2D coor;
    coor.latitude = [[Config shareConfig] getLat];
    coor.longitude = [[Config shareConfig] getLng];
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"hzs";
    [_mapView addAnnotation:marker];
    [_mapView setCenterCoordinate:coor];
}

- (void)markProject
{
    CLLocationCoordinate2D coor;
    coor.latitude = _projectInfo.lat;
    coor.longitude = _projectInfo.lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"project";
    [_mapView addAnnotation:marker];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"hzs"])
    {
        BMKAnnotationView *supplierView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        supplierView.image = [UIImage imageNamed:@"icon_mix_point"];
        
        supplierView.canShowCallout = NO;
        return supplierView;
    }
    else if ([title isEqualToString:@"project"])
    {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        siteView.image = [UIImage imageNamed:@"icon_build_site"];
        
        siteView.canShowCallout = NO;
        return siteView;
    }
    
    return nil;
}

@end
