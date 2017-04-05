//
//  SupVehicleDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupVehicleDetailController.h"
#import "KeyValueCell.h"

@interface SupVehicleDetailController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SupVehicleDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆信息"];
    [self initView];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueCell *cell = [KeyValueCell viewFromNib];
    
    if (0 == indexPath.row)
    {
        cell.lbKey.text = @"车牌号码";
        cell.lbValue.text = _vehicleInfo.plateNum;
    }
    else if (1 == indexPath.row)
    {
        cell.lbKey.text = @"运载量";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _vehicleInfo.weight];
    }
    else if (2 == indexPath.row)
    {
        cell.lbKey.text = @"车辆种类";
        cell.lbValue.text = [NSString stringWithFormat:@"%@", [self getVehicleName:_vehicleInfo.cls.integerValue]];
    }
       
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
