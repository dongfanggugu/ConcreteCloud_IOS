//
//  ProjectListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProjectListResponse_h
#define ProjectListResponse_h

#import "ResponseArray.h"
#import "ProjectInfo.h"

@interface ProjectListResponse : ResponseArray

- (NSArray<ProjectInfo *> *)getProjectList;

@end

#endif /* ProjectListResponse_h */
