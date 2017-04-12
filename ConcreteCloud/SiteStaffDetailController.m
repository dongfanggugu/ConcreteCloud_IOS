//
//  SiteStaffDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "SiteStaffDetailController.h"
#import "KeyValueCell.h"

@interface SiteStaffDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SiteStaffDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"员工信息"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_delete"]];
    [self initView];
}

- (void)onClickNavRight
{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除人员?"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteStaff];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)deleteStaff
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"id"] = _staffInfo.staffId;
    
    param[@"supplierId"] = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_SITE_DEL_STAFF parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [HUDClass showHUDWithText:@"车辆删除成功!"];
                               [self.navigationController popViewControllerAnimated:YES];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
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
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueCell *cell = [KeyValueCell viewFromNib];
    
    if (0 == indexPath.row) {
        cell.lbKey.text = @"姓名";
        cell.lbValue.text = _staffInfo.name;
        
    } else if (1 == indexPath.row) {
        cell.lbKey.text = @"性别";
        cell.lbValue.text = _staffInfo.sex.integerValue == 0 ? @"男" : @"女";
        
    } else if (2 == indexPath.row) {
        cell.lbKey.text = @"年龄";
        cell.lbValue.text = [NSString stringWithFormat:@"%ld", _staffInfo.age];
        
    } else if (3 == indexPath.row) {
        cell.lbKey.text = @"职务";
        cell.lbValue.text = _staffInfo.duty;
        
    } else if (4 == indexPath.row) {
        cell.lbKey.text = @"电话";
        cell.lbValue.text = _staffInfo.tel;
        
    } else if (5 == indexPath.row) {
        cell.lbKey.text = @"角色";
        cell.lbValue.text = _staffInfo.roleNames;
        
    } else if (6 == indexPath.row) {
        cell.lbKey.text = @"职工编写";
        cell.lbValue.text = _staffInfo.code;
        
    } else if (7 == indexPath.row) {
        cell.lbKey.text = @"是否可下单";
        cell.lbValue.text = [_staffInfo.isOrder integerValue] == 1 ? @"是" : @"否";
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


@end
