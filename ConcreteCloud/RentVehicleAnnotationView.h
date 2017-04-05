//
//  RentVehicleAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef RentVehicleAnnotationView_h
#define RentVehicleAnnotationView_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RentVehicleInfo.h"
#import "GcInfoView.h"
#import "QCBInfoView.h"
#import "CZBInfoView.h"

@interface RentVehicleAnnotationView : BMKAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(UIImage *)image;

- (void)showInfoWindow;

- (void)hideInfoWindow;

- (void)setOnClickTelListener:(void(^)())onClickTel;


@property (strong, nonatomic) RentVehicleInfo *info;


@end


#endif /* RentVehicleAnnotationView_h */
