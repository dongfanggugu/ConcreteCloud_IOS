//
//  ACarryCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/30.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ACarryCell.h"

@interface ACarryCell ()
{
    void (^_onClickExam)();
    void (^_onClickSpot)();
}


@property (weak, nonatomic) IBOutlet UIButton *btnExam;

@property (weak, nonatomic) IBOutlet UIButton *btnSpot;

@end

@implementation ACarryCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ACarryCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 110;
}

+ (NSString *)identifier
{
    return @"a_carry_cell";
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnExam.hidden = YES;
    
    _btnSpot.hidden = YES;
    
    _btnExam.layer.masksToBounds = YES;
    
    _btnExam.layer.cornerRadius = 5;
    
    _btnSpot.layer.masksToBounds = YES;
    
    _btnSpot.layer.cornerRadius = 5;
}

- (void)setOnClickExamVideoListener:(void(^)())onClick
{
    _btnExam.hidden = NO;
    
    _onClickExam = onClick;
    
    [_btnExam addTarget:self action:@selector(onClickExam) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOnClickSpotVideoListener:(void(^)())onClick
{
    _btnSpot.hidden = NO;
    
    _onClickSpot = onClick;
    
    [_btnSpot addTarget:self action:@selector(onClickSpot) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickExam
{
    if (_onClickExam)
    {
        _onClickExam();
    }
}

- (void)onClickSpot
{
    if (_onClickSpot)
    {
        _onClickSpot();
    }
}

@end
