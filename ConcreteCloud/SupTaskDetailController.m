//
//  SupTaskDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupTaskDetailController.h"
#import "KeyValueCell.h"

@interface SupTaskDetailController()<UITableViewDelegate, UITableViewDataSource>
{
    //公共属性起始index
    NSInteger _dyIndex;
}

@property (strong, nonatomic) UITableView *tableView;

@end


@implementation SupTaskDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"运输单详情"];
    [self initData];
    [self initView];
}

- (void)initData
{
    _dyIndex = 1;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width,
                                                                 self.view.frame.size.height - 94 - 49)];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *goods = _trackInfo.goodsName;
    
    if ([goods isEqualToString:OTHERS])
    {
        _dyIndex = 6;
    }
    else if ([goods isEqualToString:WAIJIAJI]
             || [goods isEqualToString:KUANGFEN]
             || [goods isEqualToString:FENMEIHUI])
    {
        _dyIndex = 7;
    }
    else
    {
        _dyIndex = 8;
    }
    
    return _dyIndex + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"车牌号";
        cell.lbValue.text = _trackInfo.plateNum;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"搅拌站";
        cell.lbValue.text = _trackInfo.hzsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"地址";
        cell.lbValue.text = _trackInfo.hzsAddress;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"联系人";
        cell.lbValue.text =  _trackInfo.userName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"联系人电话";
        cell.lbValue.text = _trackInfo.userTel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (5 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"商品";
        cell.lbValue.text = _trackInfo.goodsName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (6 == indexPath.row)
    {
        NSString *goods = _trackInfo.goodsName;
        if ([goods isEqualToString:SHIZI]
            || [goods isEqualToString:SHAZI]
            || [goods isEqualToString:SHUINI]
            || [goods isEqualToString:WAIJIAJI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"品种";
            cell.lbValue.text = _trackInfo.variety;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:KUANGFEN]
                 || [goods isEqualToString:FENMEIHUI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"等级标准";
            cell.lbValue.text = _trackInfo.standard;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (7 == indexPath.row)
    {
        NSString *goods = _trackInfo.goodsName;
        
        if ([goods isEqualToString:SHIZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"粒径规格";
            cell.lbValue.text = _trackInfo.kld;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:SHAZI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"细度模数";
            cell.lbValue.text = _trackInfo.kld;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ([goods isEqualToString:SHUINI])
        {
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            cell.lbKey.text = @"强度等级";
            cell.lbValue.text = _trackInfo.intensityLevel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    if (_dyIndex == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"毛重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.weight];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"皮重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.net];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (_dyIndex + 2 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"净重";
        cell.lbValue.text = [NSString stringWithFormat:@"%.1lf吨", _trackInfo.number];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (_dyIndex + 3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.lbKey.text = @"状态";
        cell.lbValue.text = _trackInfo.state.integerValue == 5 ? @"退货" : @"合格";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.row)
    {
        CGFloat height = [KeyValueCell cellHeightWithContent:_trackInfo.hzsAddress];
        
        return height;
    }
    else
    {
        return [KeyValueCell cellHeight];
    }

}


@end
