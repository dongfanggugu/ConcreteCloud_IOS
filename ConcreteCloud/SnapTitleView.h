//
//  SnapTitleView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef SnapTitleView_h
#define SnapTitleView_h

@interface SnapTitleView : UIView

+ (id)viewFromNib;

- (void)setOnClickMoreListener:(void(^)())onClickMore;

+ (CGFloat)getSnapHeight;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end


#endif /* SnapTitleView_h */
