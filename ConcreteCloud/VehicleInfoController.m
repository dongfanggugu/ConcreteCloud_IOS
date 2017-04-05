//
//  VehicleInfoController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleInfoController.h"
#import "KeyValueCell.h"
#import "RentWorkStateResponse.h"
#import "RentVehicleDelRequest.h"

@interface VehicleInfoController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *lbNoVehicle;

@property (assign, nonatomic) BOOL isTanker;

@end

@implementation VehicleInfoController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆信息"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_delete"]];
    [self initView];
}


- (void)setVehicleInfo:(RentVehicleInfo *)vehicleInfo
{
    _vehicleInfo = vehicleInfo;
    
    NSInteger type = _vehicleInfo.cls.integerValue;
    
    if (3 == type)
    {
        _isTanker = NO;
    }
    else
    {
        _isTanker = YES;
    }
}

- (void)onClickNavRight
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要删除车辆?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self delVehicle];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initView
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

- (void)delVehicle
{
    
    RentVehicleDelRequest *request = [[RentVehicleDelRequest alloc] init];
    request.vehicleId = _vehicleInfo.vehicleId;
    
    [[HttpClient shareClient] view:self.view post:URL_RENT_DEL parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [HUDClass showHUDWithLabel:@"车辆删除成功" view:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_isTanker)
    {
        return 4;
    }
    else
    {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    }
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
