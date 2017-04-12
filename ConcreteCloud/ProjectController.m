//
//  ProjectController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectController.h"
#import "PullTableView.h"
#import "ProjectCell.h"
#import "ProjectListResponse.h"
#import "ProjectRequest.h"
#import "ProjectInfo.h"
#import "ProjectDetailController.h"

@interface ProjectController()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PullTableViewDelegate>

@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (assign, nonatomic) NSInteger curSel;

@property (strong, nonatomic) NSMutableArray<ProjectInfo *> *arrayProject;

@end

@implementation ProjectController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"已授权" right:@"未授权"];
    
    [self initView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (0 == _curSel)
    {
        [self getAuthorized];
    }
    else
    {
        [self getUnAuthorized];
    }
    
}


- (void)initData
{
    _curSel = 0;
    _arrayProject = [[NSMutableArray alloc] init];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - network request

- (void)getUnAuthorized
{
    ProjectRequest *request = [[ProjectRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.auth = @"0";
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_PROJECT_LIST parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               
                               ProjectListResponse *response = [[ProjectListResponse alloc] initWithDictionary:responseObject];
                               
                               [weakSelf.arrayProject removeAllObjects];
                               
                               [weakSelf.arrayProject addObjectsFromArray:[response getProjectList]];
                               
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
    
}

- (void)getAuthorized
{
    ProjectRequest *request = [[ProjectRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    request.auth = @"1";
    
    __weak typeof(self) weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_PROJECT_LIST parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               
                               ProjectListResponse *response = [[ProjectListResponse alloc] initWithDictionary:responseObject];
                               
                               [weakSelf.arrayProject removeAllObjects];
                               
                               [weakSelf.arrayProject addObjectsFromArray:[response getProjectList]];
                               
                               [weakSelf.tableView reloadData];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

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

#pragma mark - segment click callback

- (void)onClickLeftSegment
{
    _curSel = 0;
    [_arrayProject removeAllObjects];
    [self getAuthorized];
}

- (void)onClickRightSegment
{
    _curSel = 1;
    [_arrayProject removeAllObjects];
    [self getUnAuthorized];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayProject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:[ProjectCell identifier]];
    
    
    if (nil == cell)
    {
        cell = [ProjectCell cellFromNib];
    }
    
    ProjectInfo *info = _arrayProject[indexPath.row];
    cell.lbProject.text = info.name;
    cell.lbUser.text = [NSString stringWithFormat:@"%@ %@", info.contactsUser, info.tel];
    cell.lbAddress.text = info.address;
    
    return cell;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    if (0 == _curSel)
    {
        [self performSelector:@selector(getAuthorized) withObject:nil afterDelay:1.0f];
    }
    else
    {
        [self performSelector:@selector(getUnAuthorized) withObject:nil afterDelay:1.0f];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"project_detail_controller"];
    
    controller.projectInfo = _arrayProject[indexPath.row];
    
    if (0 == _curSel) {
        controller.isAuthed = YES;
        
    } else {
        controller.isAuthed = NO;
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProjectCell cellHeight];
}

@end
