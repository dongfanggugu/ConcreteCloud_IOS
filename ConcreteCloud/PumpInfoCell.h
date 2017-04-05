//
//  PumpInfoCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PumpInfoCell_h
#define PumpInfoCell_h

@interface PumpInfoCell : UITableViewCell

+ (id)cellFromView;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbHzs;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbDriver;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbPart;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel;

@end

#endif /* PumpInfoCell_h */
