//
//  HzsMsgSettingsController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsMsgSettingsController.h"
#import "MyMsgInfo.h"
#import "MsgTypeInfo.h"
#import "Response+MyMsg.h"
#import "UpdateMsgRequest.h"

#pragma mark - MyMsgCell


@interface MyMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbMsg;

@property (weak, nonatomic) IBOutlet UISwitch *swCheck;

@end

@implementation MyMsgCell


@end

#pragma mark - HzsMsgSettingsController

@interface HzsMsgSettingsController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<MsgTypeInfo *> *arrayMsg;

@property (strong, nonatomic) NSMutableArray<NSString *> *arrayMyMsg;

@end

@implementation HzsMsgSettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"消息设置"];
    [self initNavRightWithText:@"提交"];
    [self initData];
    [self initView];
    [self getMsgList];
}

- (void)onClickNavRight
{
    [self updateMsg];
}

- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)initData
{
    _arrayMsg = [NSMutableArray array];
    _arrayMyMsg = [NSMutableArray array];
}

- (void)getMyMsg:(NSString *)myMsg
{
    NSArray *array = [myMsg componentsSeparatedByString:@","];
    [_arrayMyMsg addObjectsFromArray:array];
}

- (NSString *)getMyMsgStr
{
    NSString *result = @"";
    for (NSInteger i = 0; i < _arrayMyMsg.count - 1; i++)
    {
        NSString *type = _arrayMyMsg[i];
        result = [NSString stringWithFormat:@"%@%@,", result, type];
    }
    
    result = [NSString stringWithFormat:@"%@%@", result, _arrayMyMsg[_arrayMyMsg.count - 1]];
    
    return result;
}

#pragma mark - Networking Request

- (void)getMsgList
{
    [[HttpClient shareClient] view:self.view post:URL_MY_MSG parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MyMsgInfo *myMsg = [[[ResponseDictionary alloc] initWithDictionary:responseObject] getMyMsgInfo];
        [_arrayMsg addObjectsFromArray:myMsg.roleMsgTypes];
        [self getMyMsg:myMsg.userMsgTypes];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)updateMsg
{
    UpdateMsgRequest *request = [[UpdateMsgRequest alloc] init];
    request.msgTypes = [self getMyMsgStr];
    
    NSLog(@"msgTypes:%@", request.msgTypes);
    
    [[HttpClient shareClient] view:self.view post:URL_UPDATE_MY_MSG parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"用户信息设置成功!" view:self.view];
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
    return _arrayMsg.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my_msg_cell"];
    
    MsgTypeInfo *info = _arrayMsg[indexPath.row];
    
    cell.lbMsg.text = info.des;
    
    if ([_arrayMyMsg containsObject:info.value])
    {
        cell.swCheck.on = YES;
    }
    else
    {
        cell.swCheck.on = NO;
    }
    
    cell.swCheck.tag = indexPath.row;
    
    [cell.swCheck addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)change:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    NSInteger tag = sw.tag;
    NSString *type = _arrayMsg[tag].value;
    BOOL on = sw.isOn;
    
    if (on)
    {
        [_arrayMyMsg addObject:type];
    }
    else
    {
        [_arrayMyMsg removeObject:type];
    }
}

@end
