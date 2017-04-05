
//
//  PMoreController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMoreController.h"


#pragma mark - PMoreCell

@interface PMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PMoreCell


@end

#pragma mark - PMoreController

@interface PMoreController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation PMoreController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"更多"];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"p_more_cell"];
    
    if (nil == cell)
    {
        cell = [[PMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"p_more_cell"];
    }
    
    if (0 == indexPath.row)
    {
        cell.label.text = @"混凝土订单";
    }
    else if (1 == indexPath.row)
    {
        cell.label.text = @"我的";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
        
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"d_order_controller"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (1 == indexPath.row)
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
