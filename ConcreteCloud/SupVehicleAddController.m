//
//  SupVehicleAddController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "SupVehicleAddController.h"
#import "KeyEditCell.h"
#import "SelectableCell.h"
#import "SelectableData.h"

@interface SupVehicleAddController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SupVehicleAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆添加"];
    [self initNavRightWithText:@"确定"];
    [self initView];
}

- (void)onClickNavRight
{
    KeyEditCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *plate = cell1.tfValue.text;
    
    if (0 == plate.length) {
        [HUDClass showHUDWithText:@"请填写车牌号码"];
        return;
    }
    
    KeyEditCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *load = cell2.tfValue.text;
    
    if (0 == load.length) {
        [HUDClass showHUDWithText:@"请填写运载量"];
        return;
    }
    
    SelectableCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *type = cell3.getContentValue;
    
    
    NSString *vehicleType = nil;
    
    if ([type isEqualToString:@"砂石运输车"]) {
        vehicleType = @"4";
        
    } else if ([type isEqualToString:@"外加剂运输车"]){
        vehicleType = @"5";
        
    } else {
        vehicleType = @"6";
    }
    

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"plateNum"] = plate;
    
    param[@"weight"] = load;
    
    param[@"cls"] = vehicleType;
    
    param[@"type"] = [[Config shareConfig] getType];
    
    param[@"contactsUser"] = [[Config shareConfig] getName];
    
    param[@"supplierId"] = [[Config shareConfig] getBranchId];
    
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_ADD_VEHICLE parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [HUDClass showHUDWithText:@"车辆添加成功"];
                               [self back];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"车牌号码";
        cell.tfValue.placeholder = @"车牌号码";
        
        cell.tfValue.keyboardType = UIKeyboardTypeDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (1 == indexPath.row) {
        
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"运载量";
        cell.tfValue.placeholder = @"运载量";
        
        cell.lbUnit.hidden = NO;
        
        cell.lbUnit.text = @"吨";
        
        cell.tfValue.keyboardType = UIKeyboardTypeDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (2 == indexPath.row) {
        SelectableData *data1 = [[SelectableData alloc] initWithKey:@"" content:@"砂石运输车"];
        SelectableData *data2 = [[SelectableData alloc] initWithKey:@"" content:@"外加剂运输车"];
        SelectableData *data3 = [[SelectableData alloc] initWithKey:@"" content:@"散装粉料运输车"];
        
        NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
        [array addObject:data1];
        [array addObject:data2];
        [array addObject:data3];
        
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.lbKey.text = @"车辆类型";
        [cell setView:self.view data:[array copy]];
        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
