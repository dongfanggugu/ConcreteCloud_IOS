//
//  TitleView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleView.h"
#import "UIImageView+AFNetworking.h"

@interface TitleView()


@end

@implementation TitleView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:nil
                                                 options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _ivLogo.layer.masksToBounds = YES;
    _ivLogo.layer.cornerRadius = 15;
}

- (void)dealloc
{
}

- (void)loadLogo:(NSString *)url
{
    NSString *name = [FileUtils getFileNameFromUrlString:url];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"temp"];
    
    if ([FileUtils existInPath:path name:name])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:name]];
        _ivLogo.image = image;
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_ivLogo setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            _ivLogo.image = image;
            NSData *data = UIImagePNGRepresentation(image);
            BOOL result = [FileUtils writeFile:data Path:path fileName:name];
            
            if (result)
            {
                NSLog(@"save image success");
            }
            else
            {
                NSLog(@"save iamge failed");
            }
            
            _ivLogo.image = image;
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
}

@end
