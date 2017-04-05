//
//  POrderItemView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef POrderItemView_h
#define POrderItemView_h

@interface POrderItemView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbSupplier;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbGoods;

@property (weak, nonatomic) IBOutlet UILabel *lbConfirm;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAdress;

+ (id)viewFromNib;

+ (NSString *)getIdentifier;

@end


#endif /* POrderItemView_h */
