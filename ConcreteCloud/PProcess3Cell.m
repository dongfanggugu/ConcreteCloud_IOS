//
//  PProcess3Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PProcess3Cell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SupplierInfo.h"
#import "HzsInfo.h"
#import "PProcessList.h"


@interface PProcess3Cell()<BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewLeft;

@property (weak, nonatomic) IBOutlet UIView *viewRight;



@property (weak, nonatomic) IBOutlet UIView *viewComplete;

@property (weak, nonatomic) IBOutlet UILabel *lbWay;

@property (weak, nonatomic) IBOutlet UILabel *lbProcess;

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIImageView *ivVehicle;

@property (strong, nonatomic) UIImage *vehicleRelax;

@property (strong, nonatomic) UIImage *vehicleBusy;

@end

@implementation PProcess3Cell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PProcess3Cell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 380;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _viewLeft.layer.masksToBounds = YES;
    _viewLeft.layer.cornerRadius = 5;
    
    _viewRight.layer.masksToBounds = YES;
    _viewRight.layer.cornerRadius = 5;
    
    _btnDetail.layer.masksToBounds = YES;
    _btnDetail.layer.cornerRadius = 5;
    
    _btnDetail.userInteractionEnabled = YES;
    [_btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
    
    _mapView.userInteractionEnabled = YES;
    [_mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMap)]];
    
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
}

- (void)onClickMap
{
    if (_delegate)
    {
        [_delegate onClickMap];
    }
}

- (void)clickDetail
{
    if (_delegate)
    {
        [_delegate onClickDetail];
    }
}

- (void)setFutureMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_future"];
    _lbTitle.textColor = [UIColor grayColor];
    _lbDate.hidden = YES;
    _lbWay.hidden = YES;
    _lbProcess.hidden = YES;
    _btnDetail.hidden = YES;
}

- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbWay.hidden = NO;
    _lbProcess.hidden = NO;
    _btnDetail.hidden = NO;
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbWay.hidden = NO;
    _lbProcess.hidden = NO;
    _btnDetail.hidden = NO;
}

- (void)setTotal:(CGFloat)total complete:(CGFloat)complete way:(CGFloat)way
{
    
    //设置车图片
    if (way > 0) {
        _ivVehicle.image = _vehicleBusy;
        
    } else {
        _ivVehicle.image = _vehicleRelax;
    }
    
    
    _lbWay.text = [NSString stringWithFormat:@"%.2lf", way];
    
    NSString *process = [NSString stringWithFormat:@"%.2lf/%.2lf", complete, total];
    
    _lbProcess.text = process;
    
    if (total <= 0)
    {
        return;
    }
    
    CGFloat scale = complete / total;
    
    if (scale > 1)
    {
        scale = 1;
    }
    
    for (UIView *view in [_viewTotal subviews])
    {
        [view removeFromSuperview];
    }
    //CGFloat w = _viewTotal.frame.size.width;
    CGFloat width = _viewTotal.frame.size.width * scale;
    CGFloat height = _viewTotal.frame.size.height;
    
    CGRect frame = CGRectMake(0, 0, width, height);
    
    UIView *viewComplete = [[UIView alloc] initWithFrame:frame];
    viewComplete.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_viewTotal addSubview:viewComplete];
}

- (UIImage *)getVehicleImage:(NSString *)cls
{
    NSInteger type = [cls integerValue];
    
    if (4 == type)
    {
        return [UIImage imageNamed:@"icon_car_type4"];
    }
    else if (5 == type)
    {
        return [UIImage imageNamed:@"icon_car_type5"];
    }
    else if (6 == type)
    {
        return [UIImage imageNamed:@"icon_car_type6"];
    }
    
    return nil;
}


#pragma mark - marker on the map
/**
 在地图上标记
 **/
- (void)markOnMap:(PProcessList *)process
{
    [self markSupplier:process.supplier];
    [self markSite:process.hzs];
    [self markVehicles:process.info];
}

- (void)markSupplier:(SupplierInfo *)supplierInfo
{
    CGFloat lat = supplierInfo.lat;
    CGFloat lng = supplierInfo.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    marker.title = @"supplier";
    [_mapView addAnnotation:marker];
}

- (void)markSite:(HzsInfo *)hzsInfo
{
    CGFloat lat = hzsInfo.lat;
    CGFloat lng = hzsInfo.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"site";
    [_mapView addAnnotation:marker];
    [_mapView setCenterCoordinate:coor];
}

- (void)markVehicles:(NSArray<PTrackInfo *> *)vehicles
{
    for (PTrackInfo *info in vehicles)
    {
        CLLocationCoordinate2D coor;
        coor.latitude = info.lat;
        coor.longitude = info.lng;
        
        BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];

        marker.coordinate = coor;
        marker.title = @"vehicle";
        marker.subtitle = info.cls;
        [_mapView addAnnotation:marker];
    }
}


/**
 解决地图和tableview滑动冲突问题
 **/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    UITableView *tableView = nil;
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView *)nextResponder;
        }
    }
    
    if (tableView)
    {
        tableView.scrollEnabled = YES;
        
        if (hitView)
        {
            if (CGRectContainsPoint(_mapView.frame, point))
            {
                tableView.scrollEnabled = NO;
            }
        }
    }
    
    return hitView;
}


#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *title = annotation.title;
    
    if ([title isEqualToString:@"supplier"])
    {
        BMKAnnotationView *supplierView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        supplierView.image = [UIImage imageNamed:@"icon_supplier"];
        
        supplierView.canShowCallout = NO;
        return supplierView;
    }
    else if ([title isEqualToString:@"site"])
    {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"supplier"];
        siteView.image = [UIImage imageNamed:@"icon_build_site"];
        
        siteView.canShowCallout = NO;
        return siteView;
    }
    else if ([title isEqualToString:@"vehicle"])
    {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"vehicle"];
        siteView.image = [self getVehicleImage:annotation.subtitle];
        
        siteView.canShowCallout = NO;
        return siteView;
    }
    
    return nil;
}

- (void)setSupplierMode
{
    _btnDetail.hidden = YES;
}

- (void)setGoodsName:(NSString *)goodsName
{
    if ([goodsName isEqualToString:SHAZI]
        || [goodsName isEqualToString:SHIZI]
        || [goodsName isEqualToString:OTHERS]) {
        
        _vehicleRelax = [UIImage imageNamed:@"icon_car_gray"];
        
        _vehicleBusy = [UIImage imageNamed:@"icon_car_type4"];
        
    } else if ([goodsName isEqualToString:WAIJIAJI]) {
        _vehicleRelax = [UIImage imageNamed:@"icon_car_gray5"];
        _vehicleBusy = [UIImage imageNamed:@"icon_car_type5"];
        
    } else {
        _vehicleRelax = [UIImage imageNamed:@"icon_car_gray6"];
        _vehicleBusy = [UIImage imageNamed:@"icon_car_type6"];
    }
}

@end
