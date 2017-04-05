//
//  KeyMultiEditCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef KeyMultiEditCell_h
#define KeyMultiEditCell_h

@interface KeyMultiEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@property (weak, nonatomic) IBOutlet UILabel *lbPlaceHolder;

+ (id)viewFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)getIdentifier;

@end


#endif /* KeyMultiEditCell_h */
