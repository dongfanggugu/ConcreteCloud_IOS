//
//  RenterView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RenterView_h
#define RenterView_h

@interface RenterView : UIView

+ (id)viewFromNib;


@property (weak, nonatomic) IBOutlet UILabel *lbRenter;

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;

@end

#endif /* RenterView_h */
