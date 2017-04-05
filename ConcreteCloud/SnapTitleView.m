//
//  SnapTitleView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnapTitleView.h"

@interface SnapTitleView()

@property (weak, nonatomic) IBOutlet UIButton *btnMore;


@property (strong, nonatomic) void (^onClickMore)();

@property CGFloat preWidth;

@end

@implementation SnapTitleView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SnapTitleView" owner:nil
                                                 options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
     _preWidth = 320;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_btnMore addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat offset = viewWidth - _preWidth;
    _preWidth = viewWidth;
    
    CGRect frame = _btnMore.frame;
    frame.origin.x = frame.origin.x + offset;
    
    _btnMore.frame = frame;
}


- (void)setOnClickMoreListener:(void (^)())onClickMore
{
    _onClickMore = onClickMore;
}

- (void)clickMore
{
    if (_onClickMore)
    {
        _onClickMore();
    }
}


+ (CGFloat)getSnapHeight
{
    return 60;
}


@end
