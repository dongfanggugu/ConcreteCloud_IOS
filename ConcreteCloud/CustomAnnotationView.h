//
//  CustomAnnotationView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef CustomAnnotationView_h
#define CustomAnnotationView_h

#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface CustomAnnotationView : BMKAnnotationView

- (void)showInfoWindow;

- (void)hideInfoWindow;

@end


#endif /* CustomAnnotationView_h */
