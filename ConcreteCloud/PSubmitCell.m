//
//  PSubmitCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSubmitCell.h"

@interface PSubmitCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@end

@implementation PSubmitCell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PSubmitCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}


+ (NSString *)identifier
{
    return @"p_submit_cell";
}

+ (CGFloat)cellHight
{
    return 124;
}


- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];

}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
}


@end
