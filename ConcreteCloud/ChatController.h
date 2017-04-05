//
//  ChatController.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/27.
//
//

#ifndef ChatController_h
#define ChatController_h

#import "TitleViewController.h"

@interface ChatController : TitleViewController

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (assign, nonatomic) BOOL noTabBar;

@end


#endif /* ChatController_h */
