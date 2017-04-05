//
//  HzsAddTaskResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsAddTaskResponse_h
#define HzsAddTaskResponse_h

#import "ResponseDictionary.h"
#import "DTrackInfo.h"

@interface HzsAddTaskResponse : ResponseDictionary

- (DTrackInfo *)getHzsTask;

@end

#endif /* HzsAddTaskResponse_h */
