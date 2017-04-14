//
//  ACheckVideoInfoCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACheckVideoInfoCell.h"

@interface ACheckVideoInfoCell()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ACheckVideoInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ACheckVideoInfoCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 125;
}

+ (NSString *)identifier
{
    return @"acheck_video_info_cell";
}

- (void)setUrlStr:(NSString *)urlStr
{
    if (0 == urlStr.length) {
        return;
    }
    
    _urlStr = urlStr;
    
    _webView.scrollView.bounces = NO;
    
    
    NSString *htmlHead = @"<html> \
    <video controls='controls' autoplay='autoplay' width='55' height='75'> \
    <source src='";
    
    NSString *htmlTail = @"' type='video/mp4' /> \
    </video> \
    </html>";
    
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@", htmlHead, _urlStr, htmlTail];
    
    //_webView.scrollView.scrollEnabled = NO;
    
   // _webView.scalesPageToFit = YES;
    
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
//    NSURL *path = [NSURL URLWithString:_urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:path];
//    
//    [_webView loadRequest:request];
}
@end
