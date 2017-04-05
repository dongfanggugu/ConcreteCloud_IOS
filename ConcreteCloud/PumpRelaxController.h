//
//  PumpRelaxController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PumpRelaxController_h
#define PumpRelaxController_h

#import "HzsVehicleListController.h"
#import "DTrackInfo.h"
#import "RentVehicleInfo.h"
#import "BaseViewController.h"

@protocol PumpRelaxControllerDelegate <NSObject>

- (void)onClickStartUp:(DTrackInfo *)trackInfo;

- (void)onClickVehicleModify:(UILabel *)lbVehicle type:(Vehicle_type)type;

@end

@interface PumpRelaxController : BaseViewController

@property (weak, nonatomic) id<PumpRelaxControllerDelegate> delegate;



@end


#endif /* PumpRelaxController_h */
