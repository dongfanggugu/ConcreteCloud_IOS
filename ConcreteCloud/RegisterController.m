//
//  RegisterController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterController.h"
#import "KeyEditCell.h"
#import "KeyEditBtnCell.h"
#import "LocationViewController.h"

typedef NS_ENUM(NSInteger, Register_Type)
{
    Reg_Project,
    Reg_Supplier,
    Reg_Renter
    
};


@interface RegisterController()<UITableViewDelegate, UITableViewDataSource, LocationControllerDelegate>
{
    //标记第一行的cell,避免第一行被滚动消失后再次出现数据丢失的问题
    KeyEditCell *_disAppearCell;
}

@property (assign, nonatomic) Register_Type registerType;

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;



@end


@implementation RegisterController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"注册"];
    [self initNavRightWithText:@"完成"];
    [self showProtocolDialog];
}

- (void)onClickNavRight
{
    if (Reg_Project == _registerType)
    {
        [self registerProject];
    }
    else if (Reg_Supplier == _registerType)
    {
        [self registerSupplier];
    }
    else if (Reg_Renter == _registerType)
    {
        [self registerRenter];
    }
}

- (void)setRegisterType:(Register_Type)registerType
{
    _registerType = registerType;
    
    [self initTableView];
}

- (void)showProtocolDialog
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"用户注册协议"
                                                                        message:REGISTER_PROTOCOL preferredStyle:UIAlertControllerStyleAlert];
    
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showFunctionDialog];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:controller.view
                                                                  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f constant:300];

    [controller.view addConstraint:constraint];
    
    [self presentViewController:controller animated:YES completion:^(){
        
//        __weak UIView *view = controller.view;
//        NSString *height = @"V:[view(==300)]";
//        
//        NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
//        controller.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [controller.view addConstraints:array];
    }];
}

- (void)showFunctionDialog
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"注册"
                                                                        message:@"选择注册的角色" preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"工程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.registerType = Reg_Project;
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"供应商" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.registerType = Reg_Supplier;
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"租赁商" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.registerType = Reg_Renter;
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - 处理UITableView数据源和代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (Reg_Project == _registerType || Reg_Supplier == _registerType)
    {
        return 7;
    }
    else if (Reg_Renter == _registerType)
    {
        return 4;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Reg_Project == _registerType)
    {
        if (0 == indexPath.row)
        {
            if (_disAppearCell)
            {
                return _disAppearCell;
            }
            
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"工程名称";
            cell.tfValue.placeholder = @"工程名称";
            
            
            _disAppearCell = cell;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"施工单位";
            cell.tfValue.placeholder = @"施工单位";
            
            return cell;
        }
        else if (2 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"管理员姓名";
            cell.tfValue.placeholder = @"管理员姓名";
            
            return cell;
        }
        else if (3 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"管理员电话";
            cell.tfValue.placeholder = @"管理员电话";
            
            return cell;
        }
        else if (4 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"负责人姓名";
            cell.tfValue.placeholder = @"负责人姓名";
            
            return cell;
        }
        else if (5 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"负责人电话";
            cell.tfValue.placeholder = @"负责人电话";
            
            return cell;
        }
        else if (6 == indexPath.row)
        {
            KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
            cell.lbKey.text = @"地址";
            cell.tfValue.placeholder = @"地址关键字";
            
            __weak typeof(cell) weakCell = cell;
            [cell setOnClickBtnListener:^{
                
                NSString *address = weakCell.tfValue.text;
                
                if (0 == address.length)
                {
                    [HUDClass showHUDWithLabel:@"请填写您的地址关键字" view:self.view];
                    return;
                }
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                LocationViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_location"];
               
                controller.delegate = self;
                controller.address = weakCell.tfValue.text;
                
                [self.navigationController pushViewController:controller animated:YES];
            }];
            
            return cell;
        }
        
    }
    else if (Reg_Supplier == _registerType)
    {
        if (0 == indexPath.row)
        {
            
            if (_disAppearCell)
            {
                return _disAppearCell;
            }
            
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"供应商名称";
            cell.tfValue.placeholder = @"供应商名称";
            
            _disAppearCell = cell;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"所属公司";
            cell.tfValue.placeholder = @"所属公司";
            
            return cell;
        }
        else if (2 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"管理员姓名";
            cell.tfValue.placeholder = @"管理员姓名";
            
            return cell;
        }
        else if (3 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"管理员电话";
            cell.tfValue.placeholder = @"管理员电话";
            
            return cell;
        }
        else if (4 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"业务员姓名";
            cell.tfValue.placeholder = @"业务员姓名";
            
            return cell;
        }
        else if (5 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"业务员电话";
            cell.tfValue.placeholder = @"业务员电话";
            
            return cell;
        }
        else if (6 == indexPath.row)
        {
            KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
            cell.lbKey.text = @"地址";
            cell.tfValue.placeholder = @"地址关键字";
            
            __weak typeof(cell) weakCell = cell;
            [cell setOnClickBtnListener:^{
                
                NSString *address = weakCell.tfValue.text;
                
                if (0 == address.length)
                {
                    [HUDClass showHUDWithLabel:@"请填写您的地址关键字" view:self.view];
                    return;
                }
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                LocationViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_location"];
                
                controller.delegate = self;
                controller.address = weakCell.tfValue.text;
                
                [self.navigationController pushViewController:controller animated:YES];
            }];
            
            return cell;
        }
    }
    else if (Reg_Renter == _registerType)
    {
        if (0 == indexPath.row)
        {
            
            if (_disAppearCell)
            {
                return _disAppearCell;
            }
            
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"租赁商名称";
            cell.tfValue.placeholder = @"租赁商名称";
            
            _disAppearCell = cell;
            
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"管理员姓名";
            cell.tfValue.placeholder = @"管理员姓名";
            
            return cell;
        }
        else if (2 == indexPath.row)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"管理员电话";
            cell.tfValue.placeholder = @"管理员电话";
            
            return cell;
        }
        else if (3 == indexPath.row)
        {
            KeyEditBtnCell *cell = [KeyEditBtnCell cellFromNib];
            cell.lbKey.text = @"地址";
            cell.tfValue.placeholder = @"地址关键字";
            
            __weak typeof(cell) weakCell = cell;
            [cell setOnClickBtnListener:^{
                
                NSString *address = weakCell.tfValue.text;
                
                if (0 == address.length)
                {
                    [HUDClass showHUDWithLabel:@"请填写您的地址关键字" view:self.view];
                    return;
                }
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
                LocationViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_location"];
                
                controller.delegate = self;
                controller.address = weakCell.tfValue.text;
                
                [self.navigationController pushViewController:controller animated:YES];
            }];
            
            return cell;
        }
    }
    
    return [KeyEditCell viewFromNib];
}

#pragma mark - 在地图标记完地图之后的回调

- (void)onChooseAddressLat:(CGFloat)lat lng:(CGFloat)lng
{
    _lat = lat;
    _lng = lng;
    
    [HUDClass showHUDWithLabel:@"请完善您的具体地址" view:self.view];
}

#pragma mark - 注册


/**
 工程工地注册
 */
- (void)registerProject
{
    KeyEditCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *project = cell0.tfValue.text;
    
    if (0 == project.length)
    {
        [HUDClass showHUDWithLabel:@"请填写工程名称" view:self.view];
        return;
    }
    
    KeyEditCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *company = cell1.tfValue.text;
    
    if (0 == company.length)
    {
        [HUDClass showHUDWithLabel:@"请填写施工单位" view:self.view];
        return;
    }
    
    KeyEditCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *admin = cell2.tfValue.text;
    
    if (0 == admin.length)
    {
        [HUDClass showHUDWithLabel:@"请填写管理员姓名" view:self.view];
        return;
    }
    
    KeyEditCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *adminTel = cell3.tfValue.text;
    
    if (0 == adminTel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写管理员电话" view:self.view];
        return;
    }
    
    KeyEditCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *manager = cell4.tfValue.text;
    
    if (0 == manager.length)
    {
        [HUDClass showHUDWithLabel:@"请填写负责人姓名" view:self.view];
        return;
    }
    
    KeyEditCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *managerTel = cell5.tfValue.text;
    
    if (0 == managerTel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写负责人电话" view:self.view];
        return;
    }
    
    KeyEditBtnCell *cell6 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *address = cell6.tfValue.text;
    
    if (0 == address.length)
    {
        [HUDClass showHUDWithLabel:@"请填写工程地址" view:self.view];
        return;
    }
    
    if (_lat <= 0 || _lng <= 0)
    {
        [HUDClass showHUDWithLabel:@"请先点击定位图标在地图中选择您的工程位置" view:self.view];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //工程名称
    param[@"name"] = project;
    
    //施工单位
    param[@"companyName"] = company;
    
    //地址
    param[@"address"] = address;
    param[@"lat"] = [NSNumber numberWithFloat:_lat];
    param[@"lng"] = [NSNumber numberWithFloat:_lng];
    
    //工程负责人
    param[@"contactsUser"] = manager;
    param[@"tel"] = managerTel;
    
    //工程管理员
    param[@"salesmanUser"] = admin;
    param[@"salesmanTel"] = adminTel;
    
    [[HttpClient shareClient] view:self.view post:URL_SITE_REGISTER parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


- (void)registerSupplier
{
    KeyEditCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *supplier = cell0.tfValue.text;
    
    if (0 == supplier.length)
    {
        [HUDClass showHUDWithLabel:@"请填写供应商名称" view:self.view];
        return;
    }
    
    KeyEditCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *company = cell1.tfValue.text;
    
    if (0 == company.length)
    {
        [HUDClass showHUDWithLabel:@"请填写所属公司" view:self.view];
        return;
    }
    
    KeyEditCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *admin = cell2.tfValue.text;
    
    if (0 == admin.length)
    {
        [HUDClass showHUDWithLabel:@"请填写管理员姓名" view:self.view];
        return;
    }
    
    KeyEditCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *adminTel = cell3.tfValue.text;
    
    if (0 == adminTel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写管理员电话" view:self.view];
        return;
    }
    
    KeyEditCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *manager = cell4.tfValue.text;
    
    if (0 == manager.length)
    {
        [HUDClass showHUDWithLabel:@"请填写业务员姓名" view:self.view];
        return;
    }
    
    KeyEditCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *managerTel = cell5.tfValue.text;
    
    if (0 == managerTel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写业务员电话" view:self.view];
        return;
    }
    
    KeyEditBtnCell *cell6 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *address = cell6.tfValue.text;
    
    if (0 == address.length)
    {
        [HUDClass showHUDWithLabel:@"请填写供应商地址" view:self.view];
        return;
    }
    
    if (_lat <= 0 || _lng <= 0)
    {
        [HUDClass showHUDWithLabel:@"请先点击定位图标在地图中选择您的供应商位置" view:self.view];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //供应商名称
    param[@"name"] = supplier;
    
    //所属公司
    param[@"companyName"] = company;
    
    //地址
    param[@"address"] = address;
    param[@"lat"] = [NSNumber numberWithFloat:_lat];
    param[@"lng"] = [NSNumber numberWithFloat:_lng];
    
    //业务员
    param[@"contactsUser"] = manager;
    param[@"tel"] = managerTel;
    
    //管理员
    param[@"salesmanUser"] = admin;
    param[@"salesmanTel"] = adminTel;
    
    [[HttpClient shareClient] view:self.view post:URL_SUPPLIER_REGISTER parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)registerRenter
{
    KeyEditCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *renter = cell0.tfValue.text;
    
    if (0 == renter.length)
    {
        [HUDClass showHUDWithLabel:@"请填写租赁商名称" view:self.view];
        return;
    }
    
    KeyEditCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *admin = cell1.tfValue.text;
    
    if (0 == admin.length)
    {
        [HUDClass showHUDWithLabel:@"请填写管理员姓名" view:self.view];
        return;
    }
    
    KeyEditCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *adminTel = cell2.tfValue.text;
    
    if (0 == adminTel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写管理员电话" view:self.view];
        return;
    }
    
    KeyEditBtnCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *address = cell3.tfValue.text;
    
    if (0 == address.length)
    {
        [HUDClass showHUDWithLabel:@"请填写租赁商地址" view:self.view];
        return;
    }
    
    if (_lat <= 0 || _lng <= 0)
    {
        [HUDClass showHUDWithLabel:@"请先点击定位图标在地图中选择您的租赁商位置" view:self.view];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //租赁商名称
    param[@"name"] = renter;
    
    //管理员
    param[@"contactsUser"] = admin;
    param[@"tel"] = adminTel;
    
    
    [[HttpClient shareClient] view:self.view post:URL_RENTER_REGISTER parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];

}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
