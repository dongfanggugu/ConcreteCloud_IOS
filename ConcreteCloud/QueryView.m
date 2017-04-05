//
//  QueryView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryView.h"


@interface QueryView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfFrom;

@property (weak, nonatomic) IBOutlet UITextField *tfTo;

@property (weak, nonatomic) IBOutlet UIButton *btnQuery;


@end



@implementation QueryView


+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"QueryView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnQuery.layer.masksToBounds = YES;
    _btnQuery.layer.cornerRadius = 12;
    
    _btnQuery.layer.borderWidth = 1;
    _btnQuery.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    [_btnQuery addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //配置起始日期
    
    _tfFrom.delegate = self;
    
    _tfFrom.text = QV_TF_INIT;
    
    _tfFrom.layer.borderWidth = 1;
    
    _tfFrom.layer.borderColor = [UIColor grayColor].CGColor;
    
    _tfFrom.layer.masksToBounds = YES;
    
    _tfFrom.layer.cornerRadius = 5;
    
    _tfFrom.textAlignment = NSTextAlignmentCenter;
    
    _tfFrom.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, _tfFrom.frame.size.height)];
    
    label.font = [UIFont systemFontOfSize:13];
    
    label.text = @"起:";
    
    label.textAlignment = NSTextAlignmentCenter;
    
    _tfFrom.leftView = label;
    
    //_tfFrom.enabled = NO;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tfFrom.frame.size.height - 5, _tfFrom.frame.size.height - 5)];
    
    imageView.image = [UIImage imageNamed:@"icon_date"];
    
    imageView.userInteractionEnabled = YES;
    
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromSel)]];
    
    _tfFrom.rightViewMode = UITextFieldViewModeAlways;
    
    _tfFrom.rightView = imageView;

    
    
    //配置结束日期
    _tfTo.delegate = self;
    
    _tfTo.text = QV_TF_INIT;
    
    _tfTo.layer.borderWidth = 1;
    
    _tfTo.layer.borderColor = [UIColor grayColor].CGColor;
    
    _tfTo.layer.masksToBounds = YES;
    
    _tfTo.layer.cornerRadius = 5;
    
    _tfTo.textAlignment = NSTextAlignmentCenter;
    
    _tfTo.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, _tfTo.frame.size.height)];
    
    label2.font = [UIFont systemFontOfSize:13];
    
    label2.text = @"止:";
    
    label2.textAlignment = NSTextAlignmentCenter;
    
    _tfTo.leftView = label2;
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tfTo.frame.size.height - 5, _tfTo.frame.size.height - 5)];
    
    imageView2.image = [UIImage imageNamed:@"icon_date"];
    
    imageView2.userInteractionEnabled = YES;
    
    [imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSel)]];
    
    _tfTo.rightViewMode = UITextFieldViewModeAlways;
    
    _tfTo.rightView = imageView2;
}

- (void)onClickBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickQueryStart:end:)])
    {
        NSString *start = _tfFrom.text;
        NSString *end = _tfTo.text;
        
        [_delegate onClickQueryStart:start end:end];
    }
}

- (void)fromSel
{

    if (_delegate && [_delegate respondsToSelector:@selector(onSelFrom:)])
    {
        [_delegate onSelFrom:_tfFrom];
    }
}


- (void)toSel
{
    if (_delegate && [_delegate respondsToSelector:@selector(onSelTo:)])
    {
        [_delegate onSelTo:_tfTo];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

@end
