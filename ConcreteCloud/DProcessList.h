//
//  DProcessList.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DProcessList_h
#define DProcessList_h

#import <Jastor.h>
#import "HzsInfo.h"
#import "ProjectInfo.h"
#import "DTrackInfo.h"

@interface DProcessList : Jastor

@property (strong, nonatomic) HzsInfo *hzs;

@property (strong, nonatomic) ProjectInfo *site;

@property (strong, nonatomic) NSArray<DTrackInfo *> *process;

@end


#endif /* DProcessList_h */
