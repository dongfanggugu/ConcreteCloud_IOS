//
//  PwdModifyRequest.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PwdModifyRequest.h"

@implementation PwdModifyRequest

- (NSDictionary *)parsToDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"oldPwd"] = _passedPwd;
    dic[@"newPwd"] = _curPwd;
    
    return [dic copy];
}

@end
