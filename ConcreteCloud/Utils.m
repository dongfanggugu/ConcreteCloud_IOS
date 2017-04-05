//
//  Utils.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

+ (NSString *)getServer
{
    NSString *server = [[Config shareConfig] getServer];
    
    if (0 == server)
    {
        server = @"119.57.248.130:8080";
    }
    
    if (![server containsString:@":"])
    {
        server = [NSString stringWithFormat:@"%@:8080", server];
    }
    
    return [NSString stringWithFormat:@"http://%@/mobile/", server];
    
    //return @"http://119.57.248.130:8080/mobile/";
    //return @"http://101.201.252.84:8080/mobile/";
    
    //return @"http://192.168.0.81:8080/mobile/";
    
    //return @"http://101.201.252.84:8080/mobile/";
}

/**
 *  MD5加密
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)isEmpty:(NSString *)string
{
    return !string.length;
}


+ (UIColor *)getColorByRGB:(NSString *)RGB
{
    
    if (RGB.length != 7)
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    if (![RGB hasPrefix:@"#"])
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    NSString *colorString = [RGB substringFromIndex:1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *red = [colorString substringWithRange:range];
    
    range.location = 2;
    NSString *green = [colorString substringWithRange:range];
    
    range.location = 4;
    NSString *blue = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}


+ (NSString *)format:(NSString *)content with:(NSString *)seperator
{
    return [content stringByReplacingOccurrencesOfString:seperator withString:@"\n"];
}


+
(NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [format stringFromDate:date];
    
    return dateStr;
}

@end
