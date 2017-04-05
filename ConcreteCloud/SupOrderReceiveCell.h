//
//  SupOrderReceiveCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupOrderReceiveCell_h
#define SupOrderReceiveCell_h

@interface SupOrderReceiveCell : UITableViewCell

+ (instancetype)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHight;

- (void)setPassMode;

- (void)setCurrentMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbHzs;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end



#endif /* SupOrderReceiveCell_h */