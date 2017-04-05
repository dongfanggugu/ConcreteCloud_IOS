//
//  TitleVIewController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TitleVIewController_h
#define TitleVIewController_h

#import "BaseViewController.h"


@interface TitleViewController : BaseViewController

- (void)setNaviTitle:(NSString *)title;

/**
 使用文字初始化导航栏右侧按钮
 **/
-  (void)initNavRightWithText:(NSString *)text;

/**
 使用图标初始化导航栏右侧按钮
 **/
- (void)initNavRightWithImage:(UIImage *)image;

/**
 添加segment标题
**/
- (void)setSegmentTitleLeft:(NSString *)left right:(NSString *)right;

/**
 点击左侧标签
 **/
- (void)onClickLeftSegment;

/**
 点击右侧标签
 **/
- (void)onClickRightSegment;

/**
 点击导航栏右侧按钮
 **/
- (void)onClickNavRight;


/**
 初始化导航栏左侧按钮

 @param text 按钮标题
 */
- (void)initNaviLeftWithText:(NSString *)text;
/**
 点击导航栏左侧按钮
 */
- (void)onClickNaviLeft;

/**
 设置标签名字
 **/
- (void)setNavLabel:(NSString *)label;

- (UIView *)getNavigationBar;

@end


#endif /* TitleVIewController_h */
