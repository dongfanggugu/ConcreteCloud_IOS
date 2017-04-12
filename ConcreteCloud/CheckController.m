//
//  CheckController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckController.h"
#import "PullTableView.h"
#import "DTrackInfo.h"
#import "PTrackInfo.h"
#import "ACheckListRequest.h"
#import "ACheckListResponse.h"
#import "BCheckListResponse.h"
#import "ACheckInfoCell.h"
#import "BCheckDetailController.h"
#import "ACheckDetailController.h"

@interface CheckController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate, UIScrollViewDelegate>


@property (assign, nonatomic) NSInteger curSel;

@property (strong, nonatomic) PullTableView *tableView;

@property (strong, nonatomic) NSMutableArray<DTrackInfo *> *arrayACheck;

@property (strong, nonatomic) NSMutableArray<PTrackInfo *> *arrayBCheck;

@end



@implementation CheckController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSegmentTitleLeft:@"混凝土检验" right:@"原材料检验"];
    
    [self initView];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (0 == _curSel)
    {
        [self getACheck];
    }
    else
    {
        [self getBCheck];
    }
    
}

- (void)initData
{
    _curSel = 0;
    _arrayACheck = [[NSMutableArray alloc] init];
    _arrayBCheck = [[NSMutableArray alloc] init];
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

#pragma mark - segment click callback

- (void)onClickLeftSegment
{
    _curSel = 0;
    [_arrayACheck removeAllObjects];
    [self getACheck];
}

- (void)onClickRightSegment
{
    _curSel = 1;
    [_arrayBCheck removeAllObjects];
    [self getBCheck];
}

#pragma mark - Network Request

- (void)getACheck
{
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_A_CHECK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        ACheckListResponse *response = [[ACheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayACheck removeAllObjects];
        [_arrayACheck addObjectsFromArray:[response getCheckList]];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)getBCheck
{
    ACheckListRequest *request = [[ACheckListRequest alloc] init];
    request.hzsId = [[Config shareConfig] getBranchId];
    
    [[HttpClient shareClient] view:self.view post:URL_B_CHECK parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_tableView.pullTableIsRefreshing)
        {
            _tableView.pullTableIsRefreshing = NO;
        }
        
        BCheckListResponse *response = [[BCheckListResponse alloc] initWithDictionary:responseObject];
        [_arrayBCheck removeAllObjects];
        [_arrayBCheck addObjectsFromArray:[response getCheckList]];
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
    if (0 == _curSel)
    {
        return _arrayACheck.count;
    }
    else
    {
        return _arrayBCheck.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACheckInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ACheckInfoCell identifier]];
    
    if (!cell)
    {
        cell = [ACheckInfoCell cellFromNib];
    }
    
    if (0 == _curSel)
    {
        DTrackInfo *info = _arrayACheck[indexPath.row];
        
        cell.lbPlate.text = info.plateNum;
        
        cell.lbDate.text = info.startTime;
        
        cell.lbInfo.text = [NSString stringWithFormat:@"商品:%@ 部位:%@ 等级:%@",
                            info.hzs_Order.goodsName, info.hzs_Order.castingPart, info.hzs_Order.intensityLevel];
    }
    else
    {
        PTrackInfo *info = _arrayBCheck[indexPath.row];
        
        cell.lbPlate.text = info.plateNum;
        
        cell.lbDate.text = info.startTime;
        
        cell.lbInfo.text = [NSString stringWithFormat:@"货物:%@", info.goodsName];
    }
    
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
    
    if (0 == _curSel) {
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"AChecker" bundle:nil];
        ACheckDetailController *controller = [board instantiateViewControllerWithIdentifier:@"acheck_detail_controller"];
        controller.trackInfo = _arrayACheck[indexPath.row];
        controller.checkType = HZS;
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
        BCheckDetailController *controller = [[BCheckDetailController alloc] init];
        controller.trackInfo = _arrayBCheck[indexPath.row];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
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
    if (0 == _curSel)
    {
        [self performSelector:@selector(getACheck) withObject:nil afterDelay:1.5f];;
    }
    else
    {
        [self performSelector:@selector(getBCheck) withObject:nil afterDelay:1.5f];;
    }
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
}


@end
