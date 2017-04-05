//
//  HelpController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpController.h"

@interface HelpController()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;


@end


@implementation HelpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"帮助"];
    [self initView];
}

- (void)initView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    _webView.delegate = self;
    
    _webView.scrollView.bounces = NO;
    
    [self.view addSubview:_webView];
    
    NSString *urlStr = [[Config shareConfig] getHelpLink];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}


@end
