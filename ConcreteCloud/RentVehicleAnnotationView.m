//
//  RentVehicleAnnotationView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleAnnotationView.h"

@interface RentVehicleAnnotationView()

//1:罐车  2:汽车泵  3:车载泵、拖式泵
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) GcInfoView *gcinfoView;

@property (strong, nonatomic) QCBInfoView *qcbInfoView;

@property (strong, nonatomic) CZBInfoView *czbInfoView;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation RentVehicleAnnotationView

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

- (void)setInfo:(RentVehicleInfo *)info
{
    _info = info;
    
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        _type = 1;
    }
    else if (3 == type)
    {
        NSInteger gcType = [info.additionalInfo.type integerValue];
        
        if (1 == gcType)
        {
            _type = 2;
        }
        else if (2 == gcType)
        {
            _type = 3;
        }
        else if (3 == gcType)
        {
            _type = 3;
        }
        else
        {
            _type = 2;
        }
    }
}

- (void)showInfoWindow
{
    if (1 == _type)
    {
        _gcinfoView = [GcInfoView viewFromNib];
        
        CGFloat width = _gcinfoView.frame.size.width;
        
        CGFloat height = _gcinfoView.frame.size.height;
        
        _gcinfoView.frame = CGRectMake(- width / 2 + 10, - height + 10, width, height);
        
        _gcinfoView.lbWeight.text = [NSString stringWithFormat:@"%.1lf吨", _info.selfNet];
        _gcinfoView.lbLoad.text = [NSString stringWithFormat:@"%.1lf立方米", _info.weight];
        _gcinfoView.lbRenter.text = _info.leaseName;
        _gcinfoView.lbCharity.text = _info.contactsUser;
        _gcinfoView.lbCharityTel.text = _info.contactsUser;
        _gcinfoView.lbDrvierTel.text = _info.driverTel;
        
        [self addSubview:_gcinfoView];
        
    }
    else if (2 == _type)
    {
        _qcbInfoView = [QCBInfoView viewFromNib];
        
        CGFloat width = _qcbInfoView.frame.size.width;
        
        CGFloat height = _qcbInfoView.frame.size.height;
        
        _qcbInfoView.frame = CGRectMake(width / 2 + 10, -height + 20, width, height);
        
        _qcbInfoView.lbWeight.text = [NSString stringWithFormat:@"%.1lf吨", _info.selfNet];
        _qcbInfoView.lbArm.text = [NSString stringWithFormat:@"%.1lf米", _info.additionalInfo.armLength];
        _qcbInfoView.lbRenter.text = _info.leaseName;
        _qcbInfoView.lbCharity.text = _info.contactsUser;
        _qcbInfoView.lbCharityTel.text = _info.contactsUser;
        _qcbInfoView.lbDrvierTel.text = _info.driverTel;
        [self addSubview:_qcbInfoView];
    }
    else if (3 == _type)
    {
        _czbInfoView = [CZBInfoView viewFromNib];
        
        
        CGFloat width = _czbInfoView.frame.size.width;
        
        CGFloat height = _czbInfoView.frame.size.height;
        
        _czbInfoView.frame = CGRectMake(width / 2 + 10, -height + 20, width, height);
        
        _czbInfoView.lbWeight.text = [NSString stringWithFormat:@"%.1lf吨", _info.selfNet];
        _czbInfoView.lbAbility.text = [NSString stringWithFormat:@"%.1lf立方米/时", _info.additionalInfo.flow];
        _czbInfoView.lbRenter.text = _info.leaseName;
        _czbInfoView.lbCharity.text = _info.contactsUser;
        _czbInfoView.lbCharityTel.text = _info.contactsUser;
        _czbInfoView.lbDrvierTel.text = _info.driverTel;
        
        [self addSubview:_czbInfoView];
    }
    
}

- (void)hideInfoWindow
{
    if (1 == _type)
    {
        if (_gcinfoView)
        {
            [_gcinfoView removeFromSuperview];
            _gcinfoView = nil;
        }
        
    }
    else if (2 == _type)
    {
        if (_qcbInfoView)
        {
            [_qcbInfoView removeFromSuperview];
            _qcbInfoView = nil;
        };
        
        
    }
    else if (3 == _type)
    {
        if (_czbInfoView)
        {
            [_czbInfoView removeFromSuperview];
            _czbInfoView = nil;
        };
    }

}

- (void)setOnClickTelListener:(void(^)())onClickTel
{
    if (1 == _type)
    {
        if (_gcinfoView)
        {
            [_gcinfoView addBtnClickListenner:onClickTel];
        }
    }
    else if (2 == _type)
    {
        if (_qcbInfoView)
        {
            [_qcbInfoView addBtnClickListenner:onClickTel];
        }
    }
    else if (3 == _type)
    {
        if (_czbInfoView)
        {
            [_czbInfoView addBtnClickListenner:onClickTel];
        }
    }
}

#pragma mark - 解决自定义view里面事件被mapview截断的问题

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    
    return hitView;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;
    
    BOOL isInside = CGRectContainsPoint(rect, point);
    
    if (!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            
            if (isInside)
            {
                return isInside;
            }
        }
    }
    
    return isInside;
}
@end
