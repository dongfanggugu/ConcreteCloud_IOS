//
//  CZBInfoView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZBInfoView.h"

@interface CZBInfoView()
{
    void (^_onClickBtn)();
}

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation CZBInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CZBInfoView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

- (void)addBtnClickListenner:(void (^)())onClickBtn
{
    _onClickBtn = onClickBtn;
    
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtn
{
    if (_onClickBtn)
    {
        _onClickBtn();
    }
}

@end
