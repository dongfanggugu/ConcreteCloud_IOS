//
//  TaluoduCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaluoduCell.h"
#import "TaluoduDivInfo.h"

@interface TaluoduCell()<ListDialogViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbLeftContent;

@property (weak, nonatomic) IBOutlet UILabel *lbRightContent;

@property (weak, nonatomic) IBOutlet UIImageView *ivFlagLeft;

@property (weak, nonatomic) IBOutlet UIImageView *ivFlagRight;

@property (strong, nonatomic) NSArray<id<ListDialogDataDelegate>> *arrayLeftData;

@property (strong, nonatomic) NSMutableArray<id<ListDialogDataDelegate>> *arrayRightData;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) NSString *leftContent;

@property (strong, nonatomic) NSString *rightContent;

@property (strong, nonatomic) void(^afterSelectedLeft)(NSString *key, NSString *content);

@property (strong, nonatomic) void(^afterSelectedRight)(NSString *key, NSString *content);

@end

@implementation TaluoduCell

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TaluoduCell" owner:nil options:nil];
    
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

+ (NSString *)identifier
{
    return @"taluodu_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _ivFlagLeft.image = [UIImage imageNamed:@"icon_down"];
    _ivFlagRight.image = [UIImage imageNamed:@"icon_down"];
    
    _lbLeftContent.userInteractionEnabled = YES;
    
    [_lbLeftContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftDialog)]];
    
    _lbRightContent.userInteractionEnabled = YES;
    
    [_lbRightContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRightDialog)]];

}

- (void)setView:(UIView *)view data:(NSArray<ListDialogDataDelegate> *)arrayData
{
    if (nil == view || nil == arrayData || 0 == arrayData.count)
    {
        return;
    }
    _view = view;
    _arrayLeftData = arrayData;
    
    id<ListDialogDataDelegate> info = arrayData[0];
    _leftContent = [info getShowContent];
    
    _lbLeftContent.text = _leftContent;
    
    //初始化塌落度偏移值
    _arrayRightData = [NSMutableArray array];
    
    TaluoduDivInfo *div1 = [[TaluoduDivInfo alloc] initWithKey:@"" content:@"10"];
    TaluoduDivInfo *div2 = [[TaluoduDivInfo alloc] initWithKey:@"" content:@"20"];
    TaluoduDivInfo *div3 = [[TaluoduDivInfo alloc] initWithKey:@"" content:@"30"];
    
    [_arrayRightData addObject: div1];
    [_arrayRightData addObject: div2];
    [_arrayRightData addObject: div3];
    
    _rightContent = [div1 getShowContent];
    _lbRightContent.text = _rightContent;
}

- (void)showLeftDialog
{
    _ivFlagLeft.image = [UIImage imageNamed:@"icon_up"];
    ListDialogView *dialog = [ListDialogView viewFromNib];
    [dialog setData:_arrayLeftData];
    dialog.delegate = self;
    
    dialog.tag = 1001;
    
    [_view addSubview:dialog];
}

- (void)showRightDialog
{
    _ivFlagLeft.image = [UIImage imageNamed:@"icon_up"];
    ListDialogView *dialog = [ListDialogView viewFromNib];
    [dialog setData:_arrayRightData];
    dialog.delegate = self;
    
    dialog.tag = 1002;
    
    [_view addSubview:dialog];
}

- (NSString *)getLeftContentValue
{
    if (0 == _leftContent.length)
    {
        return @"";
    }
    
    return _leftContent;
}

- (void)setLeftContentValue:(NSString *)content
{
    _leftContent = content;
    _lbLeftContent.text = _leftContent;
}

- (NSString *)getRightContentValue
{
    if (0 == _rightContent.length)
    {
        return @"";
    }
    
    return _rightContent;
}

- (void)setRightContentValue:(NSString *)content
{
    _rightContent = content;
    _lbRightContent.text = _rightContent;
}

- (void)setLeftAfterSelectedListener:(void (^)(NSString *, NSString *))selection
{
    _afterSelectedLeft = selection;
    
    if (nil == selection)
    {
        NSLog(@"block is nil");
    }
}

- (void)setRightAfterSelectedListener:(void (^)(NSString *, NSString *))selection
{
    _afterSelectedRight = selection;
    
    if (nil == selection)
    {
        NSLog(@"block is nil");
    }
}


#pragma mark -- ListDialogDelegate

- (void)onSelectDialogTag:(NSInteger)tag content:(NSString *)content
{
    if (1001 == tag)
    {
        _leftContent = content;
        _ivFlagLeft.image = [UIImage imageNamed:@"icon_down"];
        _lbLeftContent.text = content;
        
        if (_afterSelectedLeft)
        {
            _afterSelectedLeft(@"", content);
        }
    }
    else if (1002 == tag)
    {
        _rightContent = content;
        _ivFlagRight.image = [UIImage imageNamed:@"icon_down"];
        _lbRightContent.text = content;
        
        if (_afterSelectedRight)
        {
            _afterSelectedRight(@"", content);
        }
    }
}

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    
}

@end
