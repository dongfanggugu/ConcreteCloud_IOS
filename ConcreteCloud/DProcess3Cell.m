//
//  DProcess3Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DProcess3Cell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ProjectInfo.h"
#import "HzsInfo.h"
#import "DProcessList.h"
#import "DTrackInfo.h"


@interface DProcess3Cell()<BMKMapViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewLeft;

@property (weak, nonatomic) IBOutlet UIView *viewRight;



@property (weak, nonatomic) IBOutlet UIView *viewComplete;

@property (weak, nonatomic) IBOutlet UILabel *lbWay;

@property (weak, nonatomic) IBOutlet UILabel *lbProcess;

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIButton *btnCarry;

@property (weak, nonatomic) IBOutlet UIImageView *ivVehicle;

@end

@implementation DProcess3Cell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DProcess3Cell" owner:nil options:nil];
    
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

+ (CGFloat)cellHeightSite
{
    return 300;
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
    
    _btnCarry.layer.masksToBounds = YES;
    _btnCarry.layer.cornerRadius = 5;
    
    _btnDetail.userInteractionEnabled = YES;
    [_btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCarry.userInteractionEnabled = YES;
    [_btnCarry addTarget:self action:@selector(clickCarry) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)clickCarry
{
    if (_delegate)
    {
        [_delegate onClickCarry];
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
    _btnCarry.hidden = YES;
}

- (void)setSiteRole
{
    _btnCarry.hidden = YES;
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
     _btnCarry.hidden = NO;
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbWay.hidden = NO;
    _lbProcess.hidden = NO;
    _btnDetail.hidden = NO;
     _btnCarry.hidden = YES;
}

- (void)setTotal:(CGFloat)total complete:(CGFloat)complete way:(CGFloat)way
{
    
    if (complete > 0)
    {
        _ivVehicle.image = [UIImage imageNamed:@"icon_tanker_trace"];
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
    
    CGFloat w1 = _viewTotal.frame.size.width;
    CGFloat w2 = viewComplete.frame.size.width;

}

- (UIImage *)getVehicleImage:(NSString *)cls_pump
{
    NSArray *array = [cls_pump componentsSeparatedByString:@"|"];
    
    
    NSInteger type = [array[0] integerValue];
    
    if (1 == type || 2 == type)
    {
        return [UIImage imageNamed:@"icon_tanker_trace"];
    }
    else if (3 == type)
    {
        if (array.count <2)
        {
            return [UIImage imageNamed:@"icon_pump"];
        }
        
        NSInteger bcType = [array[1] integerValue];
        
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


#pragma mark - marker on the map
/**
 在地图上标记
 **/
- (void)markOnMap:(DProcessList *)process
{
    [self markProject:process.site];
    [self markHzs:process.hzs];
    [self markVehicles:process.process];
}

- (void)markProject:(ProjectInfo *)projectInfo
{
    CGFloat lat = projectInfo.lat;
    CGFloat lng = projectInfo.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    marker.title = @"project";
    [_mapView addAnnotation:marker];
}

- (void)markHzs:(HzsInfo *)hzsInfo
{
    CGFloat lat = hzsInfo.lat;
    CGFloat lng = hzsInfo.lng;
    
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    
    BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
    marker.coordinate = coor;
    
    marker.title = @"hzs";
    [_mapView addAnnotation:marker];
    [_mapView setCenterCoordinate:coor];
}

- (void)markVehicles:(NSArray<DTrackInfo *> *)vehicles
{
    for (DTrackInfo *info in vehicles)
    {
        CLLocationCoordinate2D coor;
        coor.latitude = info.lat;
        coor.longitude = info.lng;
        
        BMKPointAnnotation *marker = [[BMKPointAnnotation alloc] init];
        
        marker.coordinate = coor;
        marker.title = @"vehicle";
        marker.subtitle = [NSString stringWithFormat:@"%@|%@", info.cls, info.vehicleType];
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
    
    if ([title isEqualToString:@"project"])
    {
        BMKAnnotationView *supplierView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"project"];
        supplierView.image = [UIImage imageNamed:@"icon_build_site"];
        
        supplierView.canShowCallout = NO;
        return supplierView;
    }
    else if ([title isEqualToString:@"hzs"])
    {
        BMKAnnotationView *siteView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"site"];
        siteView.image = [UIImage imageNamed:@"icon_mix_point"];
        
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

- (void)setCarryHiden:(BOOL)hiden
{
    _btnCarry.hidden = hiden;
}

@end
