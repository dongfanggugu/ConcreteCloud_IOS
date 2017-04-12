//
//  AddressLocationController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "TitleViewController.h"

@protocol LocationControllerDelegate <NSObject>

- (void)onChooseAddressLat:(CGFloat)lat lng:(CGFloat)lng;

@end

@interface AddressLocationController : TitleViewController

@property (strong, nonatomic) NSString *address;

@property (weak, nonatomic) id<LocationControllerDelegate> delegate;

@end
