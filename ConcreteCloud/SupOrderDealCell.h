//
//  SupOrderDealCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupOrderDealCell_h
#define SupOrderDealCell_h

@protocol SupOrderDealCellDelegate <NSObject>

- (void)onClickOk;

- (void)onClickCancel;

@end

@interface SupOrderDealCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setCurrentMode;

- (void)setPassMode:(BOOL)pass;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) id<SupOrderDealCellDelegate> delegate;

@end


#endif /* SupOrderDealCell_h */
