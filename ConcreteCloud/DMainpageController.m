//
//  DMainpageController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMainpageController.h"
#import "PullTableView.h"
#import "DOrderInfo.h"
#import "MessageInfo.h"
#import "DOrderRequest.h"
#import "DOrderListResponse.h"
#import "MessageListRequest.h"
#import "MsgListResponse.h"
#import "MsgItemView.h"
#import "SnapTitleView.h"
#import "DOrderItemView.h"
#import "DOrderDetailController.h"

@interface DMainpageController()<PullTableViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnJump;

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSMutableArray<DOrderInfo *> *arrayOrder;

@property (strong, nonatomic) NSMutableArray<MessageInfo *> *arrayMsg;

@end

@implementation DMainpageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"首页"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_msg"]];
    [self initData];
    [self initView];
}

- (void)initData
{
    _arrayOrder = [NSMutableArray array];
    _arrayMsg = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    DOrderRequest *request = [[DOrderRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.isComplete = @"0";
    request.page = 1;
    request.rows = 2;
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_D_ORDER parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               DOrderListResponse *response = [[DOrderListResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arrayOrder addObjectsFromArray:[response getOrderList]];
                               
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
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_GET_MSG parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               MsgListResponse *response = [[MsgListResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arrayMsg addObjectsFromArray:response.body];
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
                [cell.contentView addSubview:label];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (1 == _arrayOrder.count)
        {
            
            if (0 == indexPath.row)
            {
                DOrderItemView *cell = [DOrderItemView cellFromNib];
                DOrderInfo *info = _arrayOrder[0];
                
                cell.lbDate.text = info.createTime;
                cell.lbProject.text = [NSString stringWithFormat:@"工程名称:%@", info.siteName];
                cell.lbUser.text = [NSString stringWithFormat:@"联系人:%@ %@", info.orderUserName, info.orderUserTel];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            DOrderItemView *cell = [DOrderItemView cellFromNib];
            DOrderInfo *info = _arrayOrder[indexPath.row];
            
            cell.lbDate.text = info.createTime;
            cell.lbProject.text = [NSString stringWithFormat:@"工程名称:%@", info.siteName];
            cell.lbUser.text = [NSString stringWithFormat:@"联系人:%@ %@", info.orderUserName, info.orderUserTel];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        header.labelTitle.text = @"混凝土订单";
        [header setOnClickMoreListener:^{
            __weak typeof(self) weakSelf = self;
            [weakSelf.tabBarController setSelectedIndex:2];
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
        return [DOrderItemView cellHeight];
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
        DOrderDetailController *controller = [[DOrderDetailController alloc] init];
        controller.orderInfo = _arrayOrder[indexPath.row];
        controller.role = Role_Dispather;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
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
