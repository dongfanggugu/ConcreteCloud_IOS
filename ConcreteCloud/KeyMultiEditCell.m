//
//  KeyMultiEditCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyMultiEditCell.h"


@interface KeyMultiEditCell()<UITextViewDelegate>

@end

@implementation KeyMultiEditCell

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KeyMultiEditCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)getIdentifier
{
    return @"key_multi_edit_cell";
}

+ (CGFloat)cellHeight
{
    return 112;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _tvContent.delegate = self;
    
    _tvContent.layer.masksToBounds = YES;
    _tvContent.layer.borderWidth = 1;
    _tvContent.layer.borderColor = [UIColor grayColor].CGColor;
    _tvContent.layer.cornerRadius = 5;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textView delegate");
    _lbPlaceHolder.hidden = YES;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    NSString *content = textView.text;
    if (0 == content.length)
    {
        _lbPlaceHolder.hidden = NO;
    }
    else
    {
        _lbPlaceHolder.hidden = YES;
    }
    
}

@end
