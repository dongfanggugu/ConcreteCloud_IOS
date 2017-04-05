//
//  KeyValueBtnCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef KeyValueBtnCell_h
#define KeyValueBtnCell_h


@interface KeyValueBtnCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)addOnClickListener:(void(^)())onClick;

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbValue;


@end


#endif /* KeyValueBtnCell_h */
