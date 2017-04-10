//
//  HzsPersonController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsPersonController.h"
#import "PersonHeaderView.h"
#import "AppDelegate.h"

#pragma mark - HzsPersonCell

@interface HzsPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbValue;

@end

@implementation HzsPersonCell



@end

#pragma mark - HzsPersonController

@interface HzsPersonController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PersonHeaderView *personHeaderView;

@property (assign, nonatomic) G_Agent_Type agentType;

@end

@implementation HzsPersonController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self setNaviTitle:@"我的"];
    [self initView];
}


- (void)initData
{
    _agentType = [[[Config shareConfig] getType] integerValue];
}

- (void)initView
{
    _personHeaderView = [PersonHeaderView viewFromNib];
    
    _personHeaderView.lbName.text = [[Config shareConfig] getName];
    _personHeaderView.lbRole.text = [[Config shareConfig] getRoleName];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HzsPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hzs_person_cell"];
    
    if (nil == cell)
    {
        cell = [[HzsPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hzs_person_cell"];
    }
    
    if (0 == indexPath.row)
    {
        
        if (Agent_Hzs ==  _agentType) {
            cell.lbKey.text = @"搅拌站";
            
        } else if (Agent_Site == _agentType) {
            cell.lbKey.text = @"工程";
            
        } else if (Agent_Supplier == _agentType) {
            cell.lbKey.text = @"供应商";
            
        } else if (Agent_Renter == _agentType) {
            cell.lbKey.text = @"租赁商";
        }
        
        cell.lbValue.text = [[Config shareConfig] getBranchName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (1 == indexPath.row)
    {
        cell.lbKey.text = @"地址";
        cell.lbValue.text = [[Config shareConfig] getBranchAddress];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (2 == indexPath.row)
    {
        cell.lbKey.text = @"设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (3 == indexPath.row)
    {
        cell.lbKey.text = @"退出";
    }
    
    CGRect frame = cell.lbValue.frame;
    
    NSLog(@"my width:%lf", frame.size.width);
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _personHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (1 == indexPath.row)
    {
        CGFloat width = self.view.frame.size.width;
        CGSize size = CGSizeMake(width - 8 - 80 - 8 - 8, CGFLOAT_MAX);
        
        NSString *content = [[Config shareConfig] getBranchAddress];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 100)];
        
        label.text = content;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:14];
        [label sizeToFit];;
        
        return label.frame.size.height + 10 + 10;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (2 == indexPath.row)
    {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"hzs_settings_controller"];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (3 == indexPath.row)
    {
        [[HttpClient shareClient] view:self.view post:URL_LOGOUT parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self backToLogin];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            [self backToLogin];
        }];
        
        
    }
}

- (void)backToLogin
{
    [[Config shareConfig] setToken:@""];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.bgCheckTimer)
    {
        [appDelegate.bgCheckTimer invalidate];
        
        appDelegate.bgCheckTimer = nil;
    }
    
    if (appDelegate.locationTimer)
    {
        [appDelegate.locationTimer invalidate];
        appDelegate.locationTimer = nil;
    }
    
    if (appDelegate.disAndTimeTimer) {
        [appDelegate.disAndTimeTimer invalidate];
        appDelegate.disAndTimeTimer = nil;
    }
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window setRootViewController:controller];
}

@end
