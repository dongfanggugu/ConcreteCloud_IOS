//
//  HzsSiteListInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsSiteListInfo_h
#define HzsSiteListInfo_h

#import <Jastor.h>
#import "ProjectInfo.h"
#import "DTrackInfo.h"
#import "HzsInfo.h"

@interface HzsSiteListInfo : Jastor

//搅拌站获取工地列表
@property (strong, nonatomic) NSArray<ProjectInfo *> *siteList;

@property (strong, nonatomic) NSArray<DTrackInfo *> *vehicleList;

//工地获取搅拌站列表
@property (strong, nonatomic) NSArray<HzsInfo *> *hzsList;

@property (strong, nonatomic) NSArray<DTrackInfo *> *taskList;


@end

#endif /* HzsSiteListInfo_h */
