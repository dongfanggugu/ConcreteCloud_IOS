//
//  RentTankerRelaxController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentTankerRelaxController_h
#define RentTankerRelaxController_h

#import "BaseViewController.h"
#import "RentTankerProcessController.h"

#import "DTrackInfo.h"

@protocol RentTankerRelaxControllerDelegate <NSObject>

- (void)onClickStartUp:(DTrackInfo *)trackInfo;

@end

@interface RentTankerRelaxController : BaseViewController<RentTankerProcessControllerDelegate>

@property (weak, nonatomic) id<RentTankerRelaxControllerDelegate> delegate;

@property (strong, nonatomic) RentVehicleInfo *vehicleInfo;


@end


#endif /* RentTankerRelaxController_h */
