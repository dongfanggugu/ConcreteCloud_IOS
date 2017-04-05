//
//  SMoreController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMoreController.h"

typedef NS_ENUM(NSInteger, SITE_ROLE)
{
    ADMIN,
    NORMAL
};


#pragma mark - SMoreCell

@interface SMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SMoreCell


@end

#pragma mark - SMoreController

@interface SMoreController()<UITableViewDelegate, UITableViewDataSource>
{
    SITE_ROLE _role;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SMoreController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"更多"];
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initData
{
    NSString *role = [[Config shareConfig] getRole];
    
    if ([role isEqualToString:SITE_ADMIN])
    {
        _role = ADMIN;
    }
    else
    {
        _role = NORMAL;
    }
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
    NSString *roleId = [[Config shareConfig] getRole];
    
    if ([roleId isEqualToString:SITE_ADMIN])
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s_more_cell"];
    
    if (nil == cell)
    {
        cell = [[SMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"s_more_cell"];
    }
    
    if (0 == indexPath.row)
    {
        if (_role == ADMIN)
        {
            cell.label.text = @"人员";
        }
        else
        {
            cell.label.text = @"泵车轨迹";
        }
        
    }
    else if (1 == indexPath.row)
    {
        if (_role == ADMIN)
        {
            cell.label.text = @"泵车轨迹";
        }
        else
        {
            cell.label.text = @"我的";
        }

    }
    else
    {
        cell.label.text = @"我的";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMoreCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *content = cell.label.text;
    
    
    if ([content isEqualToString:@"人员"])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"site_staff_controller"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if ([content isEqualToString:@"泵车轨迹"])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"site_pump_controller"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }
    else if ([content isEqualToString:@"我的"])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_person"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
