//
//  RentAnnotationView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentAnnotationView.h"
#import "RenterView.h"

@interface RentAnnotationView()
{
    RenterView *_renterView;
}

@end

@implementation RentAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, 0);
        self.frame = CGRectMake(0, 0, 20, 20);
        _renterView = [RenterView viewFromNib];
        _renterView.center = self.center;
        [self addSubview:_renterView];
    }
    return self;
}

- (void)setRenterName
{
    _renterView.lbRenter.text = _info.name;
}

- (void)showInfoWindow
{
    if (_infoView)
    {
        [self hideInfoWindow];
    }
    _infoView = [RentInfoView viewFromNib];
    _infoView.backgroundColor = [UIColor clearColor];
    
    _infoView.frame = CGRectMake(-95, -140, 210, 150);
    [self addSubview:_infoView];
    
    _infoView.lbName.text = _info.name;
    _infoView.lbTel.text = _info.tel;
    _infoView.lbUser.text = _info.contactsUser;
    _infoView.lbAddress.text = _info.address;
    
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
