//
//  CZBInfoView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef CZBInfoView_h
#define CZBInfoView_h

@interface CZBInfoView : UIView

+ (id)viewFromNib;

- (void)addBtnClickListenner:(void(^)())onClickBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbWeight;

@property (weak, nonatomic) IBOutlet UILabel *lbAbility;

@property (weak, nonatomic) IBOutlet UILabel *lbRenter;

@property (weak, nonatomic) IBOutlet UILabel *lbCharity;

@property (weak, nonatomic) IBOutlet UILabel *lbCharityTel;

@property (weak, nonatomic) IBOutlet UILabel *lbDrvierTel;

@end

#endif /* CZBInfoView_h */
