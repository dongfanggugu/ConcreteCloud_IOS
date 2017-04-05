//
//  SiteStaffController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteStaffController.h"
#import "StaffListRequest.h"
#import "StaffListResponse.h"

#pragma mark - SiteStaffCell

@interface SiteStaffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbRole;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@end

@implementation SiteStaffCell



@end


#pragma mark - SiteStaffController

@interface SiteStaffController()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_arrayStaff;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SiteStaffController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"人员管理"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_add"]];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_arrayStaff removeAllObjects];
    [self getStaff];
}
- (void)onClickNavRight
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"site_staff_add_controller"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)initData
{
    _arrayStaff = [NSMutableArray array];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Network Request

- (void)getStaff
{
    StaffListRequest *request = [[StaffListRequest alloc] init];
    request.type = [[Config shareConfig] getType];
    request.leaseId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_STAFF_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        StaffListResponse *response = [[StaffListResponse alloc] initWithDictionary:responseObject];
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
    SiteStaffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"site_staff_cell"];
    
    SiteStaffInfo *info = _arrayStaff[indexPath.row];
    
    cell.lbName.text = info.name;
    cell.lbRole.text = info.roleNames;
    cell.lbTel.text = info.tel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end

