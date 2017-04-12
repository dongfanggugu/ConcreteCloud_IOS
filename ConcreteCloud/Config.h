//
//  Config.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/28.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Config_h
#define Config_h

@interface Config : NSObject

+ (instancetype)shareConfig;

//设置和获取用户名
- (void)setUserName:(NSString *)userName;

- (NSString *)getUserName;

//设置和获取角色id
- (void)setRole:(NSString *)role;

- (NSString *)getRole;

//获取角色名称
- (NSString *)getRoleName;

//设置和获取accessToken
- (void)setToken:(NSString *)token;

- (NSString *)getToken;


//设置和获取userId
- (void)setUserId:(NSString *)userId;

- (NSString *)getUserId;

//设置和获取用户姓名
- (void)setName:(NSString *)name;

- (NSString *)getName;

//设置和获取机构id
- (void)setBranchId:(NSString *)branchId;

- (NSString *)getBranchId;

//设置和获取人员机构type
- (void)setType:(NSString *)type;

- (NSString *)getType;

//设置和获取机构名称
- (void)setBranchName:(NSString *)branchName;

- (NSString *)getBranchName;

//设置和获取机构地址
- (void)setBranchAddress:(NSString *)address;

- (NSString *)getBranchAddress;

//设置和获取机构的logo
- (void)setBranchLogo:(NSString *)logo;

- (NSString *)getBranchLogo;

//设置和获取机构的经度
- (void)setLng:(CGFloat)lng;

- (CGFloat)getLng;

//设置和获取机构的维度
- (void)setLat:(CGFloat)lat;

- (CGFloat)getLat;

//设置和获取操作权限
- (void)setOperable:(BOOL)operable;

- (BOOL)getOperable;

//设置和获取上一次使用的罐车车辆
- (void)setLastVehicle:(NSString *)info;

- (NSString *)getLastVehicle;

//设置和获取上一次使用的罐车车辆的运载量
- (void)setLastVehicleLoad:(NSString *)load;

- (NSString *)getLastVehicleLoad;

//设置和获取上次使用罐车车辆id
- (void)setLastVehicleId:(NSString *)vehicleId;

- (NSString *)getLastVehicleId;

//设置和获取上一次使用的泵车车辆
- (void)setLastPump:(NSString *)info;

- (NSString *)getLastPump;

//设置和获取上次使用的泵车id
- (void)setLastPumpId:(NSString *)pumpId;

- (NSString *)getLastPumpId;

//设置和获取帮助链接
- (void)setHelpLink:(NSString *)url;

- (NSString *)getHelpLink;

//设置和获取server
- (void)setServer:(NSString *)server;

- (NSString *)getServer;

@end


#endif /* Config_h */
