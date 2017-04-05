//
//  ACheckDetailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ACheckDetailController_h
#define ACheckDetailController_h

#import "TitleViewController.h"
#import "DTrackInfo.h"

typedef NS_ENUM(NSInteger, Check_Type)
{
    HZS,
    SITE,
    HISTORY
};

@interface ACheckDetailController : TitleViewController

@property (strong, nonatomic) DTrackInfo *trackInfo;

@property (assign, nonatomic) Check_Type checkType;

@end


#endif /* ACheckDetailController_h */
