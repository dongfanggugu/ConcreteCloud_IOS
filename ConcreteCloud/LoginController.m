//
//  LoginController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginController.h"
#import "LoginRequest.h"
#import "AppDelegate.h"
#import "PersonInfo.h"
#import "Config.h"
#import "ResponseDictionary.h"
#import "JPUSHService.h"
#import "PumpMainController.h"
#import "RentTankerMainController.h"
#import "RentPumpMainController.h"
#import "AdminMainController.h"
#import "SupplierDriverMainController.h"
#import "SupAdminMainController.h"
#import "OthersMainController.h"
#import "BCheckerMainController.h"
#import "RegisterController.h"
#import "DialogEditView.h"
#import "WebViewController.h"


@interface LoginController()<DialogEditViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;

@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UILabel *lbVersion;

@property NSInteger jpushCount;

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initView
{
    
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 3;
    
    [_btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _tfUserName.text = [[Config shareConfig] getUserName];
    
    [_btnRegister addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    //设置当前版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _lbVersion.text = version;
    
    _lbVersion.userInteractionEnabled = YES;
    [_lbVersion addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIP)]];

    _tfPassword.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)changeIP
{
    DialogEditView *dialog = [DialogEditView viewFromNib];
    dialog.delegate = self;
    dialog.lbTitle.text = @"服务器修改,需要添加端口";
    dialog.tfContent.placeholder = @"服务器地址,包含端口";
    dialog.tfContent.text = [[Config shareConfig] getServer];
    
    [dialog show];

}

#pragma mark - DialogEditViewDelegate

- (void)onOKDismiss:(NSString *)content
{
    [[Config shareConfig] setServer:content];
    
    [HttpClient attempDealloc];
}

- (void)initData
{
    _jpushCount = 0;
}

- (void)registerUser
{
    RegisterController *controller = [[RegisterController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];;
    controller.navigationController.navigationBar.hidden = NO;
    
//    WebViewController *controller = [[WebViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];;
//    controller.navigationController.navigationBar.hidden = NO;
}

- (void)login
{
    NSString *userName = _tfUserName.text;
    if ([Utils isEmpty:userName])
    {
        [HUDClass showHUDWithLabel:@"请先填写手机号" view:self.view];
        return;
    }
    
    NSString *pwd = _tfPassword.text;
    if ([Utils isEmpty:pwd])
    {
        [HUDClass showHUDWithLabel:@"请填写密码" view:self.view];
        return;
    }
    

    
    
    LoginRequest *request = [[LoginRequest alloc] init];
    
//    request.tel = @"13800138008";
//    request.password = [Utils md5:@"123456"];
    
    request.tel = userName;
    request.password = [Utils md5:pwd];
    
    [[Config shareConfig] setUserName:userName];
    
    [[HttpClient shareClient] view:self.view post:URL_LOGIN parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObejct) {
                               ResponseDictionary *response = [[ResponseDictionary alloc] initWithDictionary:responseObejct];
                               
                               PersonInfo *info = [[PersonInfo alloc] initWithDictionary:response.body];
                               
                               NSString *roleId = info.roleId;
                               
                               [[Config shareConfig] setName:info.name];
                               [[Config shareConfig] setUserId:info.userId];
                               [[Config shareConfig] setToken:response.head.accessToken];
                               [[Config shareConfig] setRole:info.roleId];
                               [[Config shareConfig] setBranchId:info.branchId];
                               [[Config shareConfig] setType:info.type];
                               [[Config shareConfig] setBranchName:info.branchName];
                               [[Config shareConfig] setBranchAddress:info.companyAddress];
                               [[Config shareConfig] setBranchLogo:info.logo];
                               [[Config shareConfig] setLat:info.lat];
                               [[Config shareConfig] setLng:info.lng];
                               [[Config shareConfig] setHelpLink:info.helpUrl];
                               
                               [self registerJpush];
     
                               [[Config shareConfig] setOperable:YES];
     
                               if ([roleId isEqualToString:HZS_PURCHASER])
                               {
                                   UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
                                   
                                   UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"purchaser_main"];
                                   
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:HZS_DISPATCHER])
                               {
                                   UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
                                   
                                   UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"dispatcher_main_controller"];
                                   
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:SITE_ADMIN]
                                        || [roleId isEqualToString:SITE_PURCHASER]
                                        || [roleId isEqualToString:SITE_CHECKER])
                               {
                                   UIStoryboard *board = [UIStoryboard storyboardWithName:@"Site" bundle:nil];
                                   
                                   UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"site_main_controller"];
                                   
                                   [self.view.window setRootViewController:controller];

                               }
                               else if ([roleId isEqualToString:HZS_A_CHECKER])
                               {
                                   UIStoryboard *board = [UIStoryboard storyboardWithName:@"AChecker" bundle:nil];
                                   
                                   UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"achecker_main_controller"];
                                   
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:HZS_TANKER])
                               {
                                   UIStoryboard *board = [UIStoryboard storyboardWithName:@"Tanker" bundle:nil];
                                   
                                   UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"tanker_main_controller"];
                                   
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:HZS_PUMP])
                               {
                                   PumpMainController *controller = [[PumpMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:RENT_TANKER])
                               {
                                   RentTankerMainController *controller = [[RentTankerMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:RENT_PUMP])
                               {
                                   RentPumpMainController *controller = [[RentPumpMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:RENT_ADMIN])
                               {
                                   AdminMainController *controller = [[AdminMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:SUP_DRIVER])
                               {
                                   SupplierDriverMainController *controller = [[SupplierDriverMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:SUP_ADMIN]
                                        || [roleId isEqualToString:SUP_CLERK])
                               {
                                   SupAdminMainController *controller = [[SupAdminMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:HZS_OTHERS])
                               {
                                   [[Config shareConfig] setOperable:NO];
                                   OthersMainController *controller = [[OthersMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               else if ([roleId isEqualToString:HZS_B_CHECKER])
                               {
                                   UIViewController *controller = [[BCheckerMainController alloc] init];
                                   [self.view.window setRootViewController:controller];
                               }
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               
                           }];

}


- (void)registerJpush
{
    __weak typeof(self) weakSelf = self;
    [JPUSHService setTags:nil alias:[[Config shareConfig] getToken] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"zhenhao---rescode: %d, tags: %@, alias: %@", iResCode, iTags , iAlias);
        
        if (0 == iResCode)
        {
            NSLog(@"zhenhao:jpush register successfully!");
        }
        else
        {
            NSString *err = [NSString stringWithFormat:@"%d:注册消息服务器失败，请重新再试", iResCode];
            NSLog(@"zhenhao:%@", err);
            
            if (weakSelf.jpushCount < 5)
            {
                weakSelf.jpushCount++;
                [weakSelf registerJpush];
            }
            else
            {
                [HUDClass showHUDWithLabel:@"消息推送服务注册失败，请重新登录!" view:self.view];
                [self backToLogin];
            }
        }
    }];
}


- (void)backToLogin
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window setRootViewController:controller];
    [[Config shareConfig] setToken:@""];
}

@end


