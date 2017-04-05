//
//  Obj2Dic.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Obj2Dic_h
#define Obj2Dic_h

@interface Obj2Dic : NSObject

/**
 转换对象为字典类型
 **/
+ (NSDictionary*)getObjectData:(id)obj;

/**
 打印转换结果
 **/
+ (void)print:(id)obj;

@end


#endif /* Obj2Dic_h */
