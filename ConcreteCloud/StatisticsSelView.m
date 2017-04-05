//
//  StatisticsSelView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticsSelView.h"

@interface StatisticsSelView()

@property (weak, nonatomic) IBOutlet UIButton *btnYesterday;

@property (weak, nonatomic) IBOutlet UIButton *btnMonth;

@property (weak, nonatomic) IBOutlet UIButton *btnYear;

@end

@implementation StatisticsSelView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"StatisticsSelView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnAgent.layer.masksToBounds = YES;
    _btnAgent.layer.cornerRadius = 12;
    _btnAgent.layer.borderWidth = 1;
    _btnAgent.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnYesterday.layer.masksToBounds = YES;
    _btnYesterday.layer.cornerRadius = 12;
    _btnYesterday.layer.borderWidth = 1;
    _btnYesterday.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnMonth.layer.masksToBounds = YES;
    _btnMonth.layer.cornerRadius = 12;
    _btnMonth.layer.borderWidth = 1;
    _btnMonth.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnYear.layer.masksToBounds = YES;
    _btnYear.layer.cornerRadius = 12;
    _btnYear.layer.borderWidth = 1;
    _btnYear.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    [_btnAgent addTarget:self action:@selector(agent) forControlEvents:UIControlEventTouchUpInside];
    [_btnYesterday addTarget:self action:@selector(yesterday) forControlEvents:UIControlEventTouchUpInside];
    [_btnMonth addTarget:self action:@selector(month) forControlEvents:UIControlEventTouchUpInside];
    [_btnYear addTarget:self action:@selector(year) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initBtn
{
    _btnYesterday.backgroundColor = [UIColor clearColor];
    [_btnYesterday setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnMonth.backgroundColor = [UIColor clearColor];
    [_btnMonth setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnYear.backgroundColor = [UIColor clearColor];
    [_btnYear setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
}

- (void)agent
{
    _btnYesterday.backgroundColor = [UIColor clearColor];
    [_btnYesterday setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnMonth.backgroundColor = [UIColor clearColor];
    [_btnMonth setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnYear.backgroundColor = [UIColor clearColor];
    [_btnYear setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickAgent)])
    {
        [_delegate onClickAgent];
    }
}

- (void)yesterday
{
    _btnYesterday.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnYesterday setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    _btnMonth.backgroundColor = [UIColor clearColor];
    [_btnMonth setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnYear.backgroundColor = [UIColor clearColor];
    [_btnYear setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickYesterday)])
    {
        [_delegate onClickYesterday];
    }
}

- (void)month
{
    _btnMonth.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnYesterday.backgroundColor = [UIColor clearColor];
    [_btnYesterday setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnYear.backgroundColor = [UIColor clearColor];
    [_btnYear setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickMonth)])
    {
        [_delegate onClickMonth];
    }
}

- (void)year
{
    _btnYear.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    [_btnYear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    _btnYesterday.backgroundColor = [UIColor clearColor];
    [_btnYesterday setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    _btnMonth.backgroundColor = [UIColor clearColor];
    [_btnMonth setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickYear)])
    {
        [_delegate onClickYear];
    }
}

@end
