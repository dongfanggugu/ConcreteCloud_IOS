//
//  HzsSiteListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsSiteListResponse_h
#define HzsSiteListResponse_h

#import "ResponseDictionary.h"
#import "HzsSiteListInfo.h"

@interface HzsSiteListResponse : ResponseDictionary

- (HzsSiteListInfo *)getHzsSiteInfo;

@end


#endif /* HzsSiteListResponse_h */
