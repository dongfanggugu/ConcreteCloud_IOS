//
//  GcInfoView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef GcInfoView_h
#define GcInfoView_h

@interface GcInfoView : UIView

+ (id)viewFromNib;

- (void)addBtnClickListenner:(void(^)())onClickBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbWeight;

@property (weak, nonatomic) IBOutlet UILabel *lbLoad;

@property (weak, nonatomic) IBOutlet UILabel *lbRenter;

@property (weak, nonatomic) IBOutlet UILabel *lbCharity;

@property (weak, nonatomic) IBOutlet UILabel *lbCharityTel;

@property (weak, nonatomic) IBOutlet UILabel *lbDrvierTel;

@end

#endif /* GcInfoView_h */
