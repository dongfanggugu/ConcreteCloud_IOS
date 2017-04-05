//
//  ProjectInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ProjectInfo_h
#define ProjectInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface ProjectInfo : Jastor <ListDialogDataDelegate>

@property (copy, nonatomic) NSString *address;

@property (copy, nonatomic) NSString *companyName;

@property (copy, nonatomic) NSString *contactsUser;

@property (copy, nonatomic) NSString *createTime;

@property (copy, nonatomic) NSString *projectId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *projectName;

@property (copy, nonatomic) NSString *tel;

@property (copy, nonatomic) NSString *authId;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@end

#endif /* ProjectInfo_h */
