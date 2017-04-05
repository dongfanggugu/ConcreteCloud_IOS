//
//  PersonHeaderView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PersonHeaderView_h
#define PersonHeaderView_h

@interface PersonHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbRole;

+ (id)viewFromNib;

@end


#endif /* PersonHeaderView_h */
