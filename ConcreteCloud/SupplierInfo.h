//
//  SupplierInfo.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/7.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SupplierInfo_h
#define SupplierInfo_h

#import <Jastor.h>
#import "ListDialogView.h"

@interface SupplierInfo : Jastor <ListDialogDataDelegate>

//供应商id
@property (strong, nonatomic) NSString *supplierId;

//供应商名称
@property (strong, nonatomic) NSString *name;

//供应商所属公司
@property (strong, nonatomic) NSString *companyName;

//供应商联系人
@property (strong, nonatomic) NSString *contactsUser;

//供应商联系电话
@property (strong, nonatomic) NSString *tel;

//供应商地址
@property (strong, nonatomic) NSString *address;

//供应商经度
@property CGFloat lng;

//供应商维度
@property CGFloat lat;

@end


#endif /* SupplierInfo_h */
