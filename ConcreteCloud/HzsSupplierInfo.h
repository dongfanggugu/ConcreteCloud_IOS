//
//  HzsSupplierInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Jastor.h>
#import "PTrackInfo.h"
#import "SupplierInfo.h"

@interface HzsSupplierInfo : Jastor

@property (strong, nonatomic) NSArray<SupplierInfo *> *supplierList;

@property (strong, nonatomic) NSArray<PTrackInfo *> *taskList;

@end
