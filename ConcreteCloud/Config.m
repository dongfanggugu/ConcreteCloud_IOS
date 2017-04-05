//
//  Config.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/28.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@implementation Config

+ (instancetype)shareConfig
{
    static Config *config = nil;

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        config = [[Config alloc] init];
    });
    
    return config;
}

- (void)setUserName:(NSString *)userName
{
    [self setValue:userName key:@"user_name"];
}

- (NSString *)getUserName
{
    return [self getValueWithKey:@"user_name"];
}

- (void)setRole:(NSString *)role
{
    [self setValue:role key:@"role"];
}

- (NSString *)getRole
{
    return [self getValueWithKey:@"role"];
}

- (NSString *)getRoleName
{
    NSString *roleId = [self getRole];
    
    if ([roleId isEqualToString:HZS_PURCHASER])
    {
        return @"采购员";
    }
    else if ([roleId isEqualToString:HZS_DISPATCHER])
    {
        return @"调度员";
    }
    
    return nil;
}

- (void)setToken:(NSString *)token
{
    [self setValue:token key:@"token"];
}

- (NSString *)getToken
{
    NSString *token = [self getValueWithKey:@"token"];
    
    if (nil == token)
    {
        token = @"";
    }
    
    return token;
}

- (void)setUserId:(NSString *)userId
{
    [self setValue:userId key:@"user_id"];
}

- (NSString *)getUserId
{
    NSString *userId = [self getValueWithKey:@"user_id"];
    
    if (nil == userId)
    {
        userId = @"";
    }
    return userId;
}

- (void)setName:(NSString *)name
{
    [self setValue:name key:@"name"];
}

- (NSString *)getName
{
    return [self getValueWithKey:@"name"];
}


- (void)setBranchId:(NSString *)branchId
{
    [self setValue:branchId key:@"branch"];
}

- (NSString *)getBranchId
{
    return [self getValueWithKey:@"branch"];
}

- (void)setType:(NSString *)type
{
    [self setValue:type key:@"type"];
}

- (NSString *)getType
{
    return [self getValueWithKey:@"type"];
}


- (void)setBranchName:(NSString *)branchName
{
    [self setValue:branchName key:@"branch_name"];
}

- (NSString *)getBranchName
{
    return [self getValueWithKey:@"branch_name"];
}

- (void)setBranchAddress:(NSString *)address
{
    [self setValue:address key:@"branch_address"];
}

- (NSString *)getBranchAddress
{
    return [self getValueWithKey:@"branch_address"];

}

- (void)setBranchLogo:(NSString *)logo
{
    [self setValue:logo key:@"logo"];
}

- (NSString *)getBranchLogo
{
    return [self getValueWithKey:@"logo"];
}


//设置和获取机构的经度
- (void)setLng:(CGFloat)lng
{
    [self setValue:[NSNumber numberWithFloat:lng] key:@"lng"];
}

- (CGFloat)getLng
{
    return [[self getValueWithKey:@"lng"] floatValue];
}

//设置和获取机构的维度
- (void)setLat:(CGFloat)lat
{
    [self setValue:[NSNumber numberWithFloat:lat] key:@"lat"];
}

- (CGFloat)getLat
{
    return [[self getValueWithKey:@"lat"] floatValue];
}

//设置和获取操作权限
- (void)setOperable:(NSInteger)operable
{
    [self setValue:[NSNumber numberWithInteger:operable] key:@"operable"];
}

- (NSInteger)getOperable
{
    return [[self getValueWithKey:@"operable"] integerValue];
}

//设置和获取上一次使用的车辆
- (void)setLastVehicle:(NSString *)info
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_vehicle_%@", userId];
    [self setValue:info key:key];
}

- (NSString *)getLastVehicle
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_vehicle_%@", userId];
    return [self getValueWithKey:key];
}

//设置和获取上一次使用的车辆的运载量
- (void)setLastVehicleLoad:(NSString *)load
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_vehicle_load_%@", userId];
    [self setValue:load key:key];
}

- (NSString *)getLastVehicleLoad
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_vehicle_load_%@", userId];
    return [self getValueWithKey:key];
}

//设置和获取上次使用车辆信息

- (void)setLastVehicleId:(NSString *)vehicleId
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_vehicle_id_%@", userId];
    [self setValue:vehicleId key:key];
}

- (NSString *)getLastVehicleId
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_vehicle_id_%@", userId];
    return [self getValueWithKey:key];
}

//设置和获取上一次使用的泵车车辆
- (void)setLastPump:(NSString *)info
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_pump_%@", userId];
    [self setValue:info key:key];
}

- (NSString *)getLastPump
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_pump_%@", userId];
    return [self getValueWithKey:key];
}

//设置和获取上次使用的泵车id
- (void)setLastPumpId:(NSString *)pumpId
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_pump_id_%@", userId];
    [self setValue:pumpId key:key];
}

- (NSString *)getLastPumpId
{
    NSString *userId = [self getUserId];
    NSString *key = [NSString stringWithFormat:@"last_pump_id_%@", userId];
    return [self getValueWithKey:key];
}

//设置和获取帮助链接
- (void)setHelpLink:(NSString *)url
{
    [self setValue:url key:@"help"];
}

- (NSString *)getHelpLink;
{
    return [self getValueWithKey:@"help"];
}

//设置和获取server
- (void)setServer:(NSString *)server
{
    [self setValue:server key:@"server"];
}

- (NSString *)getServer
{
    return [self getValueWithKey:@"server"];
}


#pragma mark -- common method

- (void)setValue:(NSObject *)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (id)getValueWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
