//
//  HzsAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsAnnotationView_h
#define HzsAnnotationView_h

#import "CustomAnnotationView.h"
#import "HzsInfoView.h"
#import "HzsInfo.h"

@interface HzsAnnotationView : CustomAnnotationView

- (void)addOnBtnClickListenner:(void(^)())onClickBtn;

@property (strong, nonatomic) HzsInfoView *infoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) HzsInfo *info;

@property (strong, nonatomic) UIColor *color;

//隐藏操作按钮
@property (assign, nonatomic) BOOL hideOperation;

@end


#endif /* HzsAnnotationView_h */
