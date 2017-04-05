//
//  SupDriverInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupDriverInfo_h
#define SupDriverInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface SupDriverInfo : Jastor<ListDialogDataDelegate>

@property (copy, nonatomic) NSString *driverId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *tel;

@end


#endif /* SupDriverInfo_h */
