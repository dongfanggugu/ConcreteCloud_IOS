//
//  SiteStaffAddController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteStaffAddController.h"
#import "SelectableData.h"
#import "SelectableCell.h"
#import "KeyEditCell.h"
#import "SiteStaffAddRequest.h"

@interface SiteStaffAddController()<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SiteStaffAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"人员添加 "];
    [self initNavRightWithText:@"确定"];
    [self initView];
}

- (void)onClickNavRight
{
    KeyEditCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *name = cell1.tfValue.text;
    
    if (0 == name.length)
    {
        [HUDClass showHUDWithLabel:@"请填写姓名" view:self.view];
        return;
    }
    
    SelectableCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *sex = cell2.getContentValue;
    
    KeyEditCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *age = cell3.tfValue.text;
    
    if (0 == age.length)
    {
        [HUDClass showHUDWithLabel:@"请填写年龄" view:self.view];
        return;
    }
    
    KeyEditCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *duty = cell4.tfValue.text;
    
    if (0 == duty.length)
    {
        [HUDClass showHUDWithLabel:@"请填写职务" view:self.view];
        return;
    }
    
    KeyEditCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *tel = cell5.tfValue.text;
    
    if (0 == tel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写电话" view:self.view];
        return;
    }
    
    SelectableCell *cell6 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *role = cell6.getContentValue;
    
    KeyEditCell *cell7 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *code = cell7.tfValue.text;
    
    if (0 == code.length)
    {
        [HUDClass showHUDWithLabel:@"请填写职工编号" view:self.view];
        return;
    }
    
    SelectableCell *cell8 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    NSString *operatable = cell8.getContentValue;
    
    SiteStaffAddRequest *request = [[SiteStaffAddRequest alloc] init];
    request.siteId = [[Config shareConfig] getBranchId];
    request.name = name;
    request.sex = [sex isEqualToString:@"男"] ? @"1" : @"0";
    request.age = [age integerValue];
    request.duty = duty;
    request.tel = tel;
    request.roleId = [role isEqualToString:@"管理员"] ? SITE_ADMIN : SITE_PURCHASER;
    request.code = code;
    request.isOrder = [operatable isEqualToString:@"是"] ? @"1" : @"0";
    
    [[HttpClient shareClient] view:self.view post:URL_SITE_STAFF_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [NSString stringWithFormat:@"登录用户名:%@", tel];
        [HUDClass showHUDWithLabel:msg view:self.view];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.5f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"姓名";
        cell.tfValue.placeholder = @"姓名";
        
        cell.tfValue.keyboardType = UIKeyboardTypeDefault;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (1 == indexPath.row)
    {
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
    }
    else if (2 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"年龄";
        cell.tfValue.placeholder = @"年龄";
        cell.tfValue.keyboardType = UIKeyboardTypeNumberPad;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
         return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"职务";
        cell.tfValue.placeholder = @"职务";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"电话";
        cell.tfValue.placeholder = @"电话";
        cell.tfValue.keyboardType = UIKeyboardTypePhonePad;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (5 == indexPath.row)
    {
        SelectableData *data1 = [[SelectableData alloc] initWithKey:@"" content:@"材料员/下单员"];
        SelectableData *data2 = [[SelectableData alloc] initWithKey:@"" content:@"管理员"];
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
    }
    else if (6 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.lbKey.text = @"职工编号";
        cell.tfValue.placeholder = @"职工编号";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (7 == indexPath.row)
    {
        SelectableData *data1 = [[SelectableData alloc] initWithKey:@"" content:@"是"];
        SelectableData *data2 = [[SelectableData alloc] initWithKey:@"" content:@"否"];
        NSMutableArray<id<ListDialogDataDelegate>> *array = [NSMutableArray array];
        [array addObject:data1];
        [array addObject:data2];
        
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.lbKey.text = @"是否可下单";
        [cell setView:self.view data:[array copy]];
        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            
        }];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

@end
