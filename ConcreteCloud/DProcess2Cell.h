//
//  DProcess2Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcess2Cell_h
#define DProcess2Cell_h

@interface DProcess2Cell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setFutureMode;

- (void)setCurrentMode;

- (void)setPassMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end


#endif /* DProcess2Cell_h */
