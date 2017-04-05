//
//  ACheckVideoCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ACheckVideoCell_h
#define ACheckVideoCell_h

@interface ACheckVideoCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (copy, nonatomic) NSString *url;

@end


#endif /* ACheckVideoCell_h */
