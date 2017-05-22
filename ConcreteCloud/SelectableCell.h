//
//  SelectableCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/9.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SelectableCell_h
#define SelectableCell_h

#import "ListDialogView.h"


@interface SelectableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

+ (id)viewFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)getIdentifier;

- (void)setView:(UIView *)view data:(NSArray<ListDialogDataDelegate> *)arrayData __deprecated_msg("已过期");

- (void)setData:(NSArray<id<ListDialogDataDelegate>> *)arrayData;

- (NSString *)getContentValue;

- (void)setContentValue:(NSString *)content;

- (NSString *)getKeyValue;

- (void)setKeyValue:(NSString *)key;

- (void)setAfterSelectedListener:(void(^)(NSString *key, NSString *content))selection;

@end

#endif /* SelectableCell_h */
