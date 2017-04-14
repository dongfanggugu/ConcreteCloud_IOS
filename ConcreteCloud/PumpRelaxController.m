//
//  PumpRelaxController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PumpRelaxController.h"
#import "KeyValueCell.h"
#import "DOrderInfo.h"
#import "DOrderRequest.h"
#import "DOrderListResponse.h"
#import "ListDialogView.h"
#import "TaluoduDivInfo.h"
#import "KeyValueBtnCell.h"
#import "HzsVehicleListController.h"
#import "HzsAddTaskRequest.h"
#import "HzsAddTaskResponse.h"

#define SITE_INIT @"点击选择工程"

#define PART_INIT @"点击选择浇筑部位"

@interface PumpRelaxController()<UITableViewDelegate, UITableViewDataSource, ListDialogViewDelegate>
{
    NSMutableArray<DOrderInfo *> *_arrayOrder;
}

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UILabel *lbSite;

@property (weak, nonatomic) UILabel *lbPart;

@property (weak, nonatomic) UILabel *lbVehicle;

@end

@implementation PumpRelaxController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData
{
    _arrayOrder = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                               self.view.frame.size.height)];
    [self.view addSubview:_tableView];
    
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.backgroundColor = [Utils getColorByRGB:@"#2ecc71"];
    [btn setTitle:@"启程" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footView;
    
    btn.center = CGPointMake(self.view.frame.size.width / 2, 40);
    [footView addSubview:btn];
}

- (void)clickStart
{
    if (![[Config shareConfig] getOperable]) {
        [HUDClass showHUDWithText:@"您还未上班,无法启运"];
        return;
    }
    
    [self startUp];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"搅拌站";
        cell.lbValue.text = [[Config shareConfig] getBranchName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (1 == indexPath.row) {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"工程";
        cell.lbValue.text = SITE_INIT;
        
        _lbSite = cell.lbValue;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (2 == indexPath.row) {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = PART_INIT;
        
        _lbPart = cell.lbValue;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (3 == indexPath.row) {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = @"";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (4 == indexPath.row) {
        KeyValueBtnCell *cell = [KeyValueBtnCell cellFromNib];
        cell.lbKey.text = @"车辆";
        cell.lbValue.text = [[Config shareConfig] getLastPump];
        
        _lbVehicle = cell.lbValue;
        
        __weak typeof (self) weakSelf = self;
        [cell addOnClickListener:^{
            
            if (![[Config shareConfig] getOperable]) {
                [HUDClass showHUDWithText:@"您还未上班,无法选择车辆"];
                return;
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onClickVehicleModify:type:)]) {
                [weakSelf.delegate onClickVehicleModify:weakSelf.lbVehicle type:PUMP];
            }
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark -- Network Request

- (void)getOrders
{
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_TANKER_ORDERS parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
        [_arrayOrder removeAllObjects];
        [_arrayOrder addObjectsFromArray:[response getOrderList]];
        [self showProjectListDialogView];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)startUp
{
    if ([_lbSite.text isEqualToString:SITE_INIT]) {
        [HUDClass showHUDWithLabel:@"请先选择工程" view:self.view];
        return;
    }
    
    if ([_lbPart.text isEqualToString:PART_INIT]) {
        [HUDClass showHUDWithLabel:@"请先选择浇筑部位" view:self.view];
        return;
    }
    
    if (0 == _lbVehicle.text.length) {
        [HUDClass showHUDWithLabel:@"请先选择车辆" view:self.view];
        return;
    }
    
    
    NSString *site = _lbSite.text;
    NSString *part = _lbPart.text;
    
    NSString *orderId = @"";
    for (DOrderInfo *info in _arrayOrder) {
        if ([site isEqualToString:info.siteName]
            && [part isEqualToString:info.castingPart]) {
            orderId = info.orderId;
            break;
        }
    }
    
    if (0 == orderId.length) {
        [HUDClass showHUDWithLabel:@"无法获取混凝土订单,请再次确认工程和浇筑部位选择是否正确" view:self.view];
        return;
    }
    
    HzsAddTaskRequest *request = [[HzsAddTaskRequest alloc]init];
    request.hzsOrderId = orderId;
    request.vehicleId = [[Config shareConfig] getLastPumpId];
    
    [[HttpClient shareClient] view:self.view post:URL_ADD_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        HzsAddTaskResponse *response = [[HzsAddTaskResponse alloc] initWithDictionary:responseObject];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickStartUp:)]) {
            [_delegate onClickStartUp:[response getHzsTask]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}


- (void)showProjectListDialogView
{
    ListDialogView *listDialog = [ListDialogView viewFromNib];
    
    NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (DOrderInfo *info in _arrayOrder) {
        [dic setObject:info.siteName forKey:info.siteName];
    }
    
    NSArray *arr = [dic allValues];
    
    for (NSString *str in arr) {
        
        TaluoduDivInfo *data = [[TaluoduDivInfo alloc] initWithKey:str content:str];
        [array addObject:data];
        
    }
    
    
    [listDialog setData:array];
    listDialog.tag = 1001;
    
    listDialog.delegate = self;
    [listDialog show];
}

- (void)showPartListDialogView
{
    KeyValueCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *site = cell.lbValue.text;
    
    if ([site isEqualToString:SITE_INIT])
    {
        [HUDClass showHUDWithLabel:@"请先选择工程" view:self.view];
        return;
    }
    
    ListDialogView *listDialog = [ListDialogView viewFromNib];
    
    NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
    
    for (DOrderInfo *info in _arrayOrder)
    {
        if ([info.siteName isEqualToString:site])
        {
            TaluoduDivInfo *data = [[TaluoduDivInfo alloc] initWithKey:info.intensityLevel content:info.castingPart];
            [array addObject:data];
        }
    }
    [listDialog setData:array];
    listDialog.tag = 1002;
    
    listDialog.delegate = self;
    
    [listDialog show];
}

#pragma mark -- ListDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
}

- (void)onSelectDialogTag:(NSInteger)tag content:(NSString *)content
{
    
}

- (void)onSelectDialogTag:(NSInteger)tag key:(NSString *)key content:(NSString *)content
{
    if (1001 == tag) {
        KeyValueCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.lbValue.text = content;
        
        KeyValueCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell2.lbValue.text = PART_INIT;
        
        KeyValueCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell3.lbValue.text = @"";
        
    } else if (1002 == tag) {
        KeyValueCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.lbValue.text = content;
        
        KeyValueCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell2.lbValue.text = key;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (1 == indexPath.row) {
        
        if (![[Config shareConfig] getOperable]) {
            [HUDClass showHUDWithText:@"您还未上班,无法操作"];
            return;
        }
        
        [self getOrders];
        
    } else if (2 == indexPath.row) {
        
        if (![[Config shareConfig] getOperable]) {
            [HUDClass showHUDWithText:@"您还未上班,无法操作"];
            return;
        }
        
        [self showPartListDialogView];
    }
}

@end

