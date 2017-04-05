//
//  DOrderItemCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderItemCell_h
#define DOrderItemCell_h

@interface DOrderItemCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;


@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbGoods;

@property (weak, nonatomic) IBOutlet UILabel *lbPart;

@property (weak, nonatomic) IBOutlet UILabel *lbStrength;

@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@end

#endif /* DOrderItemCell_h */
