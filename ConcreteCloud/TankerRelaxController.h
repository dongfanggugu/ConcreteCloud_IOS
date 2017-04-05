//
//  TankerRelaxController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TankerRelaxController_h
#define TankerRelaxController_h

#import "HzsVehicleListController.h"
#import "DTrackInfo.h"

@protocol TankerRelaxControllerDelegate <NSObject>

@optional

- (void)onClickStartUp:(DTrackInfo *)trackInfo;

- (void)onClickVehicleModify:(UILabel *)lbVehicle weight:(UILabel *)lbWeight type:(Vehicle_type)type;

@end

@interface TankerRelaxController : BaseViewController

@property (weak, nonatomic) id<TankerRelaxControllerDelegate> delegate;

@end


#endif /* TankerRelaxController_h */
