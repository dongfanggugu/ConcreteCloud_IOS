//
//  DOrderListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderListResponse_h
#define DOrderListResponse_h

#import "ResponseArray.h"
#import "DOrderInfo.h"

@interface DOrderListResponse : ResponseArray

- (NSArray<DOrderInfo *> *)getOrderList;

@end

#endif /* DOrderListResponse_h */
