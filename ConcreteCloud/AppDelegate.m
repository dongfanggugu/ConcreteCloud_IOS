//
//  AppDelegate.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "NSArray+Log.h"
#import <IQKeyboardManager.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "JPUSHService.h"
#import "PumpMainController.h"
#import "RentTankerMainController.h"
#import "RentPumpMainController.h"
#import "AdminMainController.h"
#import "SupplierDriverMainController.h"
#import "SupAdminMainController.h"
#import "OthersMainController.h"
#import "BCheckerMainController.h"
#import "BackgroundRunner.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif


@interface AppDelegate()
{
    BMKMapManager *_mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    //百度地图
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:BM_KEY generalDelegate:nil];

    if (ret) {
        NSLog(@"BMMap manager start successfully");
        
    } else {
        NSLog(@"BMMap manager start failed");
    }
    
    [self checkUpdate];
    
    NSString *token = [[Config shareConfig] getToken];
    
    if (0 == token.length)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"login_controller"];
        _window.rootViewController = controller;
    }
    else
    {
        NSString *roleId = [[Config shareConfig] getRole];
        
        if ([roleId isEqualToString:HZS_PURCHASER])
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
            
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"purchaser_main"];
            
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:HZS_DISPATCHER])
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Dispatcher" bundle:nil];
            
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"dispatcher_main_controller"];
            
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:SITE_ADMIN]
                 || [roleId isEqualToString:SITE_PURCHASER]
                 || [roleId isEqualToString:SITE_CHECKER])
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Site" bundle:nil];
            
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"site_main_controller"];
            
            [_window setRootViewController:controller];
            
        }
        else if ([roleId isEqualToString:HZS_A_CHECKER])
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"AChecker" bundle:nil];
            
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"achecker_main_controller"];
            
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:HZS_TANKER])
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Tanker" bundle:nil];
            
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"tanker_main_controller"];
            
             [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:HZS_PUMP])
        {
            PumpMainController *controller = [[PumpMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:RENT_TANKER])
        {
            RentTankerMainController *controller = [[RentTankerMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:RENT_PUMP])
        {
            RentPumpMainController *controller = [[RentPumpMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:RENT_ADMIN])
        {
            AdminMainController *controller = [[AdminMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:SUP_DRIVER])
        {
            SupplierDriverMainController *controller = [[SupplierDriverMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:SUP_ADMIN]
                 || [roleId isEqualToString:SUP_CLERK])
        {
            SupAdminMainController *controller = [[SupAdminMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:HZS_OTHERS])
        {
            OthersMainController *controller = [[OthersMainController alloc] init];
            [_window setRootViewController:controller];
        }
        else if ([roleId isEqualToString:HZS_B_CHECKER])
        {
            UIViewController *controller = [[BCheckerMainController alloc] init];
            [_window setRootViewController:controller];
        }
    }
    
    //注册jpush
    [self registerJPushWithOptions:launchOptions];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        [[BackgroundRunner shared] run];
    }

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[BackgroundRunner shared] stop];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     //[[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (version >= 10.0)
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UNAuthorizationOptionSound | UNAuthorizationOptionAlert
         categories:nil];
    }
    else if (version >= 8.0)
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert
         categories:nil];
    }
    else
    {
        [JPUSHService
         registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
         categories:nil];
        
    }
    
    
#else
    
    [JPUSHService
     registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert
     categories:nil];
    
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:@"ios" apsForProduction:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    NSLog(@"fail to register for remote notifications with error:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"remote notificaiton:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
    //发送应用内通知
    NSNotification *notification = [NSNotification notificationWithName:@"concrete_notify" object:nil userInfo:userInfo];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center postNotification:notification];
    
}


/**
 *  检测是否需要升级
 */
- (void)checkUpdate
{
    [[HttpClient shareClient] post:URL_VERSION_CHECK parameters:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSInteger remoteVersion = [[responseObject[@"body"] objectForKey:@"appVersion"] integerValue];
                               
                               NSLog(@"remote version:%ld", remoteVersion);
                               
                               NSInteger localVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
                               
                               if(remoteVersion > localVersion) {
                                   [self performSelectorOnMainThread:@selector(showUpdate) withObject:nil waitUntilDone:NO];
                               }
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr, Fail_Type failType) {
                               
                           }];

}

- (void)showUpdate
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新的版本更新"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://fir.im/ConcreteCloud"]];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

@end
