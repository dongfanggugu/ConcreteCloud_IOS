//
//  RenterAdminMoreController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RenterAdminMoreController.h"
#import "MoreCell.h"
#import "RenterPumpListController.h"

@interface RenterAdminMoreController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RenterAdminMoreController

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoreCell identifier]];
    
    if (!cell) {
        cell = [MoreCell cellFromNib];
    }
    
    if (0 == indexPath.row) {
        cell.lbContent.text = @"泵车轨迹";
        
    } else if (1 == indexPath.row) {
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
    if (0 == indexPath.row) {
        RenterPumpListController *controller = [[RenterPumpListController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (1 == indexPath.row) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_person"];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
