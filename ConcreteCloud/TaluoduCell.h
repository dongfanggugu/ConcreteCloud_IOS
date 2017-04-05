//
//  TaluoduCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaluoduCell_h
#define TaluoduCell_h

#import "ListDialogView.h"

@interface TaluoduCell : UITableViewCell


+ (id)viewFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)setView:(UIView *)view data:(NSArray<ListDialogDataDelegate> *)arrayData;

- (NSString *)getLeftContentValue;

- (NSString *)getRightContentValue;

- (void)setLeftContentValue:(NSString *)content;

- (void)setRightContentValue:(NSString *)content;

- (void)setLeftAfterSelectedListener:(void(^)(NSString *key, NSString *content))selection;

- (void)setRightAfterSelectedListener:(void(^)(NSString *key, NSString *content))selection;

@end


#endif /* TaluoduCell_h */
