//
//  RentTaskCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentTaskCell_h
#define RentTaskCell_h

@interface RentTaskCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbSite;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbDriver;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbPart;

@property (weak, nonatomic) IBOutlet UILabel *lbLevel;

@end


#endif /* RentTaskCell_h */
