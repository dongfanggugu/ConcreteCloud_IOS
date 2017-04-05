//
//  DriverVehicleInfoController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverVehicleInfoController.h"
#import "RentVehicleInfo.h"
#import "SupDriverUnfinishedRequest.h"
#import "SupDriverUnfinishedResponse.h"
#import "KeyValueCell.h"

@interface DriverVehicleInfoController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) BOOL hasTask;

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;

@end


@implementation DriverVehicleInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆信息"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTask];
}

- (void)setHasTask:(BOOL)hasTask
{
    _hasTask = hasTask;
    
    if (!hasTask)
    {
        [_tableView reloadData];
    }
    
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (NSString *)getVehicleName:(NSInteger)type
{
    if (4 == type)
    {
        return @"砂石运输车";
    }
    else if (5 == type)
    {
        return @"外加剂运输车";
        
    }
    else if (6 == type)
    {
        return  @"散装粉料运输车";
    }
    else
    {
        return @"砂石运输车";
    }
}

#pragma mark - Network Request

- (void)getTask
{
    SupDriverUnfinishedRequest *request = [[SupDriverUnfinishedRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        SupDriverUnfinishedResponse *response = [[SupDriverUnfinishedResponse alloc] initWithDictionary:responseObject];
        
        if (!response.body.count)
        {
            self.hasTask = NO;
        }
        else
        {
            self.hasTask = YES;
            _vehicleInfo = [response getVehicle];
            [_tableView reloadData];
        }
        
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
    
    if (!_hasTask)
    {
        return 0;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车牌号";
        cell.lbValue.text = _vehicleInfo.plateNum;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"类型";
        cell.lbValue.text = [self getVehicleName:_vehicleInfo.cls.integerValue];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"运载量";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _vehicleInfo.weight];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [KeyValueCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_hasTask)
    {
        return 0;
    }
    else
    {
        return 80;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_hasTask)
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无未完成运输单";
        
        return label;
    }
}

@end
