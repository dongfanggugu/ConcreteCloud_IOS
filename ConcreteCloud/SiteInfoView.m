//
//  SiteInfoView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteInfoView.h"

@interface SiteInfoView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addHeight;

@end

@implementation SiteInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SiteInfoView" owner:nil options:nil];
    
    if ( 0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
}


- (CGFloat)viewHeight
{
    CGFloat height = self.frame.size.height;
    
    if (0 == _lbAddress.text.length)
    {
        return height;
    }
    
    
    CGFloat origin = _addHeight.constant;
    
    [_lbAddress sizeToFit];
    
    _addHeight.constant = _lbAddress.frame.size.height;
    
    CGFloat div = _addHeight.constant - origin;
    
    
    return height + div;    
}

@end