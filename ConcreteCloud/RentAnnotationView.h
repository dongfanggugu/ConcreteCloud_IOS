//
//  RentAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentAnnotationView_h
#define RentAnnotationView_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RentInfoView.h"
#import "RenterInfo.h"

@interface RentAnnotationView : BMKAnnotationView


- (void)showInfoWindow;

- (void)hideInfoWindow;

- (void)setRenterName;

@property (strong, nonatomic) RentInfoView *infoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) RenterInfo *info;


@end


#endif /* RentAnnotationView_h */
