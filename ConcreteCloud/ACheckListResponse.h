//
//  ACheckListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ACheckListResponse_h
#define ACheckListResponse_h

#import "ResponseArray.h"
#import "DTrackInfo.h"


@interface ACheckListResponse : ResponseArray

- (NSArray<DTrackInfo *> *)getCheckList;

@end

#endif /* ACheckListResponse_h */
