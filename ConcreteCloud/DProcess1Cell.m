//
//  DProcess1Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DProcess1Cell.h"

@interface DProcess1Cell()

@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;


@end


@implementation DProcess1Cell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DProcess1Cell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 150;
}

+ (NSString *)identifier
{
    return @"d_process1_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnOK.layer.masksToBounds = YES;
    _btnOK.layer.cornerRadius = 5;
    
    _btnCancel.layer.masksToBounds = YES;
    _btnCancel.layer.cornerRadius = 5;
    
    [_btnOK addTarget:self action:@selector(onClickOK) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickOK
{
    if (_delegate)
    {
        [_delegate onClickOK];
    }
}

- (void)onClickCancel
{
    if (_delegate)
    {
        [_delegate onClickCancel];
    }
}

- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    _btnOK.hidden = NO;
    _btnCancel.hidden = NO;
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _btnOK.hidden = YES;
    _btnCancel.hidden = YES;
}

@end
