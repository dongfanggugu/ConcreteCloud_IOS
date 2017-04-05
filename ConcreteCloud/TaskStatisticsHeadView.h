//
//  TaskStatisticsHeadView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaskStatisticsHeadView_h
#define TaskStatisticsHeadView_h

@protocol TaskStatisticsHeadViewDelegate <NSObject>

- (void)onClickMonth;

- (void)onClickYear;

- (void)onClickCustom;

@end

@interface TaskStatisticsHeadView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) id<TaskStatisticsHeadViewDelegate> delegate;

@end


#endif /* TaskStatisticsHeadView_h */
