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

@property (strong, nonatomic) NSString *dicId;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *value;

@end


#endif /* DicInfo_h */
