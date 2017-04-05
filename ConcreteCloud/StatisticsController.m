//
//  StatisticsController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticsController.h"
#import "StatisticsSelView.h"
#import "PStatisticsRequest.h"
#import "PStatisticsResponse.h"
#import "StatisticsResponse.h"
#import "MoreCell.h"
#import "SupplierListRequest.h"
#import "SupplierListResponse.h"
#import "SupplierInfo.h"
#import "ProjectListResponse.h"

#define YESTODAY @"1"
#define MONTH @"2"
#define YEAR @"3"

@interface StatisticsController()<StatisticsSelViewDelegate, UITableViewDelegate, UITableViewDataSource,
                                ListDialogViewDelegate>

@property (strong, nonatomic) StatisticsSelView *selView;

@property (assign, nonatomic) NSInteger curSel;

@property (strong, nonatomic) NSString *curSupplierId;

@property (strong, nonatomic) NSString *curSiteId;

@property (strong, nonatomic) NSMutableArray<PStatisticsInfo *> *arrayBData;

@property (strong, nonatomic) TaskStatisticsInfo *aData;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation StatisticsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"混凝土统计" right:@"原材料统计"];
    
    [self initData];
    [self initView];
    
}


- (void)initData
{
    _curSel = 0;
    
    _curSupplierId = @"";
    
    _curSiteId = @"";
    
    _arrayBData = [NSMutableArray array];
    
}

- (void)initView
{
    _selView = [StatisticsSelView viewFromNib];
    
    CGRect frame = _selView.frame;
    frame.origin.x = 0;
    frame.origin.y = 94;
    frame.size.height = 80;
    frame.size.width = self.screenWidth;
    
    _selView.frame = frame;
    _selView.delegate = self;
    [self.view addSubview:_selView];
    
    [_selView.btnAgent setTitle:@"全部工地" forState:UIControlStateNormal];
    _selView.lbTip.text = @"混凝土订单统计";
    [_selView initBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94 + 80, self.screenWidth, self.screenHeight - 94 - 80 - 49)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];

}

- (void)onClickLeftSegment
{
    if (0 == _curSel)
    {
        return;
    }
    _curSel = 0;
    [_selView.btnAgent setTitle:@"全部工地" forState:UIControlStateNormal];
    _curSiteId = @"";
    _aData = nil;
    _selView.lbTip.text = @"混凝土订单统计";
    [_selView initBtn];
    
    [_tableView reloadData];
}

- (void)onClickRightSegment
{
    if (1 == _curSel)
    {
        return;
    }
    _curSel = 1;
    [_selView.btnAgent setTitle:@"全部供应商" forState:UIControlStateNormal];
    _curSupplierId = @"";
    [_arrayBData removeAllObjects];
    _selView.lbTip.text = @"原材料订单统计";
    [_selView initBtn];
    
    [_tableView reloadData];
}

#pragma mark - Network Request

- (void)getSupplierList
{
    SupplierListRequest *request = [[SupplierListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_GET_SUPPLIER parameters:[request toDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               SupplierListResponse *response = [[SupplierListResponse alloc] initWithDictionary:responseObject];
                               
                               //添加全部选项
                               NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                               [dic setObject:@"" forKey:@"supplierId"];
                               [dic setObject:@"全部" forKey:@"name"];
                               
                               SupplierInfo *info = [[SupplierInfo alloc] initWithDictionary:dic];
                               
                               NSMutableArray *array = [[NSMutableArray alloc] initWithArray:response.body];
                               [array insertObject:info atIndex:0];
                               
                               ListDialogView *dialog = [ListDialogView viewFromNib];
                               dialog.delegate = self;
                               [dialog setData:array];
                               [self.view addSubview:dialog];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}


- (void)getSiteList
{
    SupplierListRequest *request = [[SupplierListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_HZS_STA_SITE parameters:[request toDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               ProjectListResponse *response = [[ProjectListResponse alloc] initWithDictionary:responseObject];
                               
                               //添加全部选项
                               NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                               [dic setObject:@"" forKey:@"projectId"];
                               [dic setObject:@"全部" forKey:@"name"];
                               
                               ProjectInfo *info = [[ProjectInfo alloc] initWithDictionary:dic];
                               
                               NSMutableArray *array = [[NSMutableArray alloc] initWithArray:response.body];
                               [array insertObject:info atIndex:0];
                               
                               ListDialogView *dialog = [ListDialogView viewFromNib];
                               dialog.delegate = self;
                               [dialog setData:array];
                               [self.view addSubview:dialog];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}


- (void)getBStatistics:(NSString *)type
{
    PStatisticsRequest *request = [[PStatisticsRequest alloc] init];
    request.branchId = [[Config shareConfig] getBranchId];
    request.type = type;
    
    request.supplierId = _curSupplierId;
    
    [[HttpClient shareClient] view:self.view post:URL_P_STATISTICS parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               PStatisticsResponse *response = [[PStatisticsResponse alloc] initWithDictionary:responseObject];
                               [_arrayBData removeAllObjects];
                               [_arrayBData addObjectsFromArray:response.body.list];
                               [_tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

- (void)getAStatistics:(NSString *)type
{
    PStatisticsRequest *request = [[PStatisticsRequest alloc] init];
    request.branchId = [[Config shareConfig] getBranchId];
    request.type = type;
    
    request.siteId = _curSiteId;
    
    [[HttpClient shareClient] view:self.view post:URL_P_STATISTICS parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               StatisticsResponse *response = [[StatisticsResponse alloc] initWithDictionary:responseObject];
                               _aData = [response getAStatistics];
                               [_tableView reloadData];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == _curSel)
    {
        if (_aData)
        {
            return 2;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return _arrayBData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoreCell identifier]];
    
    if (nil == cell)
    {
        cell = [MoreCell cellFromNib];
    }
    
    if (0 == _curSel)
    {
        if (0 == indexPath.row)
        {
            NSInteger count = _aData.count;
            CGFloat weight = _aData.weight;
            cell.lbContent.text = [NSString stringWithFormat:@"累计车次:%ld    累计方量:%.1lf", count, weight];
        }
        else
        {
            NSInteger count = _aData.count0;
            CGFloat weight = _aData.weight0;
            cell.lbContent.text = [NSString stringWithFormat:@"退货车次:%ld    退货方量:%.1lf", count, weight];

        }
    }
    else
    {
        PStatisticsInfo *info = _arrayBData[indexPath.row];
        cell.lbContent.text = [NSString stringWithFormat:@"商品:%@    数量:%.2lf吨", info.goodsName, info.number];
    }
    
    return cell;
}

#pragma mark - StatisticsSelViewDelegate

- (void)onClickAgent
{
    if (0 == _curSel)
    {
        [self getSiteList];
    }
    else
    {
        [self getSupplierList];
    }
}

- (void)onClickYesterday
{
    if (0 == _curSel)
    {
        [self getAStatistics:YESTODAY];
    }
    else
    {
        [self getBStatistics:YESTODAY];
    }
}

- (void)onClickMonth
{
    if (0 == _curSel)
    {
        [self getAStatistics:MONTH];
    }
    else
    {
        [self getBStatistics:MONTH];
    }
}

- (void)onClickYear
{
    if (0 == _curSel)
    {
        [self getAStatistics:YEAR];
    }
    else
    {
        [self getBStatistics:YEAR];
    }
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    if (0 == _curSel)
    {
        [_selView.btnAgent setTitle:content forState:UIControlStateNormal];
        _curSiteId = key;
        _aData = nil;
        [_tableView reloadData];
    }
    else
    {
        [_selView.btnAgent setTitle:content forState:UIControlStateNormal];
        _curSupplierId = key;
        [_arrayBData removeAllObjects];
        [_tableView reloadData];
    }
}

@end
