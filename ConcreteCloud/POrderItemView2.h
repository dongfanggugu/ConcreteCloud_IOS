//
//  POrderItemView2.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/6.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef POrderItemView2_h
#define POrderItemView2_h

@interface POrderItemView2 : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbSupplier;

@property (weak, nonatomic) IBOutlet UILabel *lbGoods;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

+ (id)viewFromNib;

+ (CGFloat)itemHeight;

+ (NSString *)getIdentifier;

@end


#endif /* POrderItemView2_h */
