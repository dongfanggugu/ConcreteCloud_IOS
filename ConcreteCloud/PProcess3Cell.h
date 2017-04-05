//
//  PProcess3Cell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PProcess3Cell_h
#define PProcess3Cell_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "PProcessList.h"

@protocol PProcess3CellDelegate <NSObject>

- (void)onClickMap;

- (void)onClickDetail;

@end


@interface PProcess3Cell : UITableViewCell

+ (instancetype)cellFromNib;

+ (CGFloat)cellHeight;

- (void)setFutureMode;

- (void)setPassMode;

- (void)setCurrentMode;

- (void)setTotal:(CGFloat)total complete:(CGFloat)complete way:(CGFloat)way;

- (void)markOnMap:(PProcessList *)process;

- (void)setSupplierMode;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) id<PProcess3CellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewTotal;

@end


#endif /* PProcess3Cell_h */
