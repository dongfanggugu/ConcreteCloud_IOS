//
//  ASiteCheckController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASiteCheckController.h"
#import "PullTableView.h"
#import "ACheckListRequest.h"
#import "ACheckListResponse.h"
#import "ASiteCheckInfoCell.h"
#import "ACheckDetailController.h"

@interface ASiteCheckController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate, UIScrollViewDelegate>
{
    __weak IBOutlet PullTableView *_tableView;
    
    NSMutableArray<DTrackInfo *> *_arrayCheck;
}



@end


@implementation ASiteCheckController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"现场检验"];
    
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
    _arrayCheck = [NSMutableArray array];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - Network Request

- (void)getCheck
{
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_A_CHECK_SITE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        ACheckListResponse *response = [[ACheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayCheck removeAllObjects];
        [_arrayCheck addObjectsFromArray:[response getCheckList]];
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
    return _arrayCheck.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASiteCheckInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ASiteCheckInfoCell identifier]];
    
    if (!cell)
    {
        cell = [ASiteCheckInfoCell cellFromNib];
    }
    
    DTrackInfo *info = _arrayCheck[indexPath.row];
    
    cell.lbCode.text = info.taskCode;
    
    cell.lbDate.text = info.startTime;
    
    cell.lbPlate.text = [NSString stringWithFormat:@"车牌号:%@(司机)", info.plateNum];
    
    cell.lbProject.text = [NSString stringWithFormat:@"工程名称:%@", info.hzs_Order.siteName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ASiteCheckInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ACheckDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"acheck_detail_controller"];
    controller.trackInfo = _arrayCheck[indexPath.row];
    controller.checkType = SITE;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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

#pragma mark -- PullTableVeiwDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getCheck) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
}

@end
