//
//  HttpClient.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HttpClient_h
#define HttpClient_h

#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, Fail_Type)
{
    Network_Error,  //网络错误
    System_Error    //业务逻辑错误
};

@interface HttpClient : AFHTTPSessionManager

+ (void)attempDealloc;

+ (instancetype)shareClient;

- (void)view:(UIView *)view post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr)) failure;


- (void)post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType)) failure;

@end

#endif /* HttpClient_h */
