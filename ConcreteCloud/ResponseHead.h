//
//  ResponseHead.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ResponseHead_h
#define ResponseHead_h

#import <Jastor.h>

@interface ResponseHead : Jastor

@property (strong, nonatomic) NSString *accessToken;

@property (strong, nonatomic) NSString *rspCode;

@property (strong, nonatomic) NSString *rspMsg;

@end


#endif /* ResponseHead_h */
