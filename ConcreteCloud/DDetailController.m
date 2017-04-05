//
//  DDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDetailController.h"
#import "KeyValueCell.h"
#import "KeyMultiEditCell.h"
#import "DOrderDetailCell1.h"

@interface DDetailController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation DDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData
{
}

- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    
    //处理不同商品的属性
    if (0 == indexPath.row)
    {
        DOrderDetailCell1 *cell = [DOrderDetailCell1 cellFromNib];
        cell.lbUser.text = _orderInfo.orderUserName;
        cell.lbTel.text = _orderInfo.orderUserTel;
        cell.lbProject.text = _orderInfo.siteName;
        cell.lbAddress.text = _orderInfo.siteAddress;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"商品类型";
        cell.lbValue.text = _orderInfo.goodsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"强度等级";
        cell.lbValue.text = _orderInfo.intensityLevel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
       
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"需求量";
            cell.lbValue.text = [NSString stringWithFormat:@"%.1lf  立方米", _orderInfo.number];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }
    
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑时间";
        cell.lbValue.text = _orderInfo.useTime;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"浇筑部位";
        cell.lbValue.text = _orderInfo.castingPart;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (6 == indexPath.row)
    {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"技术要求";
        cell.tvContent.text = _orderInfo.techReq;
        cell.lbPlaceHolder.hidden = YES;
        cell.tvContent.editable = NO;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (7 == indexPath.row)
    {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"泵送要求";
        cell.tvContent.text = _orderInfo.pumpUpReq;
        cell.lbPlaceHolder.hidden = YES;
        cell.tvContent.editable = NO;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return [DOrderDetailCell1 cellHeight];
    }
    else if (6 == indexPath.row || 7 == indexPath.row)
    {
        return [KeyMultiEditCell cellHeight];
    }
    else
    {
        return [KeyValueCell cellHeight];
    }
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
    label.text = @"工程信息";
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}

@end
