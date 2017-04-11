//
//  BCheckVideoController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCheckVideoController.h"
#import "ACheckVideoRequest.h"
#import "VideoListResponse.h"
#import "ACheckVideoInfoCell.h"

@interface BCheckVideoController()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSMutableArray<VideoInfo *> *_arrayVideo;
}

@end

@implementation BCheckVideoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"检验视频"];
    [self initView];
    [self initData];
    [self getVideo];
}


- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


- (void)initData
{
    _arrayVideo = [NSMutableArray array];
}


#pragma mark - Network Request

- (void)getVideo
{
    ACheckVideoRequest *request = [[ACheckVideoRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.type = @"supplier";
    
    [[HttpClient shareClient] view:self.view post:URL_A_CHECK_VIDEO parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        VideoListResponse *response = [[VideoListResponse alloc] initWithDictionary:responseObject];
        [_arrayVideo removeAllObjects];
        [_arrayVideo addObjectsFromArray:[response getVideoList]];
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
    return _arrayVideo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACheckVideoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ACheckVideoInfoCell identifier]];
    
    if (!cell)
    {
        cell = [ACheckVideoInfoCell cellFromNib];
    }
    VideoInfo *info = _arrayVideo[indexPath.row];
    
    NSString *plateNum = info.plateNum;
    NSString *driver = info.driverName;
    cell.lbPlateNum.text = [NSString stringWithFormat:@"%@ %@", plateNum, driver];
    
    cell.lbDate.text = info.upTime;
    
    NSString *goodsName = info.goodsName;
    NSString *standard = info.standard;
    cell.lbCurrent.text = [NSString stringWithFormat:@"商品:%@ %@", goodsName, standard];
    
    NSString *type = info.videoType;
    NSString *supplier = info.supplierName;
    cell.lbCurrent.text = [NSString stringWithFormat:@"%@视频 %@", type, supplier];
    
    NSString *checker = info.examName;
    NSString *code = info.taskCode;
    cell.lbChecker.text = [NSString stringWithFormat:@"检验员:%@ 运输单号:%@", checker, code];
    
    cell.urlStr = info.url;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ACheckVideoInfoCell cellHeight];
}

@end
