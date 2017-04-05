//
//  ACheckMoreController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACheckMoreController.h"

#pragma mark - ACheckMoreCell

@interface ACheckMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ACheckMoreCell


@end

#pragma mark - ACheckMoreController

@interface ACheckMoreController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation ACheckMoreController


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
    ACheckMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"acheck_more_cell"];
    
    if (nil == cell)
    {
        cell = [[ACheckMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"acheck_more_cell"];
    }
    
    if (0 == indexPath.row)
    {
        cell.label.text = @"检验视频";
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
        
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"acheck_video_controller"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed = NO;
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
