//
//  TankerArrivedController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TankerArrivedController_h
#define TankerArrivedController_h

#import "DTrackInfo.h"
#import "RentVehicleInfo.h"
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, Arrived_Type)
{
    ARRIVED_TANKER,
    ARRIVED_PUMP
};

@protocol TankerArrivedControllerDelegate <NSObject>

- (void)onClickHzs;

- (void)onClickCancel;

@optional

- (void)onClickRecord:(DTrackInfo *)trackInfo;

@end

@interface TankerArrivedController : BaseViewController

@property (strong, nonatomic) DTrackInfo *trackInfo;

@property (weak, nonatomic) id<TankerArrivedControllerDelegate> delegate;

@property (assign, nonatomic) Arrived_Type arrayType;

@end

#endif /* TankerArrivedController_h */
