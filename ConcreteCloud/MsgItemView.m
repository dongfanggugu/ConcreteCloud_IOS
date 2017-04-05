//
//  MsgItemView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgItemView.h"

@interface MsgItemView()

@property CGFloat preWidth;

@end

@implementation MsgItemView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MsgItemView" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _preWidth = 320;
}

+ (NSString *)getIdentifier
{
    return @"msg_cell";
}


- (void)layoutSubviews
{
    [super layoutSubviews];    
    CGFloat viewWidth = self.contentView.frame.size.width;
    CGFloat offset = viewWidth - _preWidth;
    
    _preWidth = viewWidth;
    
    
    NSArray<UIView *> *array = [self.contentView subviews];
    
    for (UIView *view in array)
    {
        CGRect frame = view.frame;
        frame.size.width = frame.size.width + offset;
        view.frame = frame;
    }
}

@end