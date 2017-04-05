//
//  KeyEditBtnCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyEditBtnCell.h"

@interface KeyEditBtnCell()
{
    void(^_onClickBtn)();
}

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation KeyEditBtnCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KeyEditBtnCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"key_edit_btn_cell";
}

+ (CGFloat)cellHeight
{
    return 44;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 10;
}

- (void)setOnClickBtnListener:(void (^)())onClick
{
    _onClickBtn = onClick;
    
    [_btn addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickBtn
{
    if (_onClickBtn)
    {
        _onClickBtn();
    }
}

- (void)setBtnImage
{
    [_btn setImage:[UIImage imageNamed:@"marker_location"] forState:UIControlStateNormal];
}

@end
