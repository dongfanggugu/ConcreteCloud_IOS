//
//  PProcess4Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PProcess4Cell_h
#define PProcess4Cell_h

@protocol PProcess4CellDelegate <NSObject>

- (void)onClickComplete;

@end

@interface PProcess4Cell : UITableViewCell

+ (instancetype)cellFromNib;

+ (CGFloat)cellHeight;

- (void)setSiteRole;

- (void)setPassMode;

- (void)setSupplierMode;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) id<PProcess4CellDelegate> delegate;

@end


#endif /* PProcess4Cell_h */
