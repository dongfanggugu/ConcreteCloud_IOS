//
//  RoutePlanController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RoutePlanController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Map/BMKPolylineView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "UIImage+Rotate.h"
#import "CustomLocation.h"


#define x_pi (3.14159265358979324 * 3000.0 / 180.0)

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

/** 路线的标注*/
@interface RouteAnnotation : BMKPointAnnotation

@property (nonatomic) int type;

@property (nonatomic) int degree;

@end

@implementation RouteAnnotation

@end

@interface RoutePlanController () <BMKMapViewDelegate, BMKRouteSearchDelegate>

@property (strong, nonatomic) BMKMapView *mapView;

@property (strong, nonatomic) NSTimer *locationTimer;

@property (strong, nonatomic) CustomLocation *customLocation;

@end

@implementation RoutePlanController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"路径规划"];
    [self initView];
    [self startLocation];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Custom_Location_Complete object:nil];
    if (_locationTimer) {
        [_locationTimer invalidate];
        _locationTimer = nil;
    }
}

- (void)startLocation
{
    if (!_customLocation) {
        _customLocation = [[CustomLocation alloc] init];
    }
    
    __weak typeof (self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(onLocationComplete:) name:Custom_Location_Complete object:nil];
    
    [_customLocation startLocationService];
    
    if (!_locationTimer) {
        _locationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 * 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf.customLocation startLocationService];
        }];
    }
}

- (void)onLocationComplete:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo) {
        NSLog(@"定位失败");
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    _start = userLocation.location.coordinate;
    
    [self routePlan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

- (void)routePlan
{
    BMKRouteSearch *routeSearch = [[BMKRouteSearch alloc] init];
    routeSearch.delegate = self;
    
    BMKDrivingRoutePlanOption *options = [[BMKDrivingRoutePlanOption alloc] init];
    
    options.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    
    start.pt = _start;
    
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
  
    end.pt = _destination;
    
    options.from = start;
    options.to = end;
    
    BOOL suc = [routeSearch drivingSearch:options];
    
    if (suc) {
        NSLog(@"路线查找成功");
    }
    
}

#pragma mark - BMKRouteSearchDelegate

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    searcher.delegate = nil;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView removeAnnotations:_mapView.annotations];

        //表示一条驾车路线
        BMKDrivingRouteLine *plan = (BMKDrivingRouteLine *)[result.routes objectAtIndex:0];
        
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        
        int planPointCounts = 0;
        
        for (int i = 0; i < size; i++) {
            //表示驾车路线中的一个路段
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            
            if(0 == i) {
                RouteAnnotation *item = [[RouteAnnotation alloc]init];
                
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            } else if (i == size - 1) {
                RouteAnnotation *item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加终点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode *tempNode in plan.wayPoints) {
                RouteAnnotation *item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint tempPoints[planPointCounts];
        
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep *transitStep = [plan.steps objectAtIndex:j];
            int k = 0;
            for(k = 0; k < transitStep.pointsCount; k++) {
                tempPoints[i].x = transitStep.points[k].x;
                tempPoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:tempPoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        
        [self mapViewFitPolyLine:polyLine];
        
    } else {
        NSLog(@"error code:%u", error);
    }
}

#pragma mark 根据overlay生成对应的View
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}


#pragma mark  根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *)polyLine
{
    CGFloat ltX, ltY, rbX, rbY;
    
    if (polyLine.pointCount < 1) {
        return;
    }
    
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    
    for (int i = 0; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    
    rect.origin = BMKMapPointMake(ltX , ltY);
    
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    
    [_mapView setVisibleMapRect:rect];
    
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


#pragma mark - 显示大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if (![annotation isKindOfClass:[RouteAnnotation class]]) return nil;
    return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation *)annotation];
}

#pragma mark 获取路线的标注，显示到地图
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation {
    
    BMKAnnotationView *view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = true;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = true;
            }
            view.annotation =routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = true;
            } else {
                [view setNeedsDisplay];
            }
            UIImage *image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    return view;
}

- (NSString*)getMyBundlePath1:(NSString *)filename {
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ) {
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent:filename];
        return s;
    }
    return nil ;
}

@end
