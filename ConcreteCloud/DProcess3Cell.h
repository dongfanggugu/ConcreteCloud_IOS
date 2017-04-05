//
//  DProcess3Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcess3Cell_h
#define DProcess3Cell_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "DProcessList.h"

@protocol DProcess3CellDelegate <NSObject>

- (void)onClickMap;

- (void)onClickDetail;

- (void)onClickCarry;

@end


@interface DProcess3Cell : UITableViewCell

+ (instancetype)cellFromNib;

+ (CGFloat)cellHeight;

+ (CGFloat)cellHeightSite;

- (void)setFutureMode;

- (void)setPassMode;

- (void)setCurrentMode;

//工地角色显示模式，需要在设置过去，现在，未来模式之后调用才会生效
- (void)setSiteRole;

- (void)setTotal:(CGFloat)total complete:(CGFloat)complete way:(CGFloat)way;

- (void)markOnMap:(DProcessList *)process;

- (void)setCarryHiden:(BOOL)hiden;


@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) id<DProcess3CellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewTotal;

@end

#endif /* DProcess3Cell_h */
