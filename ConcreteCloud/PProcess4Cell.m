//
//  PProcess4Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PProcess4Cell.h"

@interface PProcess4Cell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;


@end


@implementation PProcess4Cell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PProcess4Cell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return 0;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 75;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btnConfirm.layer.masksToBounds = YES;
    _btnConfirm.layer.cornerRadius = 5;
    
    [_btnConfirm addTarget:self action:@selector(clickComplete) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickComplete
{
    if (_delegate)
    {
        [_delegate onClickComplete];
    }
}

- (void)setSiteRole
{
    _btnConfirm.hidden = YES;
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _btnConfirm.hidden = YES;
}

- (void)setSupplierMode
{
    _btnConfirm.hidden = YES;
}

@end
