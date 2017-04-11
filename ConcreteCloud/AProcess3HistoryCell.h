//
//  AProcess3HistoryCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/11.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AProcess3HistoryCellDelegate <NSObject>

- (void)onClickDetail;

@end

@interface AProcess3HistoryCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) id<AProcess3HistoryCellDelegate> delegate;

@end
