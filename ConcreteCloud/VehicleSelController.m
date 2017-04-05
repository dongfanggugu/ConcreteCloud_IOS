//
//  VehicleSelController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleSelController.h"
#import "SelVehicleResponse.h"
#import "SelVehicleRequest.h"
#import "SupDriverRequest.h"
#import "SupDriverResponse.h"
#import "SupVehicleSelCell.h"
#import "ListDialogView.h"
#import "RentBindRequest.h"
#import "SupDisRequestInfo.h"

@interface VehicleSelController()<UITableViewDelegate, UITableViewDataSource, SupVehicleSelCellDelegate,
                                    ListDialogViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<SelVehicleInfo *> *arrayVehicle;

@property (strong, nonatomic) NSMutableArray<SupDriverInfo *> *arrayDriver;

@property (strong, nonatomic) NSMutableDictionary<NSString *, SelVehicleInfo *> *dicSel;



@end


@implementation VehicleSelController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆选择"];
    [self initNavRightWithText:@"指派"];
    [self initData];
    [self initView];
    [self getFreeVehicles];
}

- (void)onClickNavRight
{
    if (0== _dicSel.count)
    {
        [HUDClass showHUDWithLabel:@"请先选择车辆" view:self.view];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (SelVehicleInfo *vehicle in [_dicSel allValues])
    {
        if (!vehicle.driverId)
        {
            [HUDClass showHUDWithLabel:@"请为选择的车辆添加司机" view:self.view];
            return;
        }
        
        SupDisRequestInfo *info = [[SupDisRequestInfo alloc] init];
        info.driverId = vehicle.driverId;
        info.goodsName = _orderInfo.goodsName;
        info.supplierOrderId = _orderInfo.orderId;
        info.userName = [[Config shareConfig] getName];
        info.plateNum = vehicle.plateNum;
        
        [array addObject:[info toDictionary]];
    }
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_DISPATCH_VEHICLE parameters:array success:^(NSURLSessionDataTask *task, id responseObject) {
        [self performSelector:@selector(back) withObject:nil afterDelay:1.f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    _arrayVehicle = [NSMutableArray array];
    _arrayDriver = [NSMutableArray array];
    _dicSel = [NSMutableDictionary dictionary];
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

- (NSString *)getCls
{
    NSString *goods = _orderInfo.goodsName;
    
    if ([goods isEqualToString:SHAZI]
        || [goods isEqualToString:SHIZI]
        || [goods isEqualToString:OTHERS])
    {
        return @"4";
    }
    else if ([goods isEqualToString:WAIJIAJI])
    {
        return @"5";
    }
    else
    {
        return @"6";
    }
}


/**
 更新已经选择的车辆信息
 */
- (void)updateSelVehicle
{
    NSArray *array = _dicSel.allKeys;
    
    for (SelVehicleInfo *info in _arrayVehicle)
    {
        if ([array containsObject:info.vehicleId])
        {
            _dicSel[info.vehicleId] = info;
        }
    }
}

#pragma mark - Network Request

- (void)getFreeVehicles
{
    SelVehicleRequest *request = [[SelVehicleRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    request.cls = [self getCls];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_FREE_VEHICLE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        SelVehicleResponse *response = [[SelVehicleResponse alloc] initWithDictionary:responseObject];
        
        [_arrayVehicle removeAllObjects];
        [_arrayVehicle addObjectsFromArray:[response getSelVehicles]];
        
        [self updateSelVehicle];
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
    SupVehicleSelCell *cell = [tableView dequeueReusableCellWithIdentifier:[SupVehicleSelCell identifier]];
    
    if (!cell)
    {
        cell = [SupVehicleSelCell cellFromNib];
    }
    
    cell.delegate = self;
    
    SelVehicleInfo *info = _arrayVehicle[indexPath.row];
    
    cell.lbPlate.text = info.plateNum;
    
    cell.lbLoad.text = [NSString stringWithFormat:@"%.1lf吨", info.weight];
    
    cell.swSel.tag = indexPath.row;
    
    cell.btn.tag = indexPath.row;
    
    if (info.driverName)
    {
        cell.lbDriver.text = info.driverName;
        cell.lbTel.text = info.driverTel;
    }
    else
    {
        cell.lbDriver.text = @"暂无司机";
        cell.lbTel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SupVehicleSelCell cellHeight];
}

#pragma mark - SupVehicleSelCellDelegate

- (void)onClickBtn:(UIButton *)btn
{
    SupDriverRequest *request = [[SupDriverRequest alloc] init];
    request.supplierId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_FREE_DRIVER parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        SupDriverResponse *response = [[SupDriverResponse alloc] initWithDictionary:responseObject];
        [_arrayDriver removeAllObjects];
        [_arrayDriver addObjectsFromArray:[response getSupDrivers]];
        
        [self showListDialog:btn.tag];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)onChangeSwitch:(UISwitch *)swSel
{
    NSInteger tag = swSel.tag;
    
    BOOL on = swSel.isOn;
    
    if (on)
    {
        NSString *vehicleId = _arrayVehicle[tag].vehicleId;
        _dicSel[vehicleId] = _arrayVehicle[tag];
    }
    else
    {
        NSString *vehicleId = _arrayVehicle[tag].vehicleId;
        [_dicSel removeObjectForKey:vehicleId];
    }
    
}

- (void)showListDialog:(NSInteger)tag
{
    ListDialogView *dialog = [ListDialogView viewFromNib];
    
    dialog.tag = tag;
    
    dialog.delegate = self;
    
    [dialog setData:_arrayDriver];
    
    [self.view addSubview:dialog];
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectDialogTag:(NSInteger)tag key:(NSString *)key content:(NSString *)content
{
    SelVehicleInfo *info = _arrayVehicle[tag];
    
    RentBindRequest *request = [[RentBindRequest alloc] init];
    request.vehicelId = info.vehicleId;
    request.driverId = key;
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_BIND parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self getFreeVehicles];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

@end
