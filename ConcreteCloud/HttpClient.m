//
//  HttpClient.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "Config.h"
#import "AppDelegate.h"

@interface HttpClient()

@end

@implementation HttpClient


+ (instancetype)shareClient
{
    static HttpClient *shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:[Utils getServer]]];
        shareClient.requestSerializer = [AFJSONRequestSerializer serializer];
        shareClient.responseSerializer = [AFJSONResponseSerializer serializer];
        shareClient.responseSerializer.acceptableContentTypes
        = [shareClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });
    
    return shareClient;
}

- (void)view:(UIView *)view post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];
    
    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];
    head[@"type"] = [[Config shareConfig] getType];
    [head setObject:[[Config shareConfig] getToken] forKey:@"accessToken"];
    [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    if (parameters)
    {
        [param setObject:parameters forKey:@"body"];
    }
    
    [param setObject:head forKey:@"head"];
    
    //NSLog(@"zhenhao-----request:%@", param);
    
    MBProgressHUD *hud = nil;
    
    hud = [HUDClass showLoadingHUD:view];
    
    [self POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhenhao-----response:%@", responseObject);
  
        [HUDClass hideLoadingHUD:hud];
        
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"])
        {
             success(task, responseObject);
            
        }
        else
        {
            //根据错误信息提示用户
            NSString *msg = nil;
            NSString *rspMsg = [[responseObject objectForKey:@"head"]objectForKey:@"rspMsg"];
            if ([rspMsg containsString:@"系统错误"])
            {
                msg = [rspMsg substringFromIndex:5];
            }
            else
            {
                msg = rspMsg;
            }
            
            
            NSString * msgCode = [[responseObject objectForKey:@"head"]objectForKey:@"rspCode"];
    
            [HUDClass showHUDWithLabel:msg view:view];
            
            if ([msgCode isEqualToString:@"-9"])
            {
                [self performSelector:@selector(backToLogin) withObject:nil afterDelay:2];
                
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"zhenhao-----error:%@", error);
        
        [HUDClass hideLoadingHUD:hud];
        
        failure(task, error);
    }];
}


- (void)post:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType)) failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];
    
    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];
    head[@"type"] = [[Config shareConfig] getType];
    [head setObject:[[Config shareConfig] getToken] forKey:@"accessToken"];
    [head setObject:[[Config shareConfig] getUserId] forKey:@"userId"];
    
    if (parameters)
    {
        [param setObject:parameters forKey:@"body"];
    }
    
    [param setObject:head forKey:@"head"];
    
    //NSLog(@"zhenhao-----request:%@", param);
    
    
    [self POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {        
        
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"])
        {
            success(task, responseObject);
            
        }
        else
        {
            failure(task, responseObject, System_Error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"zhenhao-----error:%@", error);
        
        failure(task, error, Network_Error);
    }];
}


- (void)backToLogin
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window setRootViewController:controller];
    
    [[Config shareConfig] setToken:@""];
}


@end
