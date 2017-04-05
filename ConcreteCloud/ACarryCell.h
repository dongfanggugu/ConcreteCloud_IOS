//
//  ACarryCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/30.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACarryCell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)setOnClickExamVideoListener:(void(^)())onClick;

- (void)setOnClickSpotVideoListener:(void(^)())onClick;

@property (weak, nonatomic) IBOutlet UILabel *lbCode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbPlate;

@property (weak, nonatomic) IBOutlet UILabel *lbCurNum;

@end
