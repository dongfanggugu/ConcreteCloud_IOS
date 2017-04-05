//
//  StaffListResponse.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef StaffListResponse_h
#define StaffListResponse_h

#import "ResponseArray.h"
#import "SiteStaffInfo.h"

@interface StaffListResponse : ResponseArray

- (NSArray<SiteStaffInfo *> *)getStaffList;

@end


#endif /* StaffListResponse_h */
