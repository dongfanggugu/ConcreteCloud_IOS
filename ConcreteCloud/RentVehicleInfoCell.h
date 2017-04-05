//
//  RentVehicleInfoCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleInfoCell_h
#define RentVehicleInfoCell_h

@interface RentVehicleInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbType;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;

@end


#endif /* RentVehicleInfoCell_h */
