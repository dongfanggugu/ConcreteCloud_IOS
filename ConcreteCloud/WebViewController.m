//
//  WebViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}


- (void)initView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    [self.view addSubview:webView];
    
    
    webView.scrollView.bounces = NO;
    
    NSString *htmlHead = @"<html> \
    <video controls=\"controls\" width=300 autoplay='autoplay'> \
    <source src=\"";
    
    NSString *htmlTail = @"\" type=\"video/mp4\" /> \
    </video> \
    </html>";
    
    NSString *url = @"http://119.57.248.130:8080/static/video/20170412/1491959246392.mp4";
    
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@", htmlHead, url, htmlTail];
    
    
    [webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
