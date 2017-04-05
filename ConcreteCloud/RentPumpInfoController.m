//
//  RentPumpInfoController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentPumpInfoController.h"
#import "KeyValueCell.h"
#import "RentWorkStateResponse.h"

@interface RentPumpInfoController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *lbNoVehicle;

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;

@end

@implementation RentPumpInfoController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆信息"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getVehicle];
}

- (void)initView
{
    [self initNoVehicleView];
    [self initTableView];
}
- (void)initNoVehicleView
{
    _lbNoVehicle = [[UILabel alloc] initWithFrame:CGRectMake(8, 100, self.screenWidth - 16, 20)];
    
    _lbNoVehicle.font = [UIFont systemFontOfSize:15];
    
    _lbNoVehicle.textAlignment = NSTextAlignmentCenter;
    
    _lbNoVehicle.text = @"还没有绑定车辆,暂无车辆信息";
}

- (void)showNoVehicleView
{
    if (_tableView && _tableView.superview)
    {
        [_tableView removeFromSuperview];
    }
    
    if (_lbNoVehicle && !_lbNoVehicle.superview)
    {
        [self.view addSubview:_lbNoVehicle];
    }
        
}

- (void)showTableView
{
    if (_lbNoVehicle && _lbNoVehicle.superview)
    {
        [_lbNoVehicle removeFromSuperview];
    }
    
    if (_tableView)
    {
        if (!_tableView.superview)
        {
            [self.view addSubview:_tableView];
        }
        
        [_tableView reloadData];
    }
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 50)];
    
    _tableView.bounces = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Network Request

- (void)getVehicle
{
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_CUR_VEHICLE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RentWorkStateResponse *response = [[RentWorkStateResponse alloc] initWithDictionary:responseObject];
        
        _vehicleInfo = [response getVehicleInfo];
        
        if (!_vehicleInfo)
        {
            [self showNoVehicleView];
        }
        else
        {
            [self showTableView];
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
    return 6;
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
        cell.lbKey.text = @"车辆类型";
        cell.lbValue.text = @"泵车";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车辆种类";
        cell.lbValue.text = [self getVehicleName:_vehicleInfo];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"出厂日期";
        cell.lbValue.text = _vehicleInfo.additionalInfo.productionTime;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        
        NSInteger pumpType = _vehicleInfo.additionalInfo.type.integerValue;
        
        if (1 == pumpType)
        {
            cell.lbKey.text = @"臂长";
            cell.lbValue.text = [NSString stringWithFormat:@"%.1lf米", _vehicleInfo.additionalInfo.armLength];
        }
        else
        {
            cell.lbKey.text = @"理论输送方量";
            cell.lbValue.text = [NSString stringWithFormat:@"%.1lf立方米", _vehicleInfo.additionalInfo.flow];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车辆所属单位";
        cell.lbValue.text = _vehicleInfo.leaseName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    return nil;
}

- (NSString *)getVehicleName:(RentVehicleInfo *)info
{
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return @"混凝土运输车";
    }
    else if (3 == type)
    {
        NSInteger gcType = [info.additionalInfo.type integerValue];
        
        if (1 == gcType)
        {
            return @"汽车泵";
        }
        else if (2 == gcType)
        {
            return @"车载泵";
        }
        else if (3 == gcType)
        {
            return @"拖式泵";
        }
        else
        {
            return @"泵车";
        }
    }
    else
    {
        return @"混凝土运输车";
    }
}

@end
