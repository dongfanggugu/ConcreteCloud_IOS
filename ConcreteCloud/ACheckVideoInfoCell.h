//
//  ACheckVideoInfoCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ACheckVideoInfoCell_h
#define ACheckVideoInfoCell_h

@interface ACheckVideoInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbPlateNum;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbCurrent;

@property (weak, nonatomic) IBOutlet UILabel *lbType;

@property (weak, nonatomic) IBOutlet UILabel *lbChecker;

@property (copy, nonatomic) NSString *urlStr;

@end

#endif /* ACheckVideoInfoCell_h */
