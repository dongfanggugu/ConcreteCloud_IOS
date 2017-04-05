//
//  TaluoduDivInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TaluoduDivInfo_h
#define TaluoduDivInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface TaluoduDivInfo : Jastor<ListDialogDataDelegate>

- (id)initWithKey:(NSString *)key content:(NSString *)content;

@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *key;

@end

#endif /* TaluoduDivInfo_h */
