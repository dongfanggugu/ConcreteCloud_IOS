//
//  HzsAboutController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsAboutController.h"

@interface HzsAboutController()

@property (weak, nonatomic) IBOutlet UILabel *lbVersion;

@end


@implementation HzsAboutController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"关于"];
}

@end
