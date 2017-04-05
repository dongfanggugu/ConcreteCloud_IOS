//
//  RentVehicleController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleController.h"
#import "RentVehicleListResponse.h"
#import "RentVehicleRequest.h"
#import "HzsTankerInfoCell.h"


@interface RentVehicleController()<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<RentVehicleInfo *> *arrayVehicle;

@end


@implementation RentVehicleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_vehicleType == TANKER)
    {
        [self setNaviTitle:@"租赁罐车"];
    }
    else
    {
        [self setNaviTitle:@"租赁泵车"];
    }
    [self initData];
    [self initView];
    [self getVehicles];
}

- (void)initData
{
    _arrayVehicle = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    RentVehicleRequest *request = [[RentVehicleRequest alloc] init];
    request.type = [[Config shareConfig] getType];
    request.leaseId = [[Config shareConfig] getBranchId];
    request.cls = [NSString stringWithFormat:@"%ld", _vehicleType];
    
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
    
    if (_vehicleType == TANKER)
    {
        cell.lbPlate.text = info.plateNum;
        cell.lbLoad.text = [NSString stringWithFormat:@"运载量:%.1lf立方米", info.weight];
    }
    else
    {
        cell.lbPlate.text = info.plateNum;
        
        NSInteger pumpType = info.additionalInfo.type.integerValue;
        
        if (1 == pumpType)
        {
            cell.lbType.text = @"汽车泵";
            cell.lbLoad.text = [NSString stringWithFormat:@"臂长:%.1lf米",
                                info.additionalInfo.armLength];
        }
        else if (2 == pumpType)
        {
            cell.lbType.text = @"车载泵";
            cell.lbLoad.text = [NSString stringWithFormat:@"理论输送方量:%.1lf立方米",
                                info.additionalInfo.flow];
        }
        else if (3 == pumpType)
        {
            cell.lbType.text = @"拖式泵";
            cell.lbLoad.text = [NSString stringWithFormat:@"理论输送方量:%.1lf立方米",
                                info.additionalInfo.flow];
        }
    }
    
    return cell;
}

#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HzsTankerInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(onSelectVehicle:)])
    {
        [_delegate onSelectVehicle:_arrayVehicle[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
