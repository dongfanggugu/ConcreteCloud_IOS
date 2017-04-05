//
//  ProjectCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProjectCell_h
#define ProjectCell_h

@interface ProjectCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbUser;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end

#endif /* ProjectCell_h */
