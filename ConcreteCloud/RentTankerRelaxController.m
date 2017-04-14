//
//  RentTankerRelaxController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentTankerRelaxController.h"
#import "KeyValueCell.h"
#import "SelectableCell.h"
#import "KeyValueBtnCell.h"
#import "DialogEditView.h"
#import "DOrderRequest.h"
#import "DOrderInfo.h"
#import "DOrderListResponse.h"
#import "TaluoduDivInfo.h"
#import "HzsInfo.h"
#import "HzsListResponse.h"
#import "RentTankerProcessController.h"
#import "HzsAddTaskRequest.h"
#import "HzsAddTaskResponse.h"
#import "Location.h"


#define HZS_INIT @"点击选择搅拌站"

#define SITE_INIT @"点击选择工程"

#define PART_INIT @"点击选择浇筑部位"


@interface RentTankerRelaxController()<UITableViewDelegate, UITableViewDataSource, DialogEditViewDelegate,
                                        ListDialogViewDelegate>
{
    NSMutableArray<DOrderInfo *> *_arrayOrder;
    
    UIViewController *controller;
}

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UILabel *lbHzs;

@property (weak, nonatomic) UILabel *lbSite;

@property (weak, nonatomic) UILabel *lbPart;

@property (weak, nonatomic) UILabel *lbLoad;

@property (copy, nonatomic) NSString *hzsId;

@property (strong, nonatomic) MBProgressHUD *locationHUD;

@end


@implementation RentTankerRelaxController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)initData
{
    _arrayOrder = [NSMutableArray array];
    
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.backgroundColor = [Utils getColorByRGB:@"#2ecc71"];
    [btn setTitle:@"启运" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footView;
    
    btn.center = CGPointMake(self.screenWidth / 2, 40);
    [footView addSubview:btn];
}


//起运流程：1.检测订单信息选择是否完整 2.启动定位 3.定位完成后从服务器获取距离限制 4.检测启运距离限制 5.启运
- (void)clickStart
{
    if (![[Config shareConfig] getOperable]) {
        [HUDClass showHUDWithText:@"您还未上班或者车没有置忙,无法启运"];
        return;
    }
    
    if ([_lbHzs.text isEqualToString:HZS_INIT]) {
        [HUDClass showHUDWithText:@"请先选择搅拌站"];
        return;
    }
    
    if ([_lbSite.text isEqualToString:SITE_INIT]) {
        [HUDClass showHUDWithText:@"请先选择工程"];
        return;
    }
    
    if ([_lbPart.text isEqualToString:PART_INIT]) {
        [HUDClass showHUDWithText:@"请先选择浇筑部位"];
        return;
    }
    
    if (0 == _lbLoad.text.length || 0 == _lbLoad.text.floatValue) {
        [HUDClass showHUDWithText:@"请正确填写运载量"];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:)
                                                 name:Location_Complete object:nil];

    [[Location sharedLocation] startLocationService];
    _locationHUD = [HUDClass showLoadingHUD:self.view];
}

#pragma mark - 定位完成

- (void)onLocationComplete:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Location_Complete object:nil];
    
    [HUDClass hideLoadingHUD:_locationHUD];
    
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo) {
        [HUDClass showHUDWithText:@"定位失败,请检测您的网络和设置是否开启定位"];
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    //获取订单信息
    NSString *site = _lbSite.text;
    NSString *part = _lbPart.text;
    
    DOrderInfo *orderInfo = nil;;
    
    for (DOrderInfo *info in _arrayOrder) {
        if ([site isEqualToString:info.siteName]
            && [part isEqualToString:info.castingPart]) {
            orderInfo = info;
            break;
        }
    }
    
    if (!orderInfo) {
        [HUDClass showHUDWithText:@"无法获取混凝土订单,请再次确认工程和浇筑部位选择是否正确"];
        return;
    }
    
    [self getDistance:userLocation.location.coordinate order:orderInfo];
}

- (void)startUp:(CLLocationCoordinate2D)coor limit:(NSInteger)limit order:(DOrderInfo *)orderInfo
{
    //检测启运时和搅拌站距离
    CLLocationCoordinate2D coorHzs;
    coorHzs.latitude = orderInfo.hzsLat;
    coorHzs.longitude = orderInfo.hzsLng;
    
    NSInteger dis = (NSInteger)[Location distancePoint:coorHzs with:coor];
    
    if (dis > limit)
    {
        [HUDClass showHUDWithText:@"您距离搅拌站距离过远，请靠近搅拌站后再次启运"];
        return;
    }
    
    HzsAddTaskRequest *request = [[HzsAddTaskRequest alloc]init];
    request.hzsOrderId = orderInfo.orderId;
    request.vehicleId = _vehicleInfo.vehicleId;
    request.number = _lbLoad.text.floatValue;
    
    [[HttpClient shareClient] view:self.view post:URL_ADD_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        HzsAddTaskResponse *response = [[HzsAddTaskResponse alloc] initWithDictionary:responseObject];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickStartUp:)])
        {
            [_delegate onClickStartUp:[response getHzsTask]];
        }
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"搅拌站";
        cell.lbValue.text = HZS_INIT;
        
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
        cell.lbKey.text = @"运载量";
        cell.lbValue.text = [[Config shareConfig] getLastVehicleLoad];
        
        if (_vehicleInfo) {
            cell.lbValue.text = [NSString stringWithFormat:@"%.1lf", _vehicleInfo.weight];
        }
        
        _lbLoad = cell.lbValue;
        
        __weak typeof (self) weakSelf = self;
        
        [cell addOnClickListener:^{
            
            if (![[Config shareConfig] getOperable]) {
                [HUDClass showHUDWithText:@"您还未上班或者车没有置忙,无法修改运载量"];
                return;
            }
            
            DialogEditView *view = [DialogEditView viewFromNib];
            view.delegate = weakSelf;
            
            [view show];
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)getDistance:(CLLocationCoordinate2D)location order:(DOrderInfo *)orderInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"hzsId"] = orderInfo.hzsId;
    
    [[HttpClient shareClient] view:self.view post:URL_START_UP_LIMIT parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger limit = [[[responseObject objectForKey:@"body"] objectForKey:@"region"] integerValue];
        [self startUp:location limit:limit order:orderInfo];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.row) {
        
        if (![[Config shareConfig] getOperable]) {
            [HUDClass showHUDWithText:@"您还未上班或者车没有置忙,无法操作"];
            return;
        }
        
        [self getHzs];
        
    } else if (1 == indexPath.row) {
        
        if (![[Config shareConfig] getOperable]) {
            [HUDClass showHUDWithText:@"您还未上班或者车没有置忙,无法操作"];
            return;
        }
        [self getOrders];
        
    } else if (2 == indexPath.row) {
        if (![[Config shareConfig] getOperable]) {
            [HUDClass showHUDWithText:@"您还未上班或者车没有置忙,无法操作"];
            return;
        }
        
        [self showPartListDialogView];
    }
}

#pragma mark - DialogEditViewDelegate

- (void)onOKDismiss:(NSString *)content
{
    _lbLoad.text = content;
}


#pragma mark -- Network Request

- (void)getOrders
{
    
    if (0 == _hzsId.length) {
        [HUDClass showHUDWithText:@"请先选择搅拌站"];
        return;
    }
    
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.hzsId = _hzsId;
    
    [[HttpClient shareClient] view:self.view post:URL_TANKER_ORDERS parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
        [_arrayOrder removeAllObjects];
        [_arrayOrder addObjectsFromArray:[response getOrderList]];
        [self showProjectListDialogView];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getHzs
{
    [[HttpClient shareClient] view:self.view post:URL_RENT_GET_HZS parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        HzsListResponse *response = [[HzsListResponse alloc] initWithDictionary:responseObject];
        [self showHzsListDialogView:[response getHzsList]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)showHzsListDialogView:(NSArray<HzsInfo *> *)arrayHzs
{
    ListDialogView *listDialog = [ListDialogView viewFromNib];
    
    [listDialog setData:arrayHzs];
    listDialog.tag = 1003;
    
    listDialog.delegate = self;
    [listDialog show];
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
    
    if ([site isEqualToString:SITE_INIT]) {
        [HUDClass showHUDWithText:@"请先选择工程"];
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
    if (1001 == tag)
    {
        KeyValueCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.lbValue.text = content;
        
        KeyValueCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell2.lbValue.text = PART_INIT;
        
        KeyValueCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell3.lbValue.text = @"";
    }
    else if (1002 == tag)
    {
        KeyValueCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.lbValue.text = content;
        
        KeyValueCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell2.lbValue.text = key;
    }
    else if (1003 == tag)
    {
        KeyValueCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.lbValue.text = content;
        _hzsId = key;
        
        KeyValueCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell1.lbValue.text = SITE_INIT;
        
        KeyValueCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell2.lbValue.text = PART_INIT;
        
        KeyValueCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell3.lbValue.text = @"";
    }
}

#pragma mark - RentTankerProcessControllerDelegate

- (void)onGetVehicle:(RentVehicleInfo *)vehicleInfo
{
    _vehicleInfo = vehicleInfo;
    _lbLoad.text = [NSString stringWithFormat:@"%.1lf", vehicleInfo.weight];
}

@end
