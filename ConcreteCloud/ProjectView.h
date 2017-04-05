//
//  ProjectView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProjectView_h
#define ProjectView_h

@interface ProjectView : UIView

+ (id)viewFromNib;


@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbDistance;


@end

#endif /* ProjectView_h */
