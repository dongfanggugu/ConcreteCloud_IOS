//
//  VehicleInfoView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VehicleInfoView_h
#define VehicleInfoView_h

@interface VehicleInfoView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbLoad;

@property (weak, nonatomic) IBOutlet UILabel *lbDriver;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

- (void)setOnClickDetailListener:(void(^)())onClickDetail;

- (void)addOnCloseClickListener:(void(^)())onClickClose;

@end

#endif /* VehicleInfoView_h */
