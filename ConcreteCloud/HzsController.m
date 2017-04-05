//
//  HzsController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsController.h"
#import "HzsInfo.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HzsListRequest.h"
#import "HzsListResponse.h"
#import "HzsMapAnnotation.h"
#import "HzsAnnotationView.h"
#import "SOrderAddController.h"
#import "SiteAOrderOverViewController.h"


#pragma mark - HzsInfoCell

@interface HzsInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbHzsName;

@end

@implementation HzsInfoCell



@end


#pragma mark - HzsController

@interface HzsController()<BMKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    HzsAnnotationView *_curAnnotationView;
    
    NSMutableDictionary<NSString *, HzsAnnotationView *> *_dicAnnView;
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<HzsInfo *> *arrayHzs;

@end

@implementation HzsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"搅拌站"];
    [self initNaviLeftWithText:@"订单概览"];
    [self initData];
    [self initView];
    [self getAuthHzs];
}

- (void)onClickNaviLeft
{
    SiteAOrderOverViewController *controller = [[SiteAOrderOverViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)initView
{
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    _mapView.zoomEnabled = YES;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)initData
{
    _arrayHzs = [NSMutableArray array];
    
    _dicAnnView = [NSMutableDictionary dictionary];
}

#pragma mark - Network Request

- (void)getAuthHzs
{
    __weak typeof(self) weakSelf = self;
    HzsListRequest *request = [[HzsListRequest alloc] init];
    request.siteId = [[Config shareConfig] getBranchId];
    [[HttpClient shareClient] view:self.view post:URL_HZS_AUTH parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        HzsListResponse *response = [[HzsListResponse alloc] initWithDictionary:responseObject];
        NSArray<HzsInfo *> *array = [response getHzsList];
        
        for (HzsInfo *info in array)
        {
            info.authorization = YES;
        }
        
        [weakSelf.arrayHzs addObjectsFromArray:array];
        [weakSelf getUnAuthHzs];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getUnAuthHzs
{
    __weak typeof(self) weakSelf = self;
    HzsListRequest *request = [[HzsListRequest alloc] init];
    request.siteId = [[Config shareConfig] getBranchId];
    [[HttpClient shareClient] view:self.view post:URL_HZS_UNAUTH parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        HzsListResponse *response = [[HzsListResponse alloc] initWithDictionary:responseObject];
        NSArray<HzsInfo *> *array = [response getHzsList];
        
        for (HzsInfo *info in array)
        {
            info.authorization = NO;
        }
        [weakSelf.arrayHzs addObjectsFromArray:array];
        [weakSelf markHzs];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];

}

#pragma mark - mark on the map

- (void)markHzs
{
    for (HzsInfo *info in _arrayHzs)
    {
        HzsMapAnnotation *ann = [[HzsMapAnnotation alloc] init];
        ann.lat = info.lat;
        ann.lng = info.lng;
        
        ann.info = info;
        
        [_mapView addAnnotation:ann];
    }
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    HzsMapAnnotation *ann = (HzsMapAnnotation *)annotation;
    
    HzsAnnotationView *annView = (HzsAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"hzs"];
    
    if (!annView)
    {
        annView = [[HzsAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hzs"];
    }
    
    annView.info = ann.info;
    
    _dicAnnView[ann.info.hzsId] = annView;
    
    return annView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    HzsAnnotationView *annView = (HzsAnnotationView *)view;
//    if (!_curAnnotationView)
//    {
//        [annView showInfoWindow];
//        _curAnnotationView = annView;
//    }
//    else if (_curAnnotationView == annView)
//    {
//        return;
//    }
//    else if (_curAnnotationView != annView)
//    {
//        [_curAnnotationView hideInfoWindow];
//        [annView showInfoWindow];
//        _curAnnotationView = annView;
//    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    if (_curAnnotationView)
    {
        [_curAnnotationView hideInfoWindow];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayHzs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HzsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hzs_info_cell"];
    
    HzsInfo *info = _arrayHzs[indexPath.row];
    cell.lbHzsName.text = info.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HzsInfo *info = _arrayHzs[indexPath.row];
    HzsAnnotationView *annView = _dicAnnView[info.hzsId];
    
    if (!_curAnnotationView)
    {
        [annView showInfoWindow];
        _curAnnotationView = annView;
    }
    else if (_curAnnotationView == annView)
    {
        return;
    }
    else if (_curAnnotationView != annView)
    {
        [_curAnnotationView hideInfoWindow];
        [annView showInfoWindow];
        _curAnnotationView = annView;
    }
    
    __weak typeof(self) weakSelf = self;
    [_curAnnotationView addOnBtnClickListenner:^{
        
        BOOL auth = info.authorization;
        
        if (auth)
        {
            SOrderAddController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"s_order_add_controller"];
            controller.hzsInfo = info;
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", info.tel]];
            
            UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            [weakSelf.view addSubview:phoneCallWebView];
        }
    }];
    
    CLLocationCoordinate2D coor;
    coor.latitude = info.lat;
    coor.longitude = info.lng;
    
    [_mapView setCenterCoordinate:coor];
}

@end
