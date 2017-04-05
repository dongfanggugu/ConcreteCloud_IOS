//
//  HzsPwdModifyController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsPwdModifyController.h"
#import "PwdModifyRequest.h"

@interface HzsPwdModifyController()

@property (weak, nonatomic) IBOutlet UITextField *tfOld;

@property (weak, nonatomic) IBOutlet UITextField *tfNew;

@property (weak, nonatomic) IBOutlet UITextField *tfConfirm;

@end


@implementation HzsPwdModifyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"修改密码"];
    [self initNavRightWithText:@"提交"];
}

- (void)onClickNavRight
{
    [self submit];
}


#pragma mark - Network Request

- (void)submit
{
    NSString *old = [_tfOld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (0 == old.length)
    {
        [HUDClass showHUDWithLabel:@"请填写原密码" view:self.view];
        return;
    }
    
    NSString *new = [_tfNew.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (0 == new.length)
    {
        [HUDClass showHUDWithLabel:@"请填写新密码" view:self.view];
        return;
    }
    
    NSString *confirm = [_tfConfirm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (0 == confirm.length)
    {
        [HUDClass showHUDWithLabel:@"请填写确认密码" view:self.view];
        return;
    }
    
    if (![new isEqualToString:confirm])
    {
        [HUDClass showHUDWithLabel:@"新密码和确认密码不一致,请重新输入" view:self.view];
        return;
    }
    
    PwdModifyRequest *request = [[PwdModifyRequest alloc] init];
    request.passedPwd = [Utils md5:old];
    request.curPwd = [Utils md5:new];
    
    [[HttpClient shareClient] view:self.view post:URL_PWD_MODIFY parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [HUDClass showHUDWithLabel:@"密码修改成功!" view:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
