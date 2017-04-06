//
//  TankerRelaxController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TankerRelaxController.h"
#import "KeyValueCell.h"
#import "DOrderInfo.h"
#import "DOrderRequest.h"
#import "DOrderListResponse.h"
#import "ListDialogView.h"
#import "TaluoduDivInfo.h"
#import "KeyValueBtnCell.h"
#import "HzsVehicleListController.h"
#import "DialogEditView.h"
#import "HzsAddTaskRequest.h"
#import "HzsAddTaskResponse.h"
#import "Location.h"


#define SITE_INIT @"点击选择工程"

#define PART_INIT @"点击选择浇筑部位"

@interface TankerRelaxController()<UITableViewDelegate, UITableViewDataSource, ListDialogViewDelegate,
                                    DialogEditViewDelegate>
{
    NSMutableArray<DOrderInfo *> *_arrayOrder;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) UILabel *lbSite;

@property (weak, nonatomic) UILabel *lbPart;

@property (weak, nonatomic) UILabel *lbVehicle;

@property (weak, nonatomic) UILabel *lbLoad;

@property (strong, nonatomic) MBProgressHUD *locationHUD;

@end

@implementation TankerRelaxController

- (void)dealloc
{
    NSLog(@"TankerRelaxController dealloc");
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    btn.backgroundColor = [Utils getColorByRGB:@"#2ecc71"];
    [btn setTitle:@"启运" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footView;
    
    btn.center = CGPointMake(self.view.frame.size.width / 2, 40);
    [footView addSubview:btn];
    
}

- (void)clickStart
{
    [self startCheck];
}


/**
 起运流程：1.检测订单信息选择是否完整 2.启动定位 3.定位完成后从服务器获取距离限制 4.检测启运距离限制 5.启运
 */
- (void)startCheck
{
    if ([_lbSite.text isEqualToString:SITE_INIT])
    {
        [HUDClass showHUDWithLabel:@"请先选择工程" view:self.view];
        return;
    }
    
    if ([_lbPart.text isEqualToString:PART_INIT])
    {
        [HUDClass showHUDWithLabel:@"请先选择浇筑部位" view:self.view];
        return;
    }
    
    if (0 == _lbVehicle.text.length)
    {
        [HUDClass showHUDWithLabel:@"请先选择车辆" view:self.view];
        return;
    }
    
    if (0 == _lbLoad.text.length || 0 == _lbLoad.text.floatValue)
    {
        [HUDClass showHUDWithLabel:@"请正确填写运载量" view:self.view];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationComplete:)
                                                 name:Location_Complete object:nil];
    
    [[Location sharedLocation] startLocationService];
    
    _locationHUD = [HUDClass showLoadingHUD:self.view];
    
}


- (void)startUp:(CLLocationCoordinate2D)coor limit:(NSInteger)limit
{
    
    NSString *site = _lbSite.text;
    NSString *part = _lbPart.text;
    
    NSString *orderId = nil;
    
    for (DOrderInfo *info in _arrayOrder)
    {
        if ([site isEqualToString:info.siteName]
            && [part isEqualToString:info.castingPart])
        {
            orderId = info.orderId;
            break;
        }
    }
    
    if (0 == orderId.length)
    {
        [HUDClass showHUDWithLabel:@"无法获取混凝土订单,请再次确认工程和浇筑部位选择是否正确" view:self.view];
        return;
    }
    
    //检测启运时和搅拌站距离
    CLLocationCoordinate2D coorHzs;
    coorHzs.latitude = [[Config shareConfig] getLat];
    coorHzs.longitude = [[Config shareConfig] getLng];
    
    NSInteger dis = (NSInteger)[Location distancePoint:coorHzs with:coor];
    
    if (dis > limit)
    {
        [HUDClass showHUDWithLabel:@"您距离搅拌站距离过远，请靠近搅拌站后再次启运" view:self.view];
        return;
    }
    
    HzsAddTaskRequest *request = [[HzsAddTaskRequest alloc]init];
    request.hzsOrderId = orderId;
    request.vehicleId = [[Config shareConfig] getLastVehicleId];
    request.number = [[[Config shareConfig] getLastVehicleLoad] floatValue];
    
    [[HttpClient shareClient] view:self.view post:URL_ADD_TASK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        HzsAddTaskResponse *response = [[HzsAddTaskResponse alloc] initWithDictionary:responseObject];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onClickStartUp:)])
        {
            [_delegate onClickStartUp:[response getHzsTask]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - 定位完成

- (void)onLocationComplete:(NSNotification *)notify
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Location_Complete object:nil];
    
    [HUDClass hideLoadingHUD:_locationHUD];
    
    NSDictionary *userInfo = notify.userInfo;
    
    if (!userInfo)
    {
        [HUDClass showHUDWithLabel:@"定位失败,请检测您的网络和设置是否开启定位" view:self.view];
        return;
    }
    
    BMKUserLocation *userLocation = userInfo[User_Location];
    
    [self getDistance:userLocation.location.coordinate];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"搅拌站";
        cell.lbValue.text = [[Config shareConfig] getBranchName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"工程";
        cell.lbValue.text = SITE_INIT;
        
        _lbSite = cell.lbValue;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = PART_INIT;
        
        _lbPart = cell.lbValue;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = @"";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueBtnCell *cell = [KeyValueBtnCell cellFromNib];
        cell.lbKey.text = @"车辆";
        cell.lbValue.text = [[Config shareConfig] getLastVehicle];
        
        _lbVehicle = cell.lbValue;
        
        __weak typeof (self) weakSelf = self;
        [cell addOnClickListener:^{
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onClickVehicleModify:weight:type:)])
            {
                [weakSelf.delegate onClickVehicleModify:weakSelf.lbVehicle weight:weakSelf.lbLoad type:TANKER];
            }
            
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        KeyValueBtnCell *cell = [KeyValueBtnCell cellFromNib];
        cell.lbKey.text = @"运载量";
        
        NSString *load = [[Config shareConfig] getLastVehicleLoad];
        
        if (load) {
            
            cell.lbValue.text = [NSString stringWithFormat:@"%@立方米", load];
            
        } else {
             cell.lbValue.text = @"";
        }
       
        
        
        _lbLoad = cell.lbValue;
        
        [cell addOnClickListener:^{
            DialogEditView *view = [DialogEditView viewFromNib];
            view.delegate = self;
            
            CGRect frame = CGRectMake(0, -94, self.view.frame.size.width, self.view.frame.size.height + 94 + 49);
            view.frame = frame;
            
            [self.view addSubview:view];
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark -- Network Request

- (void)getDistance:(CLLocationCoordinate2D)location
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"hzsId"] = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_START_UP_LIMIT parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger limit = [[[responseObject objectForKey:@"body"] objectForKey:@"region"] integerValue];
        [self startUp:location limit:limit];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)getOrders
{
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_TANKER_ORDERS parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
        [_arrayOrder removeAllObjects];
        [_arrayOrder addObjectsFromArray:[response getOrderList]];
        [self showProjectListDialogView];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)showProjectListDialogView
{
    ListDialogView *listDialog = [ListDialogView viewFromNib];
    
    NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (DOrderInfo *info in _arrayOrder)
    {
        [dic setObject:info.siteName forKey:info.siteName];
    }
    
    NSArray *arr = [dic allValues];
    
    for (NSString *str in arr)
    {
    
        TaluoduDivInfo *data = [[TaluoduDivInfo alloc] initWithKey:str content:str];
        [array addObject:data];

    }
    
    
    [listDialog setData:array];
    listDialog.tag = 1001;
    
    listDialog.delegate = self;
    [self.view addSubview:listDialog];
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
    
    [self.view addSubview:listDialog];
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
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row)
    {
        [self getOrders];
    }
    else if (2 == indexPath.row)
    {
        [self showPartListDialogView];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 80;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}

#pragma mark - DialogEditViewDelegate

- (void)onOKDismiss:(NSString *)content
{
    [[Config shareConfig] setLastVehicleLoad:content];
    _lbLoad.text = [NSString stringWithFormat:@"%@立方米", content];;
}

@end
