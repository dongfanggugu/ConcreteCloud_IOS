//
//  VehicleAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VehicleAnnotationView_h
#define VehicleAnnotationView_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CustomAnnotationView.h"
#import "VehicleInfoView.h"
#import "PTrackInfo.h"
#import "DTrackInfo.h"


@interface VehicleAnnotationView : CustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(UIImage *)image;

//带有标签的地图标记
- (id)initWithAnnotationAndTag:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(UIImage *)image;


@property (strong, nonatomic) VehicleInfoView *infoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) PTrackInfo *info;

@property (strong, nonatomic) DTrackInfo *dInfo;

@property (strong, nonatomic) UIColor *color;

//1:B单 2:A单
@property (assign, nonatomic) Order_Type type;

//控制弹出框是否有操作按钮
@property (assign, nonatomic) BOOL hideOperation;


@end


#endif /* VehicleAnnotationView_h */
