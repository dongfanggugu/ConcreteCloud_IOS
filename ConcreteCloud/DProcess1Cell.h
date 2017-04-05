//
//  DProcess1Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcess1Cell_h
#define DProcess1Cell_h

@protocol DProcess1CellDelegate <NSObject>

- (void)onClickOK;

- (void)onClickCancel;

@end

@interface DProcess1Cell : UITableViewCell

+ (id)cellFromNib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

- (void)setCurrentMode;

- (void)setPassMode;


@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbProject;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbCompany;

@property (weak, nonatomic) IBOutlet UILabel *lbLinkMan;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) id<DProcess1CellDelegate> delegate;

@end

#endif /* DProcess1Cell_h */
