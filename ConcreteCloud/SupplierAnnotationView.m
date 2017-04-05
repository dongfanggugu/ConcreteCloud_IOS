//
//  SupplierAnnotationView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "SupplierAnnotationView.h"
#import "RenterView.h"

@implementation SupplierAnnotationView
{
    RenterView *_renterView;
}

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
        
        _renterView.ivIcon.image = [UIImage imageNamed:@"icon_supplier"];
        
        [self addSubview:_renterView];
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    _renterView.lbRenter.backgroundColor = _color;
}

- (void)setInfo:(SupplierInfo *)info
{
    _info = info;
    
    _renterView.lbRenter.text = _info.name;
    
    CGRect frame = _renterView.frame;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    
    CGSize size = [_info.name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil]];
    
    NSLog(@"width:%.1lf", size.width);
    
    frame.size.width = size.width + 16;
    
    _renterView.frame = frame;
    
}

- (void)showInfoWindow
{
    if (_infoView)
    {
        [self hideInfoWindow];
    }
    _infoView = [SupplierInfoView viewFromNib];
    _infoView.lbSupplierName.text = _info.name;
    _infoView.lbContactUser.text = _info.contactsUser;
    _infoView.lbContactTel.text = _info.tel;
    _infoView.lbAddress.text = _info.address;
    
    CGFloat height = [_infoView viewHeight];
    CGFloat width = _infoView.frame.size.width;
    
    _infoView.frame = CGRectMake(- width / 2 + 10, - height + 20, width, height);
    
    [self addSubview:_infoView];
    
    //保证弹出框显示在最上层
    [[self superview] bringSubviewToFront:self];}

- (void)hideInfoWindow
{
    if (_infoView)
    {
        [_infoView removeFromSuperview];
        _infoView = nil;
    }
}



@end
