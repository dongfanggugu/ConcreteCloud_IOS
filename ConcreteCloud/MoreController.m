//
//  MoreController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoreController.h"
#import "MoreCell.h"
#import "SupStaffController.h"
#import "SupVehicleController.h"
#import "BCheckVideoController.h"
#import "VideoRecordController.h"

@interface MoreController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end


@implementation MoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"更多"];
    [self initView];
}


- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoreCell identifier]];
    
    if (!cell)
    {
        cell = [MoreCell cellFromNib];
    }
    
    if (0 == indexPath.row)
    {
        cell.lbContent.text = @"租赁";
    }
    else if (1 == indexPath.row)
    {
        cell.lbContent.text = @"工地";
    }
    else if (2 == indexPath.row)
    {
        cell.lbContent.text = @"混凝土检验视频";
    }
    else if (3 == indexPath.row)
    {
        cell.lbContent.text = @"原材料检验视频";
    }
    else if (4 == indexPath.row)
    {
        cell.lbContent.text = @"罐车粘附重量统计";
    }
    else if (5 == indexPath.row)
    {
        cell.lbContent.text = @"检验视频未拍摄通知";
    }
    else if (6 == indexPath.row)
    {
        cell.lbContent.text = @"消息";
    }
    else if (7 == indexPath.row)
    {
        cell.lbContent.text = @"我的";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MoreCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
        UIViewController *rent = [board instantiateViewControllerWithIdentifier:@"rent_controller"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rent animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }
    else if (1 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
        UIViewController *rent = [board instantiateViewControllerWithIdentifier:@"project_controller"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rent animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (2 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"AChecker" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"acheck_video_controller"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (3 == indexPath.row)
    {
        UIViewController *video = [[BCheckVideoController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:video animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (4 == indexPath.row)
    {
        VideoRecordController *controller = [[VideoRecordController alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }
    else if (5 == indexPath.row)
    {
        
    }
    else if (6 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_message_controller"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (7 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_person"];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
