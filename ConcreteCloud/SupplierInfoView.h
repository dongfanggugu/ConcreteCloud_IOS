//
//  SupplierInfoView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupplierInfoView_h
#define SupplierInfoView_h

@interface SupplierInfoView : UIView

+ (id)viewFromNib;

- (CGFloat)viewHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbSupplierName;

@property (weak, nonatomic) IBOutlet UILabel *lbContactUser;

@property (weak, nonatomic) IBOutlet UILabel *lbContactTel;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end


#endif /* SupplierInfoView_h */
