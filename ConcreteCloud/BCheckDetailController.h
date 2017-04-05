//
//  BCheckDetailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef BCheckDetailController_h
#define BCheckDetailController_h

#import "TitleViewController.h"
#import "PTrackInfo.h"


@interface BCheckDetailController : TitleViewController

@property (strong, nonatomic) PTrackInfo *trackInfo;

@property (assign, nonatomic) BOOL isHistory;

@end


#endif /* BCheckDetailController_h */
