//
//  HzsSettingsController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsSettingsController.h"
#import "HelpController.h"

#pragma mark - SettingsCell

@interface SettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbItem;

@end

@implementation SettingsCell


@end

#pragma mark - HzsSettingsController
@interface HzsSettingsController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HzsSettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"设置"];
    [self initView];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings_cell"];
    
    if (0 == indexPath.row) {
        cell.lbItem.text = @"检查更新";
        
    } else if (1 == indexPath.row) {
        cell.lbItem.text = @"关于";
        
    } else if (2 == indexPath.row) {
        cell.lbItem.text = @"修改密码";
        
    } else if (3 == indexPath.row) {
        cell.lbItem.text = @"消息设置";
        
    } else if (4 == indexPath.row) {
        cell.lbItem.text = @"帮助";
    }
    
    return cell;
}

/**
 *  检测是否需要升级
 */
- (void)checkUpdate
{
    [[HttpClient shareClient] post:URL_VERSION_CHECK parameters:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSInteger remoteVersion = [[responseObject[@"body"] objectForKey:@"appVersion"] integerValue];
                               
                               NSLog(@"remote version:%ld", remoteVersion);
                               
                               NSInteger localVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
                               
                               if(remoteVersion > localVersion) {
                                   
                                   [self performSelectorOnMainThread:@selector(showUpdate) withObject:nil waitUntilDone:NO];
                               } else {
                                   [self performSelectorOnMainThread:@selector(showNoUpdate) withObject:nil waitUntilDone:NO];
                               }
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
                               
                           }];
    
}

- (void)showUpdate
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新的版本更新"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://fir.im/ConcreteCloud"]];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)showNoUpdate
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前版本已经是最新"
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row) {
        [self checkUpdate];
        
    } else if (1 == indexPath.row) {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"hzs_about_controller"];
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (2 == indexPath.row) {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"hzs_pwd_modify_controller"];
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (3 == indexPath.row) {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"hzs_msg_settings_controller"];
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (4 == indexPath.row) {
        HelpController *controller = [[HelpController alloc] init];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
