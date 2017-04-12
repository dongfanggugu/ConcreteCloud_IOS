//
//  SupStaffAddController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "SupStaffAddController.h"
#import "KeyEditCell.h"
#import "SelectableCell.h"
#import "SelectableData.h"

@interface SupStaffAddController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) KeyEditCell *cellName;

@property (weak, nonatomic) KeyEditCell *cellTel;

@end

@implementation SupStaffAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"人员添加"];
    [self initNavRightWithText:@"确定"];
    [self initView];
}

- (void)onClickNavRight
{
    KeyEditCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *name = cell1.tfValue.text;
    
    if (0 == name.length) {
        [HUDClass showHUDWithText:@"请填写姓名"];
        return;
    }
    
    SelectableCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *sex = cell2.getContentValue;
    
    KeyEditCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *tel = cell3.tfValue.text;
    
    if (0 == tel.length) {
        [HUDClass showHUDWithText:@"请填写电话"];
        return;
    }
    
    SelectableCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *role = cell4.getContentValue;
    
    NSString *roleId = nil;
    if ([role isEqualToString:@"司机"]) {
        roleId = SUP_DRIVER;
    } else {
        roleId = SUP_CLERK;
    }
    
    KeyEditCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *duty = cell5.tfValue.text;
    
    if (0 == duty.length) {
        [HUDClass showHUDWithText:@"请填写职务"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"name"] = name;
    
    param[@"sex"] = [sex isEqualToString:@"男"] ? @"1" : @"0";
    
    param[@"tel"] = tel;
    
    param[@"roleIds"] = roleId;
    
    param[@"duty"] = duty;
    
    param[@"isOrder"] = @"1";
    
    param[@"supplierId"] = [[Config shareConfig] getBranchId];
    
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_ADD_STAFF parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSString *msg = [NSString stringWithFormat:@"登录用户名:%@", tel];
                               [HUDClass showHUDWithText:msg];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        
        if (_cellName) {
            return _cellName;
            
        } else {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"姓名";
            cell.tfValue.placeholder = @"姓名";
            
            _cellName = cell;
            
            cell.tfValue.keyboardType = UIKeyboardTypeDefault;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    } else if (1 == indexPath.row) {
        
        SelectableData *data1 = [[SelectableData alloc] initWithKey:@"" content:@"女"];
        SelectableData *data2 = [[SelectableData alloc] initWithKey:@"" content:@"男"];
        NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
        [array addObject:data1];
        [array addObject:data2];
        
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.lbKey.text = @"性别";
        [cell setView:self.view data:[array copy]];
        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (2 == indexPath.row) {
        if (_cellTel) {
            return _cellTel;
            
        } else {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            cell.lbKey.text = @"电话";
            cell.tfValue.placeholder = @"电话";
            _cellTel = cell;
            
            cell.tfValue.keyboardType = UIKeyboardTypeNumberPad;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }
        
    } else if (3 == indexPath.row) {
        SelectableData *data1 = [[SelectableData alloc] initWithKey:@"" content:@"司机"];
        SelectableData *data2 = [[SelectableData alloc] initWithKey:@"" content:@"接单员"];
        NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
        [array addObject:data1];
        [array addObject:data2];
        
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.lbKey.text = @"角色";
        [cell setView:self.view data:[array copy]];
        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else if (4 == indexPath.row) {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"职务";
        cell.tfValue.placeholder = @"职务";
        
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
