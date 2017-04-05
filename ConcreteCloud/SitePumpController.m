//
//  SitePumpController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SitePumpController.h"
#import "PumpListRequest.h"
#import "SPumpListResponse.h"
#import "PumpInfoCell.h"
#import "PumpTrailController.h"

@interface SitePumpController()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray<DTrackInfo *> *_arrayPump;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SitePumpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"泵车轨迹"];
    [self initData];
    [self initView];
    [self getPump];
}

- (void)initData
{
    _arrayPump = [NSMutableArray array];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Network Request

- (void)getPump
{
    PumpListRequest *request = [[PumpListRequest alloc] init];
    request.branchId = [[Config shareConfig] getBranchId];
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_PUMP_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {

        SPumpListResponse *response = [[SPumpListResponse alloc] initWithDictionary:responseObject];
        
        [_arrayPump addObjectsFromArray:[response getPumpList]];
        [weakSelf.tableView reloadData];
        
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
    
    if (!cell)
    {
        cell = [PumpInfoCell cellFromView];
    }
    
    DTrackInfo *info = _arrayPump[indexPath.row];
    cell.lbHzs.text = info.hzs_Order.hzsName;
    cell.lbDate.text = info.startTime;
    cell.lbDriver.text = [NSString stringWithFormat:@"司机:%@", info.driverName];
    cell.lbTel.text = info.driverTel;
    cell.lbPart.text = [NSString stringWithFormat:@"部位:%@", info.hzs_Order.castingPart];
    cell.lbLevel.text = [NSString stringWithFormat:@"强度:%@", info.hzs_Order.intensityLevel];
    
    return cell;
}

#pragma mark - UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PumpInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PumpTrailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"pump_trail_controller"];
    controller.trackInfo = _arrayPump[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
