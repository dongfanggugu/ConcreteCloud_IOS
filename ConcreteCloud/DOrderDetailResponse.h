//
//  DOrderDetailResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DOrderDetailResponse_h
#define DOrderDetailResponse_h

#import "ResponseDictionary.h"
#import "DOrderInfo.h"

@interface DOrderDetailResponse : ResponseDictionary

- (DOrderInfo *)getOrderInfo;

@end

#endif /* DOrderDetailResponse_h */
