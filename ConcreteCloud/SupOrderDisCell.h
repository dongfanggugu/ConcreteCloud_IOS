//
//  SupOrderDisCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupOrderDisCell_h
#define SupOrderDisCell_h

@protocol SupOrderDisCellDelegate <NSObject>

- (void)onClickDispatch;

@end

@interface SupOrderDisCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

- (void)setFutureMode;

- (void)setCurrentMode;

- (void)setPassMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) id<SupOrderDisCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnDis;

@end


#endif /* SupOrderDisCell_h */
