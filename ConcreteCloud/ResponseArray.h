//
//  ResponseArray.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/5.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ResponseArray_h
#define ResponseArray_h

#import "ResponseHead.h"
#import <Jastor.h>

@interface ResponseArray : Jastor

@property (strong, nonatomic) ResponseHead *head;

@property (strong, nonatomic) NSArray *body;

@end

#endif /* ResponseArray_h */
