//
//  VideoListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VideoListResponse_h
#define VideoListResponse_h

#import "ResponseArray.h"
#import "VideoInfo.h"

@interface VideoListResponse : ResponseArray

- (NSArray<VideoInfo *> *)getVideoList;

@end


#endif /* VideoListResponse_h */
