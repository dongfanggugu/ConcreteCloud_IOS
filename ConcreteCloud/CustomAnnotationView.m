//
//  CustomAnnotationView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (void)showInfoWindow
{
    NSLog(@"show info window");
}


- (void)hideInfoWindow
{
    NSLog(@"hide info window");
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
