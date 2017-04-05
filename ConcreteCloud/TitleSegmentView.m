//
//  TitleSegmentView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/6.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleSegmentView.h"


@interface TitleSegmentView()

@property NSInteger curSel;

@property (weak, nonatomic) IBOutlet UIButton *btnLeft;

@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@end

@implementation TitleSegmentView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TitleSegmentView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _curSel = 0;
    [self updateView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 18;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_btnLeft addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
}

/**
 点击左侧标签
 **/
- (void)onClickLeft
{
    if (_delegate)
    {
        [_delegate onClickLeft];
        _curSel = 0;
        [self updateView];
    }
}

/**
 点击右侧标签
 **/
- (void)onClickRight
{
    if (_delegate)
    {
        [_delegate onClickRight];
        _curSel = 1;
        [self updateView];
    }
}

- (void)updateView
{
    if (0 == _curSel)
    {
        
        [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[Utils getColorByRGB:COLOR_SEGMENT_UNSEL] forState:UIControlStateNormal];
    }
    else if (1 == _curSel)
    {
        [_btnLeft setTitleColor:[Utils getColorByRGB:COLOR_SEGMENT_UNSEL] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (void)setTitleOfLeft:(NSString *)left right:(NSString *)right
{
    [_btnLeft setTitle:left forState:UIControlStateNormal];
    [_btnRight setTitle:right forState:UIControlStateNormal];
}
@end
