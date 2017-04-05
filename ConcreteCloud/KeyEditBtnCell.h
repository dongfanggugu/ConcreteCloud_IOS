//
//  KeyEditBtnCell.h
//  owner
//
//  Created by 长浩 张 on 2017/3/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef KeyEditBtnCell_h
#define KeyEditBtnCell_h

@interface KeyEditBtnCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setOnClickBtnListener:(void(^)())onClick;

- (void)setBtnImage;

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UITextField *tfValue;


@end



#endif /* KeyEditBtnCell_h */
