//
//  CarryInfoCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef CarryInfoCell_h
#define CarryInfoCell_h

@interface CarryInfoCell : UITableViewCell

- (void)setOnClickVideo:(void(^)())onClickVideo;

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbGoods;

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbDriver;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbWeight;

@end

#endif /* CarryInfoCell_h */
