//
//  HzsInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HzsInfo_h
#define HzsInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface HzsInfo : Jastor<ListDialogDataDelegate>

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *contactsUser;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@property (copy, nonatomic) NSString *hzsId;

@property (assign, nonatomic) BOOL authorization;

@property (copy, nonatomic) NSString *productionUrl;

@end


#endif /* HzsInfo_h */
