//
//  BCheckHistoryController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bCheckHistoryController.h"
#import "PullTableView.h"
#import "ACheckListRequest.h"
#import "bCheckListResponse.h"
#import "ACheckInfoCell.h"
#import "ACheckDetailController.h"
#import "BCheckDetailController.h"

@interface BCheckHistoryController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>
{
    PullTableView *_tableView;
    
    NSMutableArray<PTrackInfo *> *_arrayCheck;
    
    NSInteger _curPage;
}



@end


@implementation BCheckHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"检验历史"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_search"]];
    
    [self initView];
    [self initData];
    
    [self getCheck];
    
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
    _curPage = 1;
    
    _arrayCheck = [NSMutableArray array];
}

- (void)initView
{
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)];
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


#pragma mark - Network Request

- (void)getCheck
{
    _curPage = 1;
    
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.rows = 10;
    request.page = _curPage;
    
    [[HttpClient shareClient] view:self.view post:URL_B_CHECK_HISTORY parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        BCheckListResponse *response = [[BCheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayCheck removeAllObjects];
        [_arrayCheck addObjectsFromArray:[response getCheckList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getMoreCheck
{
    _curPage++;
    
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.rows = 10;
    request.page = _curPage;
    
    [[HttpClient shareClient] view:self.view post:URL_A_CHECK_LIST parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsLoadingMore)
        {
            _tableView.pullTableIsLoadingMore = NO;
        }
        
        BCheckListResponse *response = [[BCheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayCheck addObjectsFromArray:[response getCheckList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        _curPage--;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayCheck.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACheckInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ACheckInfoCell identifier]];
    
    if (!cell)
    {
        cell = [ACheckInfoCell cellFromNib];
    }
    
    PTrackInfo *info = _arrayCheck[indexPath.row];
    
    cell.lbPlate.text = info.plateNum;
    
    cell.lbDate.text = info.startTime;
    
    cell.lbInfo.text = [NSString stringWithFormat:@"货物:%@", info.goodsName];
    
    return cell;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ACheckInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BCheckDetailController *controller = [[BCheckDetailController alloc] init];
    controller.trackInfo = _arrayCheck[indexPath.row];
    controller.isHistory = YES;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- PullTableVeiwDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getCheck) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getMoreCheck) withObject:nil afterDelay:1.5f];
}

@end
