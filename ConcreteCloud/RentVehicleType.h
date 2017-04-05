//
//  RentVehicleType.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleType_h
#define RentVehicleType_h

#import "ListDialogView.h"

@interface RentVehicleType: NSObject<ListDialogDataDelegate>

- (id)initWithKey:(NSString *)key content:(NSString *)content;

@property (copy, nonatomic) NSString *showContent;

@property (copy, nonatomic) NSString *key;

@end


#endif /* RentVehicleType_h */
