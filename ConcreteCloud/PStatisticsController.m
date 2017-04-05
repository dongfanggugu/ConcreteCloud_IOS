//
//  PStatisticsController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/7.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PStatisticsController.h"
#import "SupplierListRequest.h"
#import "SupplierListResponse.h"
#import "SupplierInfo.h"
#import "ListDialogView.h"
#import "PStatisticsRequest.h"
#import "PStatisticsResponse.h"
#import "PStatisticsInfo.h"


#define YESTODAY @"1"
#define MONTH @"2"
#define YEAR @"3"

#pragma mark - PStatisticsCell

@interface PStatisticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbGoods;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@end

@implementation PStatisticsCell



@end


#pragma mark - PSStaisticsController

@interface PStatisticsController()<ListDialogViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSupplier;

@property (weak, nonatomic) IBOutlet UIButton *btnYesterday;

@property (weak, nonatomic) IBOutlet UIButton *btnMonth;

@property (weak, nonatomic) IBOutlet UIButton *btnYear;

@property (strong, nonatomic) NSString *curSupplierId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<PStatisticsInfo *> *arrayData;

@end

@implementation PStatisticsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"原材统计"];
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initData
{
    _curSupplierId = @"";
    
    _arrayData = [[NSArray alloc] init];
}

- (void)initView
{
    _btnSupplier.layer.masksToBounds = YES;
    _btnSupplier.layer.borderWidth = 2;
    _btnSupplier.layer.cornerRadius = 12.5;
    _btnSupplier.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnYesterday.layer.masksToBounds = YES;
    _btnYesterday.layer.borderWidth = 2;
    _btnYesterday.layer.cornerRadius = 12.5;
    _btnYesterday.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnMonth.layer.masksToBounds = YES;
    _btnMonth.layer.borderWidth = 2;
    _btnMonth.layer.cornerRadius = 12.5;
    _btnMonth.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    _btnYear.layer.masksToBounds = YES;
    _btnYear.layer.borderWidth = 2;
    _btnYear.layer.cornerRadius = 12.5;
    _btnYear.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;
    
    [_btnSupplier addTarget:self action:@selector(onClickSupplier) forControlEvents:UIControlEventTouchUpInside];
    [_btnYesterday addTarget:self action:@selector(onClickYesterday) forControlEvents:UIControlEventTouchUpInside];
    [_btnMonth addTarget:self action:@selector(onClickMonth) forControlEvents:UIControlEventTouchUpInside];
    [_btnYear addTarget:self action:@selector(onClickYear) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
}

- (void)onClickSupplier
{
    [self getSupplierList];
}

- (void)onClickYesterday
{
    [self getStatistics:YESTODAY];
}

- (void)onClickMonth
{
    [self getStatistics:MONTH];
}

- (void)onClickYear
{
    [self getStatistics:YEAR];
}


#pragma mark - Net request

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


- (void)getStatistics:(NSString *)type
{
    PStatisticsRequest *request = [[PStatisticsRequest alloc] init];
    request.branchId = [[Config shareConfig] getBranchId];
    request.type = type;
    
    request.supplierId = _curSupplierId;
    
    __weak PStatisticsController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_STATISTICS parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               PStatisticsResponse *response = [[PStatisticsResponse alloc] initWithDictionary:responseObject];
                               weakSelf.arrayData = response.body.list;
                               [weakSelf.tableView reloadData];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    [_btnSupplier setTitle:content forState:UIControlStateNormal];
    _curSupplierId = key;
}


#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"p_statistics_cell"];
    
    if (nil == cell)
    {
        cell = [[PStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"p_statistics_cell"];
    }
    
    
    PStatisticsInfo *info = _arrayData[indexPath.row];
    cell.lbGoods.text = [NSString stringWithFormat:@"商品:%@", info.goodsName];
    cell.lbAmount.text = [NSString stringWithFormat:@"数量:%.2lf吨", info.number];
    
    return cell;
}

@end
