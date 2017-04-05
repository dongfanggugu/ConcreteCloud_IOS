//
//  SDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDetailController.h"
#import "KeyValueCell.h"
#import "KeyMultiEditCell.h"
#import "DOrderDetailCell1.h"

@interface SDetailController()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _dyIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData
{
    _dyIndex = 0;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    else if (1 == section)
    {
        return 2;
    }
    else if (2 == section)
    {
        if ([_orderInfo.goodsName isEqualToString:HNT])
        {
            _dyIndex = 4;
        }
        else
        {
            _dyIndex = 2;
        }
        return _dyIndex + 5;
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
    }
    else if (2 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"商品类型";
            cell.lbValue.text = _orderInfo.goodsName;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"强度等级";
            cell.lbValue.text = _orderInfo.intensityLevel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (2 == indexPath.row)
        {
            
            if ([_orderInfo.goodsName isEqualToString:HNT])
            {
                KeyValueCell *cell = [KeyValueCell viewFromNib];
                cell.lbKey.text = @"抗渗等级";
                cell.lbValue.text = _orderInfo.ksdj;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        else if (3 == indexPath.row)
        {
            if ([_orderInfo.goodsName isEqualToString:HNT])
            {
                KeyValueCell *cell = [KeyValueCell viewFromNib];
                cell.lbKey.text = @"塌落度";
                cell.lbValue.text = [NSString stringWithFormat:@"%@±%@  mm", _orderInfo.slump, _orderInfo.dev];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        if (_dyIndex == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"订货量";
            cell.lbValue.text = [NSString stringWithFormat:@"%.1lf  立方米", _orderInfo.number];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (_dyIndex + 1 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"浇筑时间";
            cell.lbValue.text = _orderInfo.useTime;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (_dyIndex + 2 == indexPath.row)
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"浇筑部位";
            cell.lbValue.text = _orderInfo.castingPart;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (_dyIndex + 3 == indexPath.row)
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
        else if (_dyIndex + 4 == indexPath.row)
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
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return [KeyValueCell cellHeight];
    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            [KeyValueCell cellHeight];
        }
        else if (1 == indexPath.row)
        {
            return [KeyValueCell cellHeightWithContent:_orderInfo.hzsAddrress];
        }
    }
    else if (2 == indexPath.section)
    {
        if (_dyIndex + 3 == indexPath.row || _dyIndex + 4 == indexPath.row)
        {
            return [KeyMultiEditCell cellHeight];
        }
        else
        {
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
