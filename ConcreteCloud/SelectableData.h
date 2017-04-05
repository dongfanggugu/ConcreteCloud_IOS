//
//  SelectableData.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SelectableData_h
#define SelectableData_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface SelectableData : Jastor<ListDialogDataDelegate>

- (id)initWithKey:(NSString *)key content:(NSString *)content;

@end

#endif /* SelectableData_h */
