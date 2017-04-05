//
//  RentDriverController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentDriverController.h"
#import "StaffListRequest.h"
#import "StaffListResponse.h"
#import "RentDriverCell.h"
#import "RentDriverInfoController.h"

@interface RentDriverController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<SiteStaffInfo *> *arrayDriver;

@end

@implementation RentDriverController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"司机管理"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_add"]];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getStaff];
}

- (void)initData
{
    _arrayDriver = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)];
    
    _tableView.bounces = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource =  self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (void)getStaff
{
    
    StaffListRequest *request = [[StaffListRequest alloc] init];
    
    request.type = [[Config shareConfig] getType];
    request.leaseId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_STAFF_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        StaffListResponse *response = [[StaffListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayDriver removeAllObjects];
        [_arrayDriver addObjectsFromArray:[response getStaffList]];
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayDriver.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:[RentDriverCell identifier]];
    
    if (!cell)
    {
        cell = [RentDriverCell cellFromNib];
    }
    
    SiteStaffInfo *info = _arrayDriver[indexPath.row];
    
    cell.lbName.text = [NSString stringWithFormat:@"%@(%@)", info.name, info.roleNames];
    cell.lbTel.text = info.tel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RentDriverCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RentDriverInfoController *controller = [[RentDriverInfoController alloc] init];
    controller.staffInfo = _arrayDriver[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

@end
