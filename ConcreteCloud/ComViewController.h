//
//  ComViewController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/21.
// 系统默认导航栏
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ComViewController_h
#define ComViewController_h

#import "BaseViewController.h"

@interface ComViewController : BaseViewController

- (void)setNavTitle:(NSString *)title;

-  (void)initNavRightWithText:(NSString *)text;

@end

#endif /* ComViewController_h */
