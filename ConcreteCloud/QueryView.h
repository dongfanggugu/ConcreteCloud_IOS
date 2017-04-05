//
//  QueryView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef QueryView_h
#define QueryView_h

#define QV_TF_INIT @"点击图标选择日期"

@protocol QueryViewDelegate<NSObject>

- (void)onClickQueryStart:(NSString *)start end:(NSString *)end;

- (void)onSelFrom:(UITextField *)tfFrom;

- (void)onSelTo:(UITextField *)tfTo;

@end

@interface QueryView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) id<QueryViewDelegate> delegate;

@end


#endif /* QueryView_h */
