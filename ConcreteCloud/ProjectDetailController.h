//
//  ProjectDetailController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProjectDetailController_h
#define ProjectDetailController_h

#import "TitleViewController.h"
#import "ProjectInfo.h"

@interface ProjectDetailController : TitleViewController

@property (strong, nonatomic) ProjectInfo *projectInfo;

@property (assign, nonatomic) BOOL isAuthed;

@end

#endif /* ProjectDetailController_h */
