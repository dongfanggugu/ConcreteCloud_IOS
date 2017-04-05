//
//  ACheckVideoRequest.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ACheckVideoRequest_h
#define ACheckVideoRequest_h

#import "Request.h"

@interface ACheckVideoRequest : Request

@property (copy, nonatomic) NSString *hzsId;


//hzs A单检验视频  supplier B单检验视频
@property (copy, nonatomic) NSString *type;

@end


#endif /* ACheckVideoRequest_h */
