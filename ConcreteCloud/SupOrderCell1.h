//
//  SupOrderCell1.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupOrderCell1_h
#define SupOrderCell1_h

@interface SupOrderCell1 : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbHzs;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;

@property (weak, nonatomic) IBOutlet UILabel *lbPerson;

@end


#endif /* SupOrderCell1_h */
