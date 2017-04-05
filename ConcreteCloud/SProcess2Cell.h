//
//  SProcess2Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SProcess2Cell_h
#define SProcess2Cell_h

@interface SProcess2Cell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setFutureMode;

- (void)setCurrentMode;

- (void)setPassMode;

@property (weak, nonatomic) IBOutlet UILabel *lbConfirmUser;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end



#endif /* SProcess2Cell_h */
