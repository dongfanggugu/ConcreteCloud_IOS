//
//  VehicleController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleController.h"
#import "RentWorkStateResponse.h"
#import "RentVehicleRequest.h"
#import "RentVehicleListResponse.h"
#import "KeyValueCell.h"
#import "RentVehicleInfoCell.h"
#import "VehicleInfoController.h"
#import "RentVehicleAddController.h"

@interface VehicleController()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _bindVehicle;
    
    BOOL _isTanker;
}

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;

@property (strong, nonatomic) NSMutableArray<RentVehicleInfo *> *arrayVehicle;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation VehicleController

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
    
    [self getBindVehicle];
}

- (void)onClickNavRight
{
    RentVehicleAddController *controller = [[RentVehicleAddController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)
                                              style:UITableViewStyleGrouped];
    
    _tableView.bounces = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource =  self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (void)initData
{
    _arrayVehicle = [NSMutableArray array];
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


#pragma mark - Network Request

- (void)getBindVehicle
{
    [[HttpClient shareClient] view:self.view post:URL_RENT_CUR_VEHICLE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RentWorkStateResponse *response = [[RentWorkStateResponse alloc] initWithDictionary:responseObject];
        
        _vehicleInfo = [response getVehicleInfo];
        
        if (_vehicleInfo)
        {
            _bindVehicle = YES;
            
            NSInteger vehicleType = _vehicleInfo.cls.integerValue;
            
            if (3 == vehicleType)
            {
                _isTanker = NO;
            }
            else
            {
                _isTanker = YES;
            }
        }
        else
        {
            _bindVehicle = NO;
        }
        [self getVehicle];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


- (void)getVehicle
{
    RentVehicleRequest *request = [[RentVehicleRequest alloc] init];
    request.type = [[Config shareConfig] getType];
    request.leaseId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_VEHICLE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
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
    if (_bindVehicle)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_bindVehicle)
    {
        if (0 == section)
        {
            if (_isTanker)
            {
                return 4;
            }
            else
            {
                return 6;
            }
        }
        else
        {
            return _arrayVehicle.count;
        }
    }
    else
    {
        return _arrayVehicle.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bindVehicle)
    {
        if (0 == indexPath.section)
        {
            if (_isTanker)
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
                    cell.lbValue.text = @"混凝土运输车";
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if (2 == indexPath.row)
                {
                    KeyValueCell *cell = [KeyValueCell viewFromNib];
                    cell.lbKey.text = @"运载量";
                    cell.lbValue.text = [NSString stringWithFormat:@"%.1lf立方米", _vehicleInfo.weight];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if (3 == indexPath.row)
                {
                    KeyValueCell *cell = [KeyValueCell viewFromNib];
                    cell.lbKey.text = @"车辆净重";
                    cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _vehicleInfo.selfNet];;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }//fi (_isTanker)
            else
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
            }//fi (_isTanker)
            
        }//fi (0 == indexPath.section)
        else
        {
            RentVehicleInfo *vehicleInfo = _arrayVehicle[indexPath.row];
            
            RentVehicleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[RentVehicleInfoCell identifier]];
            
            if (!cell)
            {
                cell = [RentVehicleInfoCell cellFromNib];
            }
            
            cell.lbPlate.text = [NSString stringWithFormat:@"车牌号:%@", vehicleInfo.plateNum];
            cell.lbType.text = [NSString stringWithFormat:@"车辆类型:%@",
                                vehicleInfo.cls.integerValue == 3 ? @"泵车" : @"罐车"];
            if (_vehicleInfo.cls.integerValue == 3)
            {
                cell.lbInfo.text = [NSString stringWithFormat:@"车辆种类:%@", [self getVehicleName:vehicleInfo]];
            }
            else
            {
                cell.lbInfo.text = [NSString stringWithFormat:@"运载量:%.1lf", vehicleInfo.weight];
            }
            return cell;
        }//fi (0 == indexPath.section)
        
    }//fi (_bindVehicle)
    else
    {
        RentVehicleInfo *vehicleInfo = _arrayVehicle[indexPath.row];
        
        RentVehicleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[RentVehicleInfoCell identifier]];
        
        if (!cell)
        {
            cell = [RentVehicleInfoCell cellFromNib];
        }
        
        cell.lbPlate.text = [NSString stringWithFormat:@"车牌号:%@", vehicleInfo.plateNum];
        cell.lbType.text = [NSString stringWithFormat:@"车辆类型:%@",
                            vehicleInfo.cls.integerValue == 3 ? @"泵车" : @"罐车"];
        
        if (vehicleInfo.cls.integerValue == 3)
        {
            cell.lbInfo.text = [NSString stringWithFormat:@"车辆种类:%@", [self getVehicleName:vehicleInfo]];
        }
        else
        {
            cell.lbInfo.text = [NSString stringWithFormat:@"运载量:%.1lf立方米", vehicleInfo.weight];
        }
        return cell;
    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bindVehicle)
    {
        if (0 == indexPath.section)
        {
            return [KeyValueCell cellHeight];
        }
        else
        {
            return [RentVehicleInfoCell cellHeight];
        }
    }
    else
    {
        return [RentVehicleInfoCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_bindVehicle)
    {
        return 30;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!_bindVehicle)
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 30)];
    
    view.backgroundColor = [Utils getColorByRGB:@"#cccccc"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    
    label.center = CGPointMake(60, 15);
    
    [view addSubview:label];
    
    if (0 == section)
    {
        label.text = @"我的车辆";
    }
    else
    {
        label.text = @"其它车辆";
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_bindVehicle)
    {
        if (1 == indexPath.section)
        {
            [self pushToDetail:_arrayVehicle[indexPath.row]];
        }
    }
    else
    {
        [self pushToDetail:_arrayVehicle[indexPath.row]];
    }
}

- (void)pushToDetail:(RentVehicleInfo *)vehicleInfo
{
    VehicleInfoController *controller = [[VehicleInfoController alloc] init];
    controller.vehicleInfo = vehicleInfo;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end


