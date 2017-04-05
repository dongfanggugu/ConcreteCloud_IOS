//
//  HzsMessageController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/15.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsMessageController.h"
#import "PullTableView.h"
#import "MessageListRequest.h"
#import "MsgListResponse.h"
#import "MessageInfo.h"
#import "HzsMsgDetailController.h"

#pragma mark -- HzsMessageCell

@interface HzsMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end

@implementation HzsMessageCell


@end

#pragma mark - HzsMessageController

@interface HzsMessageController()<UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>


@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSMutableArray<MessageInfo *> *arrayMsg;

@property NSInteger curPage;

@end


@implementation HzsMessageController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"消息"];
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMsgList];
}

- (void)initData
{
    _arrayMsg = [[NSMutableArray alloc] init];
    _curPage = 1;
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    
    UIEdgeInsets padding = _tableView.contentInset;
    padding.top = padding.top - 20;
    _tableView.contentInset = padding;
}


#pragma mark - network request

/**
 获取未读的最新的两条消息
 **/
-(void)getMsgList
{
    MessageListRequest *request = [[MessageListRequest alloc] init];
    request.page = 1;
    request.rows = 10;
    //request.isRead = @"-1";
    
    __weak HzsMessageController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_GET_MSG parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsRefreshing)
                               {
                                   weakSelf.tableView.pullTableIsRefreshing = NO;
                               }
                               MsgListResponse *response = [[MsgListResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arrayMsg removeAllObjects];
                               [weakSelf.arrayMsg addObjectsFromArray:response.body];
                               
                               [weakSelf.tableView reloadData];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}

- (void)getMoreMsg
{
    MessageListRequest *request = [[MessageListRequest alloc] init];
    request.page = _curPage++;
    request.rows = 10;
    request.isRead = @"-1";
    
    __weak HzsMessageController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_GET_MSG parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               if (weakSelf.tableView.pullTableIsLoadingMore)
                               {
                                   weakSelf.tableView.pullTableIsLoadingMore = NO;
                               }
                               MsgListResponse *response = [[MsgListResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arrayMsg addObjectsFromArray:response.body];
                               
                               [weakSelf.tableView reloadData];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count:%ld", _arrayMsg.count);
    return _arrayMsg.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HzsMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msg_cell"];
    
    if (nil == cell)
    {
        cell = [[HzsMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msg_cell"];
    }
    
    MessageInfo *info = _arrayMsg[indexPath.row];
    
    cell.lbDate.text = info.createTime;
    cell.lbContent.text = [Utils format:info.content with:@"  "];
    
    if ([info.isRead isEqualToString:@"0"])
    {
        cell.lbDate.textColor = [Utils getColorByRGB:TITLE_COLOR];
        cell.lbContent.textColor = [Utils getColorByRGB:TITLE_COLOR];
    }
    else
    {
        cell.lbDate.textColor = [UIColor blackColor];
        cell.lbContent.textColor = [UIColor blackColor];
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HzsMsgDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"hzs_msg_detail_controller"];
    controller.msg = _arrayMsg[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getMsgList) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(getMoreMsg) withObject:nil afterDelay:1.5f];
}
@end
