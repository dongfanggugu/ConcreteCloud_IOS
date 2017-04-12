//
//  RenterPumpListController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RenterPumpListController.h"
#import "SPumpListResponse.h"
#import "PumpInfoCell.h"
#import "PumpTrailController.h"
#import "RentVehicleListResponse.h"
#import "SPumpListResponse.h"

@interface RenterPumpListController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray<RentVehicleInfo *> *_arrayPump;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RenterPumpListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"泵车轨迹"];
    [self initData];
    [self initView];
    [self getPumps];
}

- (void)initData
{
    _arrayPump = [NSMutableArray array];
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

- (NSString *)getPumpName:(NSInteger)type
{
    switch (type) {
        case 1:
            return @"汽车泵";
            
        case 2:
            return @"车载泵";
            
        case 3:
            return @"拖式泵";
    }
    
    return @"汽车泵";
}

#pragma mark - Network Request

- (void)getPumps
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"id"] = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_RENTER_GET_PUMP parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RentVehicleListResponse *response = [[RentVehicleListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayPump addObjectsFromArray:[response getRentVehicleList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - UITableVeiwDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayPump.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PumpInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[PumpInfoCell identifier]];
    
    if (!cell) {
        cell = [PumpInfoCell cellFromView];
    }
    
    RentVehicleInfo *info = _arrayPump[indexPath.row];
    cell.lbHzs.text = info.plateNum;
    cell.lbDate.text = @"";
    cell.lbDriver.text = @"车辆种类:泵车";
    
    cell.lbTel.text = @"";
    cell.lbLevel.text = @"";
    
    cell.lbPart.text = [NSString stringWithFormat:@"车辆类型:%@", [self getPumpName:info.additionalInfo.type.integerValue]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PumpInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentVehicleInfo *info = _arrayPump[indexPath.row];
    
    [self getTaskInfo:info.vehicleId];
}

- (void)getTaskInfo:(NSString *)vehicelId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"id"] = vehicelId;
    
    [[HttpClient shareClient] view:self.view post:URL_A_TASK_BY_VEHICLE_ID parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               SPumpListResponse *response = [[SPumpListResponse alloc] initWithDictionary:responseObject];
                               DTrackInfo *trackInfo = [[response getPumpList] objectAtIndex:0];
                               [self pumpTrail:trackInfo];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

- (void)pumpTrail:(DTrackInfo *)trackInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Site" bundle:nil];
    PumpTrailController *controller = [board instantiateViewControllerWithIdentifier:@"pump_trail_controller"];
    controller.trackInfo = trackInfo;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
