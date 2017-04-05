//
//  SupOrderDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderDetailController.h"
#import "KeyValueCell.h"
#import "KeyMultiEditCell.h"

@interface SupOrderDetailController()<UITableViewDelegate, UITableViewDataSource>
{
    //公共属性起始index
    NSInteger _dyIndex;
}

@property (strong, nonatomic) UITableView *tableView;


@end

@implementation SupOrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData
{
    _dyIndex = 1;
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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
    
    if ([_orderInfo.goodsName isEqualToString:SHUINI])
    {
        _dyIndex = 3;
    }
    else if ([_orderInfo.goodsName isEqualToString:SHAZI]
             || [_orderInfo.goodsName isEqualToString:SHIZI])
    {
        _dyIndex = 4;
    }
    else if ([_orderInfo.goodsName isEqualToString:KUANGFEN]
             || [_orderInfo.goodsName isEqualToString:FENMEIHUI]
             || [_orderInfo.goodsName isEqualToString:WAIJIAJI])
    {
        _dyIndex = 2;
    }
    else if ([_orderInfo.goodsName isEqualToString:OTHERS])
    {
        _dyIndex = 1;
    }
    
    return _dyIndex + 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //处理不同商品的属性
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
        
        
        if ([_orderInfo.goodsName isEqualToString:SHUINI]
            || [_orderInfo.goodsName isEqualToString:SHAZI]
            || [_orderInfo.goodsName isEqualToString:SHIZI]
            || [_orderInfo.goodsName isEqualToString:WAIJIAJI])
        {
            
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"品种";
            cell.lbValue.text = _orderInfo.variety;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([_orderInfo.goodsName isEqualToString:KUANGFEN]
                 || [_orderInfo.goodsName isEqualToString:FENMEIHUI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"等级标准";
            cell.lbValue.text = _orderInfo.standard;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    }
    else if (2 == indexPath.row)
    {
        
        if ([_orderInfo.goodsName isEqualToString:SHUINI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"强度等级";
            cell.lbValue.text = _orderInfo.intensityLevel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([_orderInfo.goodsName isEqualToString:SHAZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"细度模数";
            cell.lbValue.text = _orderInfo.standard;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([_orderInfo.goodsName isEqualToString:SHIZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"径粒规格";
            cell.lbValue.text = _orderInfo.standard;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (3 == indexPath.row)
    {
        if ([_orderInfo.goodsName isEqualToString:SHAZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"含泥量";
            cell.lbValue.text = _orderInfo.contents;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([_orderInfo.goodsName isEqualToString:SHIZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"针片状含量";
            cell.lbValue.text = _orderInfo.contents;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
    
    //处理公共属性
    if (_dyIndex == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"订货量";
        cell.lbValue.text = [NSString stringWithFormat:@"%@吨", _orderInfo.number];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"运达时间";
        cell.lbValue.text = _orderInfo.arriveTime;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"下单时间";
        cell.lbValue.text = _orderInfo.createTime;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"供应商名称";
        cell.lbValue.text = _orderInfo.supplierName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"联系人";
        cell.lbValue.text = _orderInfo.userName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 5 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"联系电话";
        cell.lbValue.text = _orderInfo.tel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 6 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"地址";
        cell.lbValue.text = _orderInfo.address;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 7 == indexPath.row)
    {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"特殊要求";
        cell.tvContent.text = _orderInfo.techReq;
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
    if (_dyIndex + 7 == indexPath.row)
    {
        return [KeyMultiEditCell cellHeight];
    }
    else if (_dyIndex + 6 == indexPath.row)
    {
        return [KeyValueCell cellHeightWithContent:_orderInfo.address];
    }
    else
    {
        return [KeyValueCell cellHeight];
    }
}

@end
