//
//  MsgItemView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/23.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef MsgItemView_h
#define MsgItemView_h

@interface MsgItemView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

+ (id)viewFromNib;

+ (NSString *)getIdentifier;

@end


#endif /* MsgItemView_h */
