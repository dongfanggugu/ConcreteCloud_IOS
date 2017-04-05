//
//  ACheckListRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ACheckListRequest_h
#define ACheckListRequest_h

#import "Request.h"

@interface ACheckListRequest : Request

@property (copy, nonatomic) NSString *hzsId;

@property (assign, nonatomic) NSInteger rows;

@property (assign, nonatomic) NSInteger page;

@end

#endif /* ACheckListRequest_h */
