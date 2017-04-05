//
//  CarryInfoCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarryInfoCell.h"

@interface CarryInfoCell()


@property (weak, nonatomic) IBOutlet UIButton *btnVideo;

@property (strong, nonatomic) void(^onClickVideo)();

@end

@implementation CarryInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CarryInfoCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btnVideo.layer.masksToBounds = YES;
    _btnVideo.layer.cornerRadius = 11;
}

+ (NSString *)identifier
{
    return @"carry_info_cell";
}

+ (CGFloat)cellHeight
{
    return 105;
}

- (void)setOnClickVideo:(void(^)())onClickVideo
{
    _onClickVideo = onClickVideo;
    _btnVideo.userInteractionEnabled = YES;
    [_btnVideo addTarget:self action:@selector(clickVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickVideo
{
    if (_onClickVideo)
    {
        _onClickVideo();
    }
}

@end
