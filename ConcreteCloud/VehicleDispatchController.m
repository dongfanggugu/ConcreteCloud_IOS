//
//  VehicleDispatchController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleDispatchController.h"
#import "SupDisVehicleResponse.h"
#import "SupDisVehicleRequest.h"
#import "SupDisVehicleCell.h"
#import "VehicleSelController.h"


@interface VehicleDispatchController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<SupDisVehicleInfo *> *arrayVehicle;

@end


@implementation VehicleDispatchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆指派"];
    [self initNavRightWithText:@"车辆选择"];
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
    VehicleSelController *controller = [[VehicleSelController alloc] init];
    controller.orderInfo = _orderInfo;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData
{
    _arrayVehicle = [NSMutableArray array];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Network Request

- (void)getVehicles
{
    SupDisVehicleRequest *request = [[SupDisVehicleRequest alloc] init];
    request.supplierOrderId = _orderInfo.orderId;
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_VEHICLE_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
                SupDisVehicleResponse *response = [[SupDisVehicleResponse alloc] initWithDictionary:responseObject];
        
                [_arrayVehicle removeAllObjects];
                [_arrayVehicle addObjectsFromArray:[response getVehicles]];
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
    SupDisVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:[SupDisVehicleCell identifier]];
    
    if (!cell)
    {
        cell = [SupDisVehicleCell cellFromNib];
    }
    
    SupDisVehicleInfo *info = _arrayVehicle[indexPath.row];
    
    cell.lbDriver.text = info.driverName;
    
    cell.lbTel.text = info.tel;
    
    cell.lbPlate.text = info.plateNum;
    
    cell.lbGoods.text = info.goodsName;
    
    cell.lbLoad.text = [NSString stringWithFormat:@"%.1lf吨", info.loadWeight];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SupDisVehicleCell cellHeight];
}

@end
