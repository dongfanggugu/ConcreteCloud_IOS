//
//  PProcessData.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef PProcessData_h
#define PProcessData_h

#import <Jastor.h>

@interface ProcessInfo : Jastor

//运送中的量
@property (assign, nonatomic) NSString *is;


@end


#pragma mark - PProcessData

@interface PProcessData : Jastor

@property (assign, nonatomic) CGFloat number;

@property (strong, nonatomic) ProcessInfo *suppOrder;

@end

#endif /* PProcessData_h */
