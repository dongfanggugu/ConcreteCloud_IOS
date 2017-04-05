//
//  BCheckController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCheckController.h"
#import "PullTableView.h"
#import "ACheckListRequest.h"
#import "ACheckListResponse.h"
#import "ACheckInfoCell.h"
#import "BCheckListResponse.h"
#import "WorkStateResponse.h"
#import "WorkStateRequest.h"
#import "UpWorkRequest.h"
#import "BCheckDetailController.h"


typedef NS_ENUM(NSInteger, WORK_STATE)
{
    RELAX,
    BUSY
};

@interface BCheckController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate, UIScrollViewDelegate>
{
    UIButton *_btnState;
    
    UILabel *_lbState;
    
    PullTableView *_tableView;
    
    NSMutableArray<PTrackInfo *> *_arrayCheck;
}

@property (assign, nonatomic) WORK_STATE workState;

@end


@implementation BCheckController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNaviTitle:@"检验任务"];
    
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_msg"]];
    
    [self initView];
    [self initData];
    [self getCurWorkState];
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
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94 - 49)];
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    [self initNaviBarLeft];
}

- (void)initNaviBarLeft
{
    UIView *naviBar = [self getNavigationBar];
    
    self.workState = RELAX;
    
    CGRect frame = naviBar.frame;
    
    _btnState = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_btnState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
    [_btnState addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
    
    _btnState.center = CGPointMake(40, frame.size.height - 44 / 2);
    
    _lbState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _lbState.textColor = [UIColor whiteColor];
    _lbState.text = @"下班";
    _lbState.font = [UIFont systemFontOfSize:13];
    _lbState.center = CGPointMake(80, frame.size.height - 44 / 2);
    
    
    [naviBar addSubview:_btnState];
    [naviBar addSubview:_lbState];
}

- (void)setWorkState:(WORK_STATE)state
{
    _workState = state;
    
    if (RELAX == _workState)
    {
        [_btnState setImage:[UIImage imageNamed:@"icon_relax"] forState:UIControlStateNormal];
        _lbState.text = @"下班";
    }
    else
    {
        [_btnState setImage:[UIImage imageNamed:@"icon_busy"] forState:UIControlStateNormal];
        _lbState.text = @"上班";
    }
}

- (WORK_STATE)getWorkState
{
    return _workState;
}

- (void)changeState
{
    if (RELAX == _workState)
    {
        //上班
        UpWorkRequest *request = [[UpWorkRequest alloc] init];
        request.handOverId = @"";
        
        [[HttpClient shareClient] view:self.view post:URL_UP_WORK parameters:[request parsToDictionary]
                               success:^(NSURLSessionDataTask *task, id responseObject) {
            self.workState = BUSY;
            [[Config shareConfig] setOperable:1];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        
    }
    else
    {
        //下班
        UpWorkRequest *request = [[UpWorkRequest alloc] init];
        request.handOverId = @"";
        
        [[HttpClient shareClient] view:self.view post:URL_DOWN_WORK parameters:[request parsToDictionary]
                               success:^(NSURLSessionDataTask *task, id responseObject) {
            self.workState = RELAX;
            [[Config shareConfig] setOperable:0];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
        self.workState = RELAX;
    }
}

#pragma mark - Network Request

- (void)getCurWorkState
{
    WorkStateRequest *request = [[WorkStateRequest alloc] init];
    request.userId = [[Config shareConfig] getUserId];
    
    [[HttpClient shareClient] view:self.view post:URL_WORK_STATE parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        WorkStateResponse *response = [[WorkStateResponse alloc] initWithDictionary:responseObject];
        
        NSInteger operable = [[response getState] integerValue];
        
        [[Config shareConfig] setOperable:operable];
        self.workState = operable;
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getCheck
{
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_B_CHECK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
