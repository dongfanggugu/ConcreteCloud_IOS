//
//  Response.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Response_h
#define Response_h

#import <Jastor.h>
#import "ResponseHead.h"

@interface ResponseDictionary : Jastor

@property (strong, nonatomic) ResponseHead *head;

@property (strong, nonatomic) NSDictionary *body;

@end



#endif /* Response_h */
