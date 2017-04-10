//
//  HzsInfoView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsInfoView_h
#define HzsInfoView_h

@interface HzsInfoView : UIView

+ (id)viewFromNib;

- (CGFloat)viewHeight;

- (void)addOnBtnClickListener:(void(^)())onClickBtn;

- (void)addOnCloseClickListener:(void(^)())onClickClose;


@property (weak, nonatomic) IBOutlet UILabel *lbHzsName;

@property (weak, nonatomic) IBOutlet UILabel *lbContactUser;

@property (weak, nonatomic) IBOutlet UILabel *lbContactTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@property (weak, nonatomic) IBOutlet UILabel *lbDis;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end


#endif /* HzsInfoView_h */
