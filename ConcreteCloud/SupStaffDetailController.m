//
//  SupStaffDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupStaffDetailController.h"
#import "KeyValueCell.h"

@interface SupStaffDetailController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SupStaffDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"员工信息"];
    [self initView];
}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.bounces = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource =  self;
    
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueCell *cell = [KeyValueCell viewFromNib];
    
    if (0 == indexPath.row)
    {
        cell.lbKey.text = @"姓名";
        cell.lbValue.text = _staffInfo.name;
    }
    else if (1 == indexPath.row)
    {
        cell.lbKey.text = @"性别";
        cell.lbValue.text = _staffInfo.sex.integerValue == 0 ? @"男" : @"女";
    }
    else if (2 == indexPath.row)
    {
        cell.lbKey.text = @"年龄";
        cell.lbValue.text = [NSString stringWithFormat:@"%ld", _staffInfo.age];
    }
    else if (3 == indexPath.row)
    {
        cell.lbKey.text = @"角色";
        cell.lbValue.text = _staffInfo.roleNames;
    }
    else if (4 == indexPath.row)
    {
        cell.lbKey.text = @"职位信息";
        cell.lbValue.text = _staffInfo.duty;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

@end
