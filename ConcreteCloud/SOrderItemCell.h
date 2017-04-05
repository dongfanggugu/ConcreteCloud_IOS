//
//  SOrderItemCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SOrderItemCell_h
#define SOrderItemCell_h

@interface SOrderItemCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbHzs;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbGoods;

@property (weak, nonatomic) IBOutlet UILabel *lbStrength;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end

#endif /* SOrderItemCell_h */
