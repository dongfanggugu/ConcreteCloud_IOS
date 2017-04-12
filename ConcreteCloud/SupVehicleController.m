//
//  SupVehicleController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupVehicleController.h"
#import "SelVehicleRequest.h"
#import "RentVehicleListResponse.h"
#import "HzsTankerInfoCell.h"
#import "SupVehicleDetailController.h"
#import "SupVehicleAddController.h"


@interface SupVehicleController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<RentVehicleInfo *> *arrayVehicle;

@end

@implementation SupVehicleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆管理"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_add"]];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getVehicles];
}

- (void)onClickNavRight
{
    SupVehicleAddController *controller = [[SupVehicleAddController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData
{
    _arrayVehicle = [NSMutableArray array];
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

- (void)getVehicles
{
    SelVehicleRequest *request = [[SelVehicleRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    request.type = [[Config shareConfig] getType];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_VEHICLE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        RentVehicleListResponse *response = [[RentVehicleListResponse alloc] initWithDictionary:responseObject];
        [_arrayVehicle removeAllObjects];
        [_arrayVehicle addObjectsFromArray:[response getRentVehicleList]];
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
    return _arrayVehicle.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HzsTankerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[HzsTankerInfoCell identifier]];
    
    if (!cell)
    {
        cell = [HzsTankerInfoCell cellFromNib];
    }
    
    RentVehicleInfo *info = _arrayVehicle[indexPath.row];
    
    cell.lbPlate.text = info.plateNum;
    
    cell.lbType.text = [NSString stringWithFormat:@"车辆类型:%@", [self getVehicleName:info.cls.integerValue]];
    
    cell.lbLoad.text = [NSString stringWithFormat:@"运载量:%.1lf吨", info.weight];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SupVehicleDetailController *controller = [[SupVehicleDetailController alloc] init];
    controller.vehicleInfo = _arrayVehicle[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HzsTankerInfoCell cellHeight];
}

@end
