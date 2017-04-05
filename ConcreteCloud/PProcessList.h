//
//  PProcessList.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PProcessList_h
#define PProcessList_h

#import <Jastor.h>
#import "SupplierInfo.h"
#import "HzsInfo.h"
#import "PTrackInfo.h"

@interface PProcessList : Jastor

@property (strong, nonatomic) SupplierInfo *supplier;

@property (strong, nonatomic) HzsInfo *hzs;

@property (strong, nonatomic) NSArray<PTrackInfo *> *info;

@end


#endif /* PProcessList_h */
