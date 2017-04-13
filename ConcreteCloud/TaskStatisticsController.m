//
//  TaskStatisticsController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskStatisticsController.h"
#import "TaskStatisticsHeadView.h"
#import "QueryView.h"
#import "TaskStatisticsRequest.h"
#import "TaskStatisticsResponse.h"
#import "KeyValueCell.h"
#import "DatePickerDialog.h"

@interface TaskStatisticsController()<UITableViewDelegate, UITableViewDataSource, TaskStatisticsHeadViewDelegate,
                                    QueryViewDelegate, DatePickerDialogDelegate>
{
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) QueryView *queryView;

@property (strong, nonatomic) UILabel *lbTotalNum;

@property (strong, nonatomic) UILabel *lbTotalWeight;

@property (strong, nonatomic) TaskStatisticsInfo *statisticsInfo;

@property (weak, nonatomic) UITextField *tfTemp;

@end


@implementation TaskStatisticsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"任务统计"];
    [self initView];
}


- (void)initView
{
    TaskStatisticsHeadView *headView = [TaskStatisticsHeadView viewFromNib];
    headView.delegate = self;
    headView.frame = CGRectMake(0, 94, self.view.frame.size.width, 80);
    
    _queryView = [QueryView viewFromNib];
    _queryView.delegate = self;
    _queryView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height,
                                  self.view.frame.size.width, 60);
    
    [self.view addSubview:headView];
    [self.view addSubview:_queryView];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width,
                                                               self.view.frame.size.height, self.view.frame.size.width,
                                                               self.view.frame.size.height - 174)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *lbNumKey = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbNumKey.font = [UIFont systemFontOfSize:14];
    lbNumKey.textAlignment = NSTextAlignmentCenter;
    lbNumKey.text = @"累计车次";
    lbNumKey.center = CGPointMake(46, 20);
    
    _lbTotalNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _lbTotalNum.font = [UIFont systemFontOfSize:14];
    _lbTotalNum.textAlignment = NSTextAlignmentCenter;
    _lbTotalNum.center = CGPointMake(106, 20);
    
    UILabel *lbWeightKey = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    lbWeightKey.font = [UIFont systemFontOfSize:14];
    lbWeightKey.textAlignment = NSTextAlignmentCenter;
    lbWeightKey.text = @"累计方量";
    lbWeightKey.center = CGPointMake(166, 20);
    
    _lbTotalWeight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _lbTotalWeight.font = [UIFont systemFontOfSize:14];
    _lbTotalWeight.textAlignment = NSTextAlignmentCenter;
    _lbTotalWeight.center = CGPointMake(226, 20);
    
    [infoView addSubview:lbNumKey];
    [infoView addSubview:_lbTotalNum];
    [infoView addSubview:lbWeightKey];
    [infoView addSubview:_lbTotalWeight];
    
    _tableView.tableHeaderView = infoView;
    
}

#pragma mark - TaskStatisticsHeadViewDelegate

- (void)onClickMonth
{
    
    CGRect frame = CGRectMake(0, 174, self.view.frame.size.width,
                              self.view.frame.size.height - 174);
    _tableView.frame = frame;
    
    CGRect frameQuery = CGRectMake(self.view.frame.size.width, self.view.frame.size.height,
                                   self.view.frame.size.width, 60);
    _queryView.frame = frameQuery;
    
    [self getStatistics:MONTH start:nil end:nil];
}


- (void)onClickYear
{
    
    CGRect frame = CGRectMake(0, 174, self.view.frame.size.width,
                              self.view.frame.size.height - 174);
    _tableView.frame = frame;
    
    CGRect frameQuery = CGRectMake(self.view.frame.size.width, self.view.frame.size.height,
                                   self.view.frame.size.width, 60);
    _queryView.frame = frameQuery;
    
    [self getStatistics:YEAR start:nil end:nil];
}

- (void)onClickCustom
{
    
    CGRect frame = CGRectMake(0, 234, self.view.frame.size.width,
                              self.view.frame.size.height - 234);
    _tableView.frame = frame;
    
    CGRect frameQuery = CGRectMake(0, 174, self.view.frame.size.width, 60);
    _queryView.frame = frameQuery;
}

#pragma mark - QueryViewDelegate

- (void)onClickQueryStart:(NSString *)start end:(NSString *)end
{
    if ([start isEqualToString:QV_TF_INIT])
    {
        [HUDClass showHUDWithLabel:@"请选择起始日期" view:self.view];
        return;
    }
    
    if ([end isEqualToString:QV_TF_INIT])
    {
        [HUDClass showHUDWithLabel:@"请选择截止日期" view:self.view];
        return;
    }
    
    [self getStatistics:CUSTOM start:start end:end];
}

- (void)onSelTo:(UITextField *)tfTo
{
    _tfTemp = tfTo;
    
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    [dialog setDateMode];
    dialog.delegate = self;
    [dialog show];
}

- (void)onSelFrom:(UITextField *)tfFrom
{
    _tfTemp = tfFrom;
    
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    [dialog setDateMode];
    dialog.delegate = self;
    [dialog show];
}

#pragma mark - DatePickerDelegate

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [format stringFromDate:date];
    _tfTemp.text = dateStr;
}

#pragma mark - Network Request

- (void)getStatistics:(Statistics_Type)type start:(NSString *)start end:(NSString *)end
{
    TaskStatisticsRequest *request = [[TaskStatisticsRequest alloc] init];
    
    request.type = [NSString stringWithFormat:@"%ld", type];
    
    if (type == CUSTOM)
    {
        request.startDate = start;
        request.endDate = [NSString stringWithFormat:@"%@ 23:59:59", end];
    }
    
    [[HttpClient shareClient] view:self.view post:URL_DRIVER_STATISTICS parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        TaskStatisticsResponse *response = [[TaskStatisticsResponse alloc] initWithDictionary:responseObject];
    
        _statisticsInfo = [response getStatisticsInfo];
        _lbTotalNum.text = [NSString stringWithFormat:@"%ld", _statisticsInfo.count];
        _lbTotalWeight.text = [NSString stringWithFormat:@"%.1lf", _statisticsInfo.weight];
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
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:[KeyValueCell getIdentifier]];
    
    if (!cell)
    {
        cell = [KeyValueCell viewFromNib];
    }
    
    if (0 == indexPath.row)
    {
        cell.lbKey.text = @"0-5公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count0, _statisticsInfo.weight0];
    }
    else if (1 == indexPath.row)
    {
        cell.lbKey.text = @"5-10公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count5, _statisticsInfo.weight5];
    }
    else if (2 == indexPath.row)
    {
        cell.lbKey.text = @"10-15公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count10, _statisticsInfo.weight10];
    }
    else if (3 == indexPath.row)
    {
        cell.lbKey.text = @"15-20公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count15, _statisticsInfo.weight15];
    }
    else if (4 == indexPath.row)
    {
        cell.lbKey.text = @"20-25公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count20, _statisticsInfo.weight20];
    }
    else if (5 == indexPath.row)
    {
        cell.lbKey.text = @"25-30公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count25, _statisticsInfo.weight25];
    }
    else if (6 == indexPath.row)
    {
        cell.lbKey.text = @"30-35公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count30, _statisticsInfo.weight30];
    }
    else if (7 == indexPath.row)
    {
        cell.lbKey.text = @"35-40公里";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count35, _statisticsInfo.weight35];
    }
    else if (8 == indexPath.row)
    {
        cell.lbKey.text = @"40公里及以上";
        
        cell.lbValue.text = [NSString stringWithFormat:@"累计 车次:%ld  方量:%.1lf",
                             _statisticsInfo.count40, _statisticsInfo.weight40];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
