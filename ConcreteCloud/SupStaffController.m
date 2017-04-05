//
//  SupStaffController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupStaffController.h"
#import "RentDriverCell.h"
#import "SupDriverRequest.h"
#import "StaffListResponse.h"
#import "SupStaffDetailController.h"

@interface SupStaffController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<SiteStaffInfo *> *arrayStaff;

@end

@implementation SupStaffController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"人员"];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getStaffs];
}

- (void)initData
{
    _arrayStaff = [NSMutableArray array];
}


- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Network Request

- (void)getStaffs
{
    SupDriverRequest *request = [[SupDriverRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_STAFF parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        StaffListResponse *response = [[StaffListResponse alloc] initWithDictionary:responseObject];
        [_arrayStaff removeAllObjects];
        [_arrayStaff addObjectsFromArray:[response getStaffList]];
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
    return _arrayStaff.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:[RentDriverCell identifier]];
    
    if (!cell)
    {
        cell = [RentDriverCell cellFromNib];
    }
    
    SiteStaffInfo *info = _arrayStaff[indexPath.row];
    
    cell.lbName.text = [NSString stringWithFormat:@"%@(%@)", info.name, info.roleNames];
    
    cell.lbTel.text = info.tel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SupStaffDetailController *controller = [[SupStaffDetailController alloc] init];
    controller.staffInfo = _arrayStaff[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RentDriverCell cellHeight];
}

@end
