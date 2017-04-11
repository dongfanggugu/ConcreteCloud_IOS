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
    if(0 == url.length)
    {
        _ivFailed.hidden = NO;
        _webView.hidden = YES;
        
        return;
    }
    
    _ivFailed.hidden = YES;
    _webView.hidden = NO;
    _url = url;

    _webView.scrollView.bounces = NO;
    NSURL *path = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:path];
    
    [_webView loadRequest:request];
    
}

//- (void)loadPreview:(UIImage *)image
//{
//    _ivPreview.image = image;
//}
//
//- (void)getVideoPreViewImage
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(queue, ^{
//        NSURL *url = [NSURL URLWithString:_url];
//        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
//        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//        
//        gen.appliesPreferredTrackTransform = YES;
//        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//        NSError *error = nil;
//        CMTime actualTime;
//        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//        UIImage *img = [[UIImage alloc] initWithCGImage:image];
//        [self performSelectorOnMainThread:@selector(loadPreview:) withObject:img waitUntilDone:NO];
//    });
//    
//}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

@end
