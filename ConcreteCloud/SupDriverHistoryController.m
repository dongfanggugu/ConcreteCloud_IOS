//
//  SupDriverHistoryController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDriverHistoryController.h"
#import "PullTableView.h"
#import "SupDriverHistoryRequest.h"
#import "SupDriverHistoryResponse.h"
#import "RentVehicleInfoCell.h"
#import "SupTaskDetailController.h"

@interface SupDriverHistoryController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate,
                                        UIScrollViewDelegate>

{
    PullTableView *_tableView;
    
    NSMutableArray<PTrackInfo *> *_arrayTask;
}

@end

@implementation SupDriverHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"历史运输单"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_search"]];
    
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHistory];
}

- (void)onClickNavRight
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"hzs_message_controller"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)initData
{
    
    _arrayTask = [NSMutableArray array];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width,
                                                                 self.view.frame.size.height - 94 - 49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.pullDelegate = self;
    
    [self.view addSubview:_tableView];
}


#pragma mark - Network Request

- (void)getHistory
{
    
    SupDriverHistoryRequest *request = [[SupDriverHistoryRequest alloc] init];
    request.driverId = [[Config shareConfig] getUserId];
    
    [[HttpClient shareClient] view:self.view post:URL_SUP_HISTORY parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        SupDriverHistoryResponse *response = [[SupDriverHistoryResponse alloc] initWithDictionary:responseObject];
        [_arrayTask removeAllObjects];
        [_arrayTask addObjectsFromArray:[response getTask]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTask.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentVehicleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[RentVehicleInfoCell identifier]];
    
    if (!cell)
    {
        cell = [RentVehicleInfoCell cellFromNib];
    }
    
    PTrackInfo *info = _arrayTask[indexPath.row];
    
    cell.lbPlate.text = info.hzsName;
    
    cell.lbType.text = [NSString stringWithFormat:@"货物:%@", info.goodsName];
    
    cell.lbInfo.text = [NSString stringWithFormat:@"下单时间:%@", info.createTime];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RentVehicleInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SupTaskDetailController *controller = [[SupTaskDetailController alloc] init];
    controller.trackInfo = _arrayTask[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -- PullTableVeiwDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getHistory) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}


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

@end
