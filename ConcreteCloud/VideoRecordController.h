//
//  VideoRecordController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VideoRecordController_h
#define VideoRecordController_h

#import "TitleViewController.h"

typedef NS_ENUM(NSInteger, Video_Type)
{
    IN_EXAM_VIDEO,
    OUT_EXAM_VIDEO,
    SPOT_VIDEO
};


@protocol VideoRecordControllerDelegate <NSObject>

- (void)onUploadVideo:(NSString *)url videoKey:(NSString *)videoKey;

@end

@interface VideoRecordController : TitleViewController

@property (copy, nonatomic) NSString *videoKey;

@property (weak, nonatomic) id<VideoRecordControllerDelegate> delegate;

@end


#endif /* VideoRecordController_h */
