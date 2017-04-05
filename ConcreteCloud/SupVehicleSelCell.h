//
//  SupVehicleSelCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupVehicleSelCell_h
#define SupVehicleSelCell_h


@protocol SupVehicleSelCellDelegate <NSObject>

- (void)onClickBtn:(UIButton *)btn;


- (void)onChangeSwitch:(UISwitch *)swSel;

@end

@interface SupVehicleSelCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbLoad;

@property (weak, nonatomic) IBOutlet UILabel *lbDriver;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UISwitch *swSel;

@property (weak, nonatomic) id<SupVehicleSelCellDelegate> delegate;

@end


#endif /* SupVehicleSelCell_h */
