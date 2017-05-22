//
//  DicInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/13.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DicInfo_h
#define DicInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface DicInfo : Jastor <ListDialogDataDelegate>

@property (copy, nonatomic) NSString *dicId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *value;

@end


#endif /* DicInfo_h */
