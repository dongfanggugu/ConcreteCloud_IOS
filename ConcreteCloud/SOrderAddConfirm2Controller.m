//
//  SOrderAddConfirm2Controller.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/5/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "SOrderAddConfirm2Controller.h"
#import "SDetailController.h"
#import "DOrderInfo.h"
#import "KeyValueCell.h"
#import "KeyMultiEditCell.h"

@interface SOrderAddConfirm2Controller () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SOrderAddConfirm2Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"订单确认"];
    [self initNavRightWithText:@"提交"];
    [self initView];
}

- (void)onClickNavRight
{
    
    [[HttpClient shareClient] view:self.view post:URL_S_ADD parameters:[_orderInfo toDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"订单添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
        
    } else if (1 == section) {
        return 2;
        
    } else if (2 == section) {
        return 14;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.section)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"联系人";
        cell.lbValue.text = [NSString stringWithFormat:@"%@   %@", _orderInfo.orderUserName, _orderInfo.orderUserTel];
        cell.lbValue.textColor = [Utils getColorByRGB:TITLE_COLOR];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"名称";
            cell.lbValue.text = _orderInfo.hzsName;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"地址";
            cell.lbValue.text = _orderInfo.hzsAddrress;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    } else if (2 == indexPath.section) {
        if (0 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"商品类型";
            cell.lbValue.text = _orderInfo.goodsName;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (1 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"强度等级";
            cell.lbValue.text = _orderInfo.intensityLevel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (2 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"抗渗等级";
            cell.lbValue.text = _orderInfo.ksdj;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (3 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"石子种类";
            cell.lbValue.text = _orderInfo.szzl;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (4 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"塌落度";
            cell.lbValue.text = [NSString stringWithFormat:@"%@±%@  mm", _orderInfo.slump, _orderInfo.dev];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (5 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"浇筑方式";
            cell.lbValue.text = _orderInfo.jzfs;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (6 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"特殊项目";
            cell.lbValue.text = _orderInfo.tsxm;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (7 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"是否冬施";
            cell.lbValue.text = 0 == _orderInfo.ds ? @"否" : @"是";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (8 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"订货量";
            cell.lbValue.text = [NSString stringWithFormat:@"%.1lf  立方米", _orderInfo.number];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (9 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"浇筑时间";
            cell.lbValue.text = _orderInfo.useTime;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (10 == indexPath.row) {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"浇筑部位";
            cell.lbValue.text = _orderInfo.castingPart;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (11 == indexPath.row) {
            KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"生产调度";
            cell.tvContent.text = _orderInfo.scdd;
            cell.lbPlaceHolder.hidden = YES;
            cell.tvContent.editable = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (12 == indexPath.row) {
            KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"技术要求";
            cell.tvContent.text = _orderInfo.techReq;
            cell.lbPlaceHolder.hidden = YES;
            cell.tvContent.editable = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else if (13 == indexPath.row) {
            KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"泵送要求";
            cell.tvContent.text = _orderInfo.pumpUpReq;
            cell.lbPlaceHolder.hidden = YES;
            cell.tvContent.editable = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return [KeyValueCell cellHeight];
        
    } else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            [KeyValueCell cellHeight];
            
        } else if (1 == indexPath.row) {
            return [KeyValueCell cellHeightWithContent:_orderInfo.hzsAddrress];
        }
        
    } else if (2 == indexPath.section) {
        if (11 == indexPath.row || 12 == indexPath.row || 13 == indexPath.row) {
            return [KeyMultiEditCell cellHeight];
            
        } else {
            return [KeyValueCell cellHeight];
        }
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [Utils getColorByRGB:@"#cccccc"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
    
    if (0 == section)
    {
        label.text = @"工程信息";
    }
    else if (1 == section)
    {
        label.text = @"搅拌站信息";
    }
    else
    {
        label.text = @"商品信息";
    }
    
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}





@end
