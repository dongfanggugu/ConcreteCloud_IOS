//
//  ACheckDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACheckDetailController.h"
#import "KeyValueCell.h"
#import "ACheckVideoCell.h"
#import "VideoPlayerController.h"
#import "VideoRecordController.h"

@interface ACheckDetailController()<UITableViewDelegate, UITableViewDataSource, VideoRecordControllerDelegate>
{
    __weak IBOutlet UITableView *_tableView;
}

@end


@implementation ACheckDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"任务详情"];
    
    if (HZS == _checkType && [[Config shareConfig] getOperable]) {
        [self initNavRightWithText:@"出站视频"];
    }
    [self initView];
}

- (void)onClickNavRight
{
    VideoRecordController *controller = [[VideoRecordController alloc] init];
    controller.videoKey = _trackInfo.trackId;
    controller.delegate = self;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (HZS == _checkType)
    {
        return 6;
    }
    else if (SITE == _checkType)
    {
        return 7;
    }
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"司机";
        cell.lbValue.text = _trackInfo.driverName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"工程名称";
        cell.lbValue.text = _trackInfo.hzs_Order.siteName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"商品类型";
        cell.lbValue.text = _trackInfo.hzs_Order.goodsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = _trackInfo.hzs_Order.intensityLevel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = _trackInfo.hzs_Order.castingPart;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"运输量";
        cell.lbValue.text = [NSString stringWithFormat:@"%ld", _trackInfo.number];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (6 == indexPath.row)
    {
        ACheckVideoCell *cell = [ACheckVideoCell cellFromNib];
        
        cell.lbKey.text = @"出站检验视频";
        cell.lbInfo.text = [NSString stringWithFormat:@"检验员:%@",
                            0 == _trackInfo.examName.length ? @"--" : _trackInfo.examName];
        
        cell.url = _trackInfo.examVideo;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (7 == indexPath.row)
    {
        ACheckVideoCell *cell = [ACheckVideoCell cellFromNib];
        cell.lbKey.text = @"工地检验视频";
        cell.lbInfo.text = [NSString stringWithFormat:@"检验员:%@", _trackInfo.driverName];
        cell.url = _trackInfo.spotVideo;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (6 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
        VideoPlayerController *controller = [board instantiateViewControllerWithIdentifier:@"video_player_controller"];
        controller.urlStr = _trackInfo.examVideo;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (7 == indexPath.row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
        VideoPlayerController *controller = [board instantiateViewControllerWithIdentifier:@"video_player_controller"];
        controller.urlStr = _trackInfo.spotVideo;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (6 == indexPath.row || 7 == indexPath.row)
    {
        return [ACheckVideoCell cellHeight];
    }
    
    return 44;
}


#pragma mark - VideoRecordControllerDelegate

- (void)onUploadVideo:(NSString *)url videoKey:(NSString *)videoKey
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"examVideo"] = url;
    dic[@"hzsOrderProcessId"] = videoKey;
    
    [[HttpClient shareClient] view:self.view post:URL_A_CHECK_OUT parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"检验视频上传成功" view:self.view];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
