//
//  SupOrderReceiveCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderReceiveCell.h"

@interface SupOrderReceiveCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@end

@implementation SupOrderReceiveCell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SupOrderReceiveCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}


+ (NSString *)identifier
{
    return @"sup_order_receive_cell";
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
