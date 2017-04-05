//
//  PSubmitCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PSubmitCell_h
#define PSubmitCell_h

@interface PSubmitCell : UITableViewCell

+ (instancetype)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHight;

- (void)setPassMode;

- (void)setCurrentMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbSupplier;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end

#endif /* PSubmitCell_h */
