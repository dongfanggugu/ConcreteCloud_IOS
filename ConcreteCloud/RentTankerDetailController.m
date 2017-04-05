//
//  RentTankerDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentTankerDetailController.h"
#import "KeyValueCell.h"
#import "ACheckVideoCell.h"
#import "VideoPlayerController.h"

@interface RentTankerDetailController()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}

@end


@implementation RentTankerDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"任务详情"];
    [self initView];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (TANKER == _vehicleType)
    {
        return 10;
    }
    else
    {
        return 9;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"运输单时间";
        cell.lbValue.text = _trackInfo.startTime;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"搅拌站";
        cell.lbValue.text = _trackInfo.hzs_Order.hzsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车牌号";
        cell.lbValue.text = _trackInfo.plateNum;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"司机";
        cell.lbValue.text = [NSString stringWithFormat:@"%@ %@", _trackInfo.driverName, _trackInfo.driverTel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"运输量";
        cell.lbValue.text = [NSString stringWithFormat:@"%ld立方米", _trackInfo.number];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (5 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"工程";
        cell.lbValue.text = _trackInfo.hzs_Order.siteName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (6 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"工程地址";
        cell.lbValue.text = _trackInfo.hzs_Order.siteAddress;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (7 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = _trackInfo.hzs_Order.castingPart;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (8 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = _trackInfo.hzs_Order.intensityLevel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (9 == indexPath.row)
    {
        ACheckVideoCell *cell = [ACheckVideoCell cellFromNib];
        
        cell.lbKey.text = @"浇筑视频";
        cell.lbInfo.text = @"";
        
        cell.url = _trackInfo.spotVideo;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (7 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
        VideoPlayerController *controller = [board instantiateViewControllerWithIdentifier:@"video_player_controller"];
        controller.urlStr = _trackInfo.spotVideo;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (9 == indexPath.row)
    {
        return [ACheckVideoCell cellHeight];
    }
    else if (6 == indexPath.row)
    {
        return [KeyValueCell cellHeightWithContent:_trackInfo.hzs_Order.siteAddress];
    }
    
    return 44;
}

@end
