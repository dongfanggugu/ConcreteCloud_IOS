//
//  TitleView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef TitleView_h
#define TitleView_h

@interface TitleView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;

@property (weak, nonatomic) IBOutlet UILabel *lableName;

- (void)loadLogo:(NSString *)url;

@end


#endif /* TitleView_h */
