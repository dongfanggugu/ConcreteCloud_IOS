//
//  PProcess2Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PProcess2Cell_h
#define PProcess2Cell_h

@interface PProcess2Cell : UITableViewCell

+ (instancetype)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setFutureMode;

- (void)setPassMode;

- (void)setCurrentMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end

#endif /* PProcess2Cell_h */
