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
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_delete"]];
    [self initView];
}

- (void)onClickNavRight
{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除车辆?"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteVehicle];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)deleteVehicle
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"id"] = _vehicleInfo.vehicleId;
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_DEL_VEHICLE parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [HUDClass showHUDWithText:@"车辆删除成功!"];
                               [self.navigationController popViewControllerAnimated:YES];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
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
