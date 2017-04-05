//
//  PMainpageController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMainpageController.h"
#import "POrderAddController.h"
#import "PullTableView.h"
#import "POrderItemView.h"
#import "SnapTitleView.h"
#import "POrderListRequest.h"
#import "Config.h"
#import "POrderListResponse.h"
#import "POrderInfo.h"
#import "MessageInfo.h"
#import "MessageListRequest.h"
#import "MsgListResponse.h"
#import "ResponseDictionary.h"
#import "MsgItemView.h"
#import "POrderDetailController.h"



@interface PMainpageController()<PullTableViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnJump;

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSArray<POrderInfo *> *arrayOrder;

@property (strong, nonatomic) NSArray<MessageInfo *> *arrayMsg;

@end

@implementation PMainpageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"首页"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_msg"]];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self getOrderList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initView
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;

}

- (void)onClickNavRight
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_message_controller"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - network request

/**
 获取最新的两条订单列表
 **/
- (void)getOrderList
{
    POrderListRequest *request = [[POrderListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.is = @"1";
    request.type = [[Config shareConfig] getType];
    request.page = 1;
    request.rows = 2;
    request.ing = @"1";
    
    __weak PMainpageController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                        
                               POrderListResponse *response = [[POrderListResponse alloc] initWithDictionary:responseObject];
                               weakSelf.arrayOrder = response.body;
        
                               [weakSelf getMsgList];
                               
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

/**
 获取未读的最新的两条消息
 **/
-(void)getMsgList
{
    MessageListRequest *request = [[MessageListRequest alloc] init];
    request.page = 1;
    request.rows = 2;
    request.isRead = @"0";
    
    __weak PMainpageController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_GET_MSG parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                    weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               MsgListResponse *response = [[MsgListResponse alloc] initWithDictionary:responseObject];
                               weakSelf.arrayMsg = response.body;
                               
            
                               [weakSelf.tableView reloadData];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

#pragma mark -- UITableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) //订单信息
    {
        if (nil == _arrayOrder || 0 == _arrayOrder.count)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            if (0 == indexPath.row)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 300, 76)];
                label.text = @"暂无进行中的订单信息";
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:label];
            }
            return cell;
        }
        else if (1 == _arrayOrder.count)
        {
            
            if (0 == indexPath.row)
            {
                POrderItemView *cell = [POrderItemView viewFromNib];
                POrderInfo *info = _arrayOrder[0];
             
                cell.lbSupplier.text = info.supplierName;
                cell.lbGoods.text = info.goodsName;
                cell.lbDate.text = info.createTime;
                cell.lbConfirm.text = [NSString stringWithFormat:@"确认人:%@", info.administratorName];
                cell.lbTel.text = [NSString stringWithFormat:@"%@", info.administratorTel];
                cell.lbAdress.text = [NSString stringWithFormat:@"%@", info.address];
                
                return cell;
            }
            else
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                return cell;
            }
        }
        else
        {
            POrderItemView *cell = [POrderItemView viewFromNib];
            POrderInfo *info = _arrayOrder[indexPath.row];
            
            cell.lbSupplier.text = info.supplierName;
            cell.lbGoods.text = info.goodsName;
            cell.lbDate.text = info.createTime;
            cell.lbConfirm.text = [NSString stringWithFormat:@"确认人:%@", info.administratorName];
            cell.lbTel.text = [NSString stringWithFormat:@"%@", info.administratorTel];
            cell.lbAdress.text = [NSString stringWithFormat:@"%@", info.address];
            
            return cell;
        }
    
    }
    else    //消息列表
    {
        if (nil == _arrayMsg || 0 == _arrayMsg.count)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (0 == indexPath.row)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 300, 76)];
                label.text = @"暂无未读消息";
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:label];
            }
            return cell;
        }
        else if (1 == _arrayMsg.count)
        {
            if (0 == indexPath.row)
            {
                MsgItemView *cell = [MsgItemView viewFromNib];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                MessageInfo *info = _arrayMsg[0];
                
                cell.lbDate.text = info.createTime;
                cell.lbContent.text = [Utils format:info.content with:@"  "];;
                
                return cell;
            }
            else
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else
        {
            MsgItemView *cell = [MsgItemView viewFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            MessageInfo *info = _arrayMsg[indexPath.row];
            
            cell.lbDate.text = info.createTime;
            cell.lbContent.text = [Utils format:info.content with:@"  "];
            
            return cell;
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SnapTitleView *header = [SnapTitleView viewFromNib];
    
    if (0 == section)
    {
        header.labelTitle.text = @"采购订单";
        [header setOnClickMoreListener:^{
            __weak typeof(self) weakSelf = self;
            [weakSelf.tabBarController setSelectedIndex:1];
        }];
    }
    else if (1 == section)
    {
        header.labelTitle.text = @"消息";
        [header setOnClickMoreListener:^{
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_message_controller"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }];
    }
    
    return header;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 148;
    }
    else
    {
        return 180;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [SnapTitleView getSnapHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        POrderDetailController *controller = [[POrderDetailController alloc] init];
        controller.orderInfo = _arrayOrder[indexPath.row];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        controller.hidesBottomBarWhenPushed = NO;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (0 == section)
//    {
//        return 30;
//    }
//    
//    return 0;
//}

#pragma mark -- UIScrollViewDelegate

//禁止上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //内容大于屏幕，并且向上滑动
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height
        && scrollView.contentSize.height >= scrollView.bounds.size.height)
    {
        CGPoint offset = scrollView.contentOffset;
        offset.y = scrollView.contentSize.height - scrollView.bounds.size.height;
        
        scrollView.contentOffset = offset;
    }
    else if (scrollView.contentOffset.y >= 0
             && scrollView.contentSize.height <= scrollView.bounds.size.height) //内容小于屏幕，并且向上滑动
    {
        CGPoint offset = scrollView.contentOffset;
        offset.x = 0;
        offset.y = 0;
        scrollView.contentOffset = offset;
    }
}


#pragma mark -- PullTableVeiwDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getOrderList) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
}

@end
