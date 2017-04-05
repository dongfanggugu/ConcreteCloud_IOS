//
//  ASiteCheckInfoCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ASiteCheckInfoCell_h
#define ASiteCheckInfoCell_h

@interface ASiteCheckInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@end


#endif /* ASiteCheckInfoCell_h */
