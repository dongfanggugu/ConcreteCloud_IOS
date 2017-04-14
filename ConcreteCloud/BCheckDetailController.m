//
//  BCheckDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCheckDetailController.h"
#import "KeyValueCell.h"
#import "ACheckVideoCell.h"
#import "VideoRecordController.h"

@interface BCheckDetailController()<UITableViewDelegate, UITableViewDataSource, VideoRecordControllerDelegate>
{
    //公共属性起始index
    NSInteger _dyIndex;
}

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) ACheckVideoCell *checkeVideoCell;

@end


@implementation BCheckDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"任务信息"];
        
    if (!_isHistory && [[Config shareConfig] getOperable]) {
        [self initNavRightWithText:@"进站视频"];
    }
    
    
    [self initView];
}

- (void)onClickNavRight
{
    VideoRecordController *controller = [[VideoRecordController alloc] init];
    controller.videoKey = _trackInfo.processId;
    controller.delegate = self;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width,
                                                               self.view.frame.size.height - 94 - 49)];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    NSString *role = [[Config shareConfig] getRole];
    
    if (!_isHistory && [role isEqualToString:HZS_B_CHECKER]) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        
        btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
        [btn setTitle:@"退货" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView.tableFooterView = footView;
        
        btn.center = CGPointMake(self.view.frame.size.width / 2, 40);
        [footView addSubview:btn];
    }
    
}



- (void)reject
{
    if (0 == _trackInfo.confirmVideo.length)
    {
        [HUDClass showHUDWithLabel:@"请先拍摄检验视频" view:self.view];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"processId"] = _trackInfo.processId;
    
    [[HttpClient shareClient] view:self.view post:URL_B_CHECK_REJECT parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"退货成功" view:self.view];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - VideoRecordControllerDelegate

- (void)onUploadVideo:(NSString *)url videoKey:(NSString *)videoKey
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"name"] = [[Config shareConfig] getName];
    dic[@"examVideo"] = url;
    dic[@"supplierOrderProcessId"] = videoKey;
    
    __weak typeof (self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_B_CHECK_VIDEO parameters:dic
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"检验视频上传成功" view:self.view];
        weakSelf.checkeVideoCell.url = url;
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
    
    NSString *goods = _trackInfo.goodsName;
    
    if ([goods isEqualToString:OTHERS]) {
        _dyIndex = 5;
        
    } else if ([goods isEqualToString:WAIJIAJI]
             || [goods isEqualToString:KUANGFEN]
             || [goods isEqualToString:FENMEIHUI]) {
        _dyIndex = 6;
    }
    else
    {
        _dyIndex = 7;
    }
    
    return _dyIndex + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车牌号";
        cell.lbValue.text = _trackInfo.plateNum;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"司机";
        cell.lbValue.text = _trackInfo.driverName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"运输单号";
        cell.lbValue.text = _trackInfo.taskCode;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"供应商";
        cell.lbValue.text =  _trackInfo.supplierName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"货物";
        cell.lbValue.text = _trackInfo.goodsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        NSString *goods = _trackInfo.goodsName;
        if ([goods isEqualToString:SHIZI]
            || [goods isEqualToString:SHAZI]
            || [goods isEqualToString:SHUINI]
            || [goods isEqualToString:WAIJIAJI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"品种";
            cell.lbValue.text = _trackInfo.variety;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:KUANGFEN]
                 || [goods isEqualToString:FENMEIHUI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"等级标准";
            cell.lbValue.text = _trackInfo.standard;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (6 == indexPath.row)
    {
        NSString *goods = _trackInfo.goodsName;
        
        if ([goods isEqualToString:SHIZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"粒径规格";
            cell.lbValue.text = _trackInfo.kld;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:SHAZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"细度模数";
            cell.lbValue.text = _trackInfo.kld;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:SHUINI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"强度等级";
            cell.lbValue.text = _trackInfo.intensityLevel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    if (_dyIndex == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"毛重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.weight];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"皮重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.net];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"净重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.number];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (_dyIndex + 3 == indexPath.row)
    {
        ACheckVideoCell *cell = [ACheckVideoCell cellFromNib];
        
        _checkeVideoCell = cell;
        
        cell.lbKey.text = @"检验视频";
        
        if (_trackInfo.confirmVideo) {
            cell.url = _trackInfo.confirmVideo;
        }
        
        return cell;
    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dyIndex + 3 == indexPath.row)
    {
        
        return [ACheckVideoCell cellHeight];
    }
    else
    {
        return [KeyValueCell cellHeight];
    }
    
}

@end
