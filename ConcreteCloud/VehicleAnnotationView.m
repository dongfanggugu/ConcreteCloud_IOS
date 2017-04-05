//
//  VehicleAnnotationView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleAnnotationView.h"
#import "RenterView.h"

@implementation VehicleAnnotationView
{
    RenterView *_renterView;
}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(UIImage *)image
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 0);
        self.frame = CGRectMake(0, 0, 20, 20);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageView.image = image;
        [self addSubview:imageView];
    }
    return self;
}


- (id)initWithAnnotationAndTag:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(UIImage *)image
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 0);
        self.frame = CGRectMake(0, 0, 20, 20);
        _renterView = [RenterView viewFromNib];
        _renterView.center = self.center;
        
        _renterView.ivIcon.image = image;
        
        [self addSubview:_renterView];
    }
    return self;
}

- (void)setDInfo:(DTrackInfo *)dInfo
{
    _dInfo = dInfo;
    
    if (_renterView)
    {
        _renterView.lbRenter.text = _dInfo.plateNum;
    
        CGRect frame = _renterView.frame;
        
        UIFont *font = [UIFont systemFontOfSize:13];
        
        CGSize size = [_dInfo.plateNum sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil]];
        
        frame.size.width = size.width + 16;
        
        _renterView.frame = frame;
    }
}

- (void)setInfo:(PTrackInfo *)info
{
    _info = info;
    
    if (_renterView)
    {
        _renterView.lbRenter.text = info.plateNum;
        
        CGRect frame = _renterView.frame;
        
        UIFont *font = [UIFont systemFontOfSize:13];
        
        CGSize size = [_dInfo.plateNum sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil]];
        
        frame.size.width = size.width + 16;
        
        _renterView.frame = frame;
    }
    
}


- (void)setColor:(UIColor *)color
{
    _color = color;
    
    if (_renterView)
    {
        _renterView.lbRenter.backgroundColor = _color;
    }
}


- (void)showInfoWindow
{
    if (_infoView)
    {
        [self hideInfoWindow];
    }
    _infoView = [VehicleInfoView viewFromNib];
    _infoView.backgroundColor = [UIColor clearColor];
    
    _infoView.frame = CGRectMake(-95, -140, 210, 150);
    [self addSubview:_infoView];
    
    if (_hideOperation)
    {
        _infoView.btnDetail.hidden = YES;
    }
    else
    {
        _infoView.btnDetail.hidden = NO;
    }
    
    
    if (Order_A == _type)
    {
        _infoView.lbPlate.text = _dInfo.plateNum;
        _infoView.lbDriver.text = _dInfo.driverName;
        _infoView.lbLoad.text = [NSString stringWithFormat:@"%ld吨", _dInfo.number];
        _infoView.lbTel.text = _dInfo.driverTel;
    }
    else
    {
        _infoView.lbPlate.text = _info.plateNum;
        _infoView.lbDriver.text = _info.driverName;
        _infoView.lbLoad.text = [NSString stringWithFormat:@"%.1lf吨", _info.loadWeight];
        _infoView.lbTel.text = _info.tel;
    }
    
    [[self superview] bringSubviewToFront:self];
    
}

- (void)hideInfoWindow
{
    if (_infoView)
    {
        [_infoView removeFromSuperview];
        _infoView = nil;
    }
}

#pragma mark - 解决自定义view里面事件被mapview截断的问题

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    
//    if (hitView != nil)
//    {
//        [self.superview bringSubviewToFront:self];
//    }
//    
//    return hitView;
//}
//
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGRect rect = self.bounds;
//    
//    BOOL isInside = CGRectContainsPoint(rect, point);
//    
//    if (!isInside)
//    {
//        for (UIView *view in self.subviews)
//        {
//            isInside = CGRectContainsPoint(view.frame, point);
//            
//            if (isInside)
//            {
//                return isInside;
//            }
//        }
//    }
//    
//    return isInside;
//}
@end
