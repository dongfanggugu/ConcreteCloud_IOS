//
//  SiteAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SiteAnnotationView_h
#define SiteAnnotationView_h


#import "CustomAnnotationView.h"
#import "SiteInfoView.h"
#import "ProjectInfo.h"

@interface SiteAnnotationView : CustomAnnotationView

@property (strong, nonatomic) SiteInfoView *infoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) ProjectInfo *info;

@property (assign, nonatomic) UIColor *color;

@end



#endif /* SiteAnnotationView_h */
