//
//  HzsVehicleListController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsVehicleListController.h"
#import "RentVehicleInfo.h"
#import "HzsVehicleListRequest.h"
#import "RentVehicleListResponse.h"
#import "HzsTankerInfoCell.h"

@interface HzsVehicleListController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<RentVehicleInfo *> *arrayVehicle;

@end


@implementation HzsVehicleListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_vehicleType == TANKER)
    {
        [self setNaviTitle:@"搅拌站罐车"];
    }
    else
    {
        [self setNaviTitle:@"搅拌站泵车"];
    }
    [self initData];
    [self initView];
    [self getVehicle];
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
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Network Request

- (void)getVehicle
{
    HzsVehicleListRequest *request = [[HzsVehicleListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.cls = [NSString stringWithFormat:@"%ld", _vehicleType];
    
    [[HttpClient shareClient] view:self.view post:URL_HZS_VEHICEL parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        RentVehicleListResponse *response = [[RentVehicleListResponse alloc] initWithDictionary:responseObject];
        [_arrayVehicle addObjectsFromArray:[response getRentVehicleList]];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark -  UITableViewDataSource

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
    
    RentVehicleInfo *info = _arrayVehicle[indexPath.row];
    
    _lbVehicle.text = info.plateNum;
    
    if (_vehicleType == TANKER)
    {
        _lbWeight.text = [NSString stringWithFormat:@"%.1lf立方米", info.weight];
        
        [[Config shareConfig] setLastVehicle:info.plateNum];
        [[Config shareConfig] setLastVehicleId:info.vehicleId];
        [[Config shareConfig] setLastVehicleLoad:[NSString stringWithFormat:@"%.1lf", info.weight]];
    }
    else
    {
        [[Config shareConfig] setLastPump:info.plateNum];
        [[Config shareConfig] setLastPumpId:info.vehicleId];
    }

    [self.navigationController popViewControllerAnimated:YES];
}
@end
