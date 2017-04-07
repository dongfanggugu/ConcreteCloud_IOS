//
//  SelectableCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/9.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectableCell.h"

@interface SelectableCell()<ListDialogViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *ivFlag;

@property (strong, nonatomic) NSArray<ListDialogDataDelegate> *arrayData;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) void(^afterSelected)(NSString *key, NSString *content);

@end

@implementation SelectableCell

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SelectableCell" owner:nil options:nil];
    
    if ( 0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 50;
}

+ (NSString *)getIdentifier
{
    return @"selectable_cell";
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _ivFlag.image = [UIImage imageNamed:@"icon_down"];
    
    _lbContent.userInteractionEnabled = YES;
    
    [_lbContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDialog)]];
}

- (void)setView:(UIView *)view data:(NSArray<id<ListDialogDataDelegate>> *)arrayData
{
    if (nil == view || nil == arrayData || 0 == arrayData.count)
    {
        return;
    }
    _arrayData = arrayData;
    
    id<ListDialogDataDelegate> info = arrayData[0];
    _key = [info getKey];
    _content = [info getShowContent];
    
    _lbContent.text = _content;
}

- (void)showDialog
{
    _ivFlag.image = [UIImage imageNamed:@"icon_up"];
    ListDialogView *dialog = [ListDialogView viewFromNib];
    [dialog setData:_arrayData];
    dialog.delegate = self;
    [dialog show];
}

- (NSString *)getKeyValue
{
    if (0 == _key.length)
    {
        return  @"";
    }
    
    return _key;
}

- (void)setKeyValue:(NSString *)key
{
    _key = key;
}

- (NSString *)getContentValue
{
    if (0 == _content.length)
    {
        return @"";
    }
    
    return _content;
}

- (void)setContentValue:(NSString *)content
{
    _content = content;
    _lbContent.text = _content;
}

- (void)setAfterSelectedListener:(void (^)(NSString *, NSString *))selection
{
    _afterSelected = selection;
    
    if (nil == selection)
    {
        NSLog(@"block is nil");
    }
}


#pragma mark -- ListDialogDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    _key = key;
    _content = content;
    _ivFlag.image = [UIImage imageNamed:@"icon_down"];
    _lbContent.text = _content;
    
    if (_afterSelected != nil) {
        _afterSelected(key, content);
    }
}

- (void)onSelectDialogTag:(NSInteger)tag content:(NSString *)content
{
    
}

- (void)onDismiss
{
    _ivFlag.image = [UIImage imageNamed:@"icon_down"];
}

@end
