//
//  TankerOnWayController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TankerOnWayController_h
#define TankerOnWayController_h

#import "DTrackInfo.h"
#import "RentVehicleInfo.h"
#import "BaseViewController.h"

@protocol TankerOnWayControllerDelegate <NSObject>

- (void)onClickArrived:(DTrackInfo *)trackInfo;

@optional
- (void)onClickCancel;

@end

@interface TankerOnWayController : BaseViewController

@property (strong, nonatomic) DTrackInfo *trackInfo;

@property (weak, nonatomic) id<TankerOnWayControllerDelegate> delegate;

@end


#endif /* TankerOnWayController_h */
