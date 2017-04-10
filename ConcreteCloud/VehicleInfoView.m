//
//  VehicleInfoView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleInfoView.h"

@interface VehicleInfoView()

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (strong, nonatomic) void(^onClickDetail)();

@property (strong, nonatomic) void(^onClickClose)();

@end

@implementation VehicleInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VehicleInfoView" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setOnClickDetailListener:(void (^)())onClickDetail
{
    _onClickDetail = onClickDetail;
    
    _btnDetail.userInteractionEnabled = YES;
    
    [_btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addOnCloseClickListener:(void(^)())onClickClose
{
    _onClickClose = onClickClose;
    
    [_btnClose addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickClose
{
    if (_onClickClose) {
        _onClickClose();
    }
}


- (void)clickDetail
{
    _onClickDetail();
}

@end
