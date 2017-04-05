//
//  StatisticsSelView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef StatisticsSelView_h
#define StatisticsSelView_h

@protocol StatisticsSelViewDelegate <NSObject>

- (void)onClickAgent;

- (void)onClickYesterday;

- (void)onClickMonth;

- (void)onClickYear;

@end

@interface StatisticsSelView : UIView

+ (id)viewFromNib;

- (void)initBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@property (weak, nonatomic) IBOutlet UIButton *btnAgent;

@property (weak, nonatomic) id<StatisticsSelViewDelegate> delegate;

@end


#endif /* StatisticsSelView_h */
