//
//  SiteInfoView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SiteInfoView_h
#define SiteInfoView_h


@interface SiteInfoView : UIView

+ (id)viewFromNib;

- (CGFloat)viewHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbSiteName;

@property (weak, nonatomic) IBOutlet UILabel *lbContactUser;

@property (weak, nonatomic) IBOutlet UILabel *lbContactTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end


#endif /* SiteInfoView_h */
