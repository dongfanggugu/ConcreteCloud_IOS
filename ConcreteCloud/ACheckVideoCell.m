//
//  ACheckVideoCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACheckVideoCell.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>

@interface ACheckVideoCell()<UIWebViewDelegate>
{
    __weak IBOutlet UIImageView *_ivFailed;
    
    __weak IBOutlet UIWebView *_webView;
}

@end

@implementation ACheckVideoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ACheckVideoCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    
    
    _ivFailed.hidden = YES;
    
    _btnRecord.layer.masksToBounds = YES;
    _btnRecord.layer.cornerRadius = 5;
    _btnRecord.hidden = YES;
    
}

+ (CGFloat)cellHeight
{
    return 150;
}

- (void)setUrl:(NSString *)url
{
    if(0 == url.length) {
        _ivFailed.hidden = NO;
        _webView.hidden = YES;
        
        return;
    }
    
    _ivFailed.hidden = YES;
    _webView.hidden = NO;
    _url = url;


    
    NSString *htmlHead = @"<html> \
    <video controls='controls' autoplay='autoplay' width=80 height=100> \
    <source src='";
    
    NSString *htmlTail = @"' type='video/mp4' /> \
    </video> \
    </html>";
   
    
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@", htmlHead, _url, htmlTail];
    
    
    
  //  _webView.scrollView.scrollEnabled = NO;
    
 //   _webView.scalesPageToFit = YES;
    

    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
//    NSURL *path = [NSURL URLWithString:_url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:path];
//    
//    
//    [_webView loadRequest:request];
    
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

@end
