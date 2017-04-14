//
//  Utils.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

@interface Utils : NSObject

+ (NSString *)getServer;

+ (NSString *)md5:(NSString *)str;

+ (BOOL) isEmpty:(NSString *)string;

+ (UIColor *)getColorByRGB:(NSString *)RGB;

+ (NSString *)getCurrentTime;

/**
 将字符串把给定的分隔符转换为回车换行
 **/
+ (NSString *)format:(NSString *)content with:(NSString *)seperator;


/**
 格式化日期输出字符串

 @param date 日期
 @return 日期字符串
 */
+ (NSString *)formatDate:(NSDate *)date;

@end


#endif /* Utils_h */
