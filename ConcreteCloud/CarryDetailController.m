//
//  CarryDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarryDetailController.h"
#import "PProcessList.h"
#import "PProcessListRequest.h"
#import "Response+PProcessList.h"
#import "CarryInfoCell.h"
#import "VideoPlayerController.h"

@interface CarryDetailController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PProcessList *processInfo;

@end



@implementation CarryDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"运送详情"];
    [self initView];
    [self initData];
    [self getTask];
}

- (void)initData
{
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _tableView.allowsSelection = NO;
}

//获取运输信息
- (void)getTask
{
    PProcessListRequest *request = [[PProcessListRequest alloc] init];
    request.supplierId = _supplierId;
    request.supplierOrderId = _orderId;
    request.finish = @"2";
    
    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] view:nil post:URL_P_VEHICLE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.processInfo = [[ResponseDictionary alloc] getProcessList:[responseObject objectForKey:@"body"]];
        [weakSelf.tableView reloadData];
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
    return _processInfo.info.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[CarryInfoCell identifier]];
    
    if (!cell)
    {
        cell = [CarryInfoCell cellFromNib];
    }
    
    PTrackInfo *info = [_processInfo.info objectAtIndex:indexPath.row];
    
    cell.lbDate.text = info.startTime;
    cell.lbGoods.text = info.goodsName;
    cell.lbPlate.text = info.plateNum;
    
    cell.lbDriver.text = [NSString stringWithFormat:@"司机:%@ %@", info.driverName, info.tel];
    
    if (0 == info.weight || 0 == info.net || 0 == info.number)
    {
        cell.lbWeight.text = @"暂无称重结果";
    }
    else
    {
        cell.lbWeight.text = [NSString stringWithFormat:@"毛重:%.1lf 皮重:%.1lf 净重:%.1lf",
                              info.weight, info.net, info.number];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [cell setOnClickVideo:^{
        NSLog(@"click video")
        
        NSString *url = info.confirmVideo;
        if (0 == url.length)
        {
            [HUDClass showHUDWithLabel:@"暂无检验视频" view:weakSelf.view];
        }
        else
        {
            VideoPlayerController *controller = [weakSelf.storyboard
                                                 instantiateViewControllerWithIdentifier:@"video_player_controller"];
            controller.urlStr = url;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CarryInfoCell cellHeight];
}

@end
