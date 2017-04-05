//
//  HzsMsgDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsMsgDetailController.h"
#import "MsgReadRequest.h"

@interface HzsMsgDetailController()

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end


@implementation HzsMsgDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"消息详情"];
    [self readMsg];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self initView];
}

- (void)initView
{
    _lbDate.text = _msg.createTime;
    
    _lbContent.numberOfLines = 0;
    
    _lbContent.lineBreakMode = NSLineBreakByWordWrapping;
    
    _lbContent.text = [Utils format:_msg.content with:@"  "];;
    [_lbContent sizeToFit];
}

- (void)readMsg
{
    MsgReadRequest *request = [[MsgReadRequest alloc] init];
    request.msgId = _msg.msgId;
    
    [[HttpClient shareClient] view:self.view post:URL_MSG_READ parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"message read successfully");
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        NSLog(@"message read failed");
    }];
}

@end
