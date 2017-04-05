//
//  SProcess1Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SProcess1Cell_h
#define SProcess1Cell_h

@interface SProcess1Cell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)setCurrentMode;

- (void)setPassMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@end

#endif /* SProcess1Cell_h */
