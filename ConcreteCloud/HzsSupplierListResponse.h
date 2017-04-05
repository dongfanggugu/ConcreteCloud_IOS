//
//  HzsSupplierListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ResponseDictionary.h"
#import "HzsSupplierInfo.h"

@interface HzsSupplierListResponse : ResponseDictionary

- (HzsSupplierInfo *)getHzsSupllierInfo;

@end
