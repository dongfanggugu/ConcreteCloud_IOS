//
//  DialogEditView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DialogEditView_h
#define DialogEditView_h

@protocol DialogEditViewDelegate <NSObject>

- (void)onOKDismiss:(NSString *)content;

@end

@interface DialogEditView : UIView

+ (id)viewFromNib;

- (void)show;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UITextField *tfContent;

@property (weak, nonatomic) id<DialogEditViewDelegate> delegate;

@end


#endif /* DialogEditView_h */
