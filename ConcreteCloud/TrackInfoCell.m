//
//  TrackInfoCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackInfoCell.h"

@implementation TrackInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TrackInfoCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"track_info_cell";
}

+ (CGFloat)cellHeight
{
    return 44;
}

@end
