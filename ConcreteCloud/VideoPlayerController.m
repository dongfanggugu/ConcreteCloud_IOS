//
//  VideoPlayerController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerController()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VideoPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"检验视频"];
    [self initView];
}


- (void)initView
{
    _webView.scrollView.bounces = NO;
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    player.controlStyle = MPMovieControlStyleDefault;
//    player.view.frame = self.view.frame;
//    [self.view addSubview:player.view];
//    
//    [player play];
}

@end
