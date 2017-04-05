//
//  TaskStatisticsHeadView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskStatisticsHeadView.h"

@interface TaskStatisticsHeadView()

@property (weak, nonatomic) IBOutlet UIButton *btnMonth;

@property (weak, nonatomic) IBOutlet UIButton *btnYear;

@property (weak, nonatomic) IBOutlet UIButton *btnCustom;

@end

@implementation TaskStatisticsHeadView


+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TaskStatisticsHeadView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnMonth.layer.masksToBounds = YES;
    _btnMonth.layer.cornerRadius = 12;
    _btnMonth.layer.borderWidth = 1;
    _btnMonth.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    [_btnMonth addTarget:self action:@selector(clickMonth) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnYear.layer.masksToBounds = YES;
    _btnYear.layer.cornerRadius = 12;
    _btnYear.layer.borderWidth = 1;
    _btnYear.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    [_btnYear addTarget:self action:@selector(clickYear) forControlEvents:UIControlEventTouchUpInside];
    
    _btnCustom.layer.masksToBounds = YES;
    _btnCustom.layer.cornerRadius = 12;
    _btnCustom.layer.borderWidth = 1;
    _btnCustom.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    [_btnCustom addTarget:self action:@selector(clickCustom) forControlEvents:UIControlEventTouchUpInside];

}


- (void)clickMonth
{
    _btnMonth.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnYear.backgroundColor = [UIColor clearColor];
    [_btnYear setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnCustom.backgroundColor = [UIColor clearColor];
    [_btnCustom setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickMonth)])
    {
        [_delegate onClickMonth];
    }
}


- (void)clickYear
{
    _btnYear.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnYear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnMonth.backgroundColor = [UIColor clearColor];
    [_btnMonth setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnCustom.backgroundColor = [UIColor clearColor];
    [_btnCustom setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickYear)])
    {
        [_delegate onClickMonth];
    }
}


- (void)clickCustom
{
    _btnCustom.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnCustom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnMonth.backgroundColor = [UIColor clearColor];
    [_btnMonth setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnYear.backgroundColor = [UIColor clearColor];
    [_btnYear setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickCustom)])
    {
        [_delegate onClickCustom];
    }

}

@end
