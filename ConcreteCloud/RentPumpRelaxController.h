//
//  RentPumpRelaxController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentPumpRelaxController_h
#define RentPumpRelaxController_h

#import "BaseViewController.h"
#import "RentPumpProcessController.h"

#import "DTrackInfo.h"

@protocol RentPumpRelaxControllerDelegate <NSObject>

- (void)onClickStartUp:(DTrackInfo *)trackInfo;

@end

@interface RentPumpRelaxController : BaseViewController<RentPumpProcessControllerDelegate>

@property (weak, nonatomic) id<RentPumpRelaxControllerDelegate> delegate;

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;


@end


#endif /* RentPumpRelaxController_h */
