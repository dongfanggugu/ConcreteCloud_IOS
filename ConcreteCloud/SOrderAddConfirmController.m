//
//  SOrderAddConfirmController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOrderAddConfirmController.h"
#import "SDetailController.h"

@interface SOrderAddConfirmController()



@end

@implementation SOrderAddConfirmController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"订单确认"];
    [self initNavRightWithText:@"提交"];
    [self initView];
}

- (void)onClickNavRight
{
    
    //[_orderInfo toDictionary];
    [[HttpClient shareClient] view:self.view post:URL_S_ADD parameters:[_orderInfo toDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"订单添加成功" view:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)initView
{
    SDetailController *controller = [[SDetailController alloc] init];
    controller.orderInfo = _orderInfo;
    [self addChildViewController:controller];
    
    CGRect frame = controller.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 94;
    
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - 94;
    
    controller.view.frame = frame;
    
    [self.view addSubview:controller.view];
}

@end
