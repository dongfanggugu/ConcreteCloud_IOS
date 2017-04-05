//
//  TitleSegmentView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/6.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TitleSegmentView_h
#define TitleSegmentView_h

@protocol TitleSegmentViewDelegate <NSObject>

- (void)onClickLeft;

- (void)onClickRight;

@end

@interface TitleSegmentView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) id<TitleSegmentViewDelegate> delegate;

/**
 设置左右标签的内容
 **/
- (void)setTitleOfLeft:(NSString *)left right:(NSString *)right;

@end


#endif /* TitleSegmentView_h */
