//
//  DOrderDetailCell1.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderDetailCell1_h
#define DOrderDetailCell1_h

@interface DOrderDetailCell1 : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;


@property (weak, nonatomic) IBOutlet UILabel *lbUser;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end


#endif /* DOrderDetailCell1_h */
