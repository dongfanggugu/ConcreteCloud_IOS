//
//  SupplierAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "SupplierInfoView.h"
#import "SupplierInfo.h"

@interface SupplierAnnotationView : CustomAnnotationView

@property (strong, nonatomic) SupplierInfoView *infoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) SupplierInfo *info;

@property (assign, nonatomic) UIColor *color;

@end
