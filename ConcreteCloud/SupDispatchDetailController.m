//
//  SupDispatchDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/11.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "SupDispatchDetailController.h"
#import "KeyValueCell.h"

@interface SupDispatchDetailController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SupDispatchDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆详情"];
    
    [self initNavRightWithText:@"删除"];
    
    [self initView];
}

- (void)onClickNavRight
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"supplierOrderProcessId"] = _vehicleInfo.vehicleId;
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_DELETE_TASK parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [HUDClass showHUDWithText:@"车辆删除成功"];
                               [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 64)];
    
    tableView.bounces = NO;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    KeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:[KeyValueCell getIdentifier]];
    
    if (!cell) {
        cell = [KeyValueCell viewFromNib];
    }
    
    
    if (0 == indexPath.row) {
    
        cell.lbKey.text = @"司机";
        
        cell.lbValue.text = _vehicleInfo.driverName;
        
    } else if (1 == indexPath.row) {
        cell.lbKey.text = @"联系方式";
        
        cell.lbValue.text = _vehicleInfo.tel;
        
    } else if (2 == indexPath.row) {
        cell.lbKey.text = @"车牌号";
        
        cell.lbValue.text = _vehicleInfo.plateNum;
    
    } else if (3 == indexPath.row) {
        cell.lbKey.text = @"毛重";
        
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _vehicleInfo.weight];
    
    } else if (4 == indexPath.row) {
        cell.lbKey.text = @"皮重";
        
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _vehicleInfo.net];
    
    } else if (5 == indexPath.row) {
        cell.lbKey.text = @"净重";
        
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _vehicleInfo.number];
    
    } else if (6 == indexPath.row) {
        cell.lbKey.text = @"货物";
        
        cell.lbValue.text = _vehicleInfo.goodsName;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
