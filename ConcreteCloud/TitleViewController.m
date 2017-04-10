//
//  TitleViewController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleViewController.h"
#import "TitleView.h"
#import "TitleSegmentView.h"

@interface TitleViewController()<TitleSegmentViewDelegate>
{
    UIView *_mNavigationBar;
    
    TitleView *_titleView;
}


@end

@implementation TitleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNaviBar];
    [self setNaviIcon];
    [self setNavLabel:[[Config shareConfig] getBranchName]];
}

- (UIView *)getNavigationBar
{
    return _mNavigationBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(receivedMsg:) name:@"concrete_notify" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:@"concrete_notify" object:nil];
}

- (void)receivedMsg:(NSNotification *)notification
{
    NSString *alertMsg = [notification.userInfo[@"aps"] objectForKey:@"alert"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:alertMsg delegate:self
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)initNaviBar
{
    if (!self.navigationController)
    {
        return;
    }
    
    self.navigationController.navigationBar.hidden = YES;
    
    _mNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 94)];
    
    
    //设置logo和文字
    
    _titleView = [TitleView viewFromNib];
    
    _titleView.lableName.text = [[Config shareConfig] getBranchName];
    
    [_titleView loadLogo:[[Config shareConfig] getBranchLogo]];
    
    CGRect frame = _titleView.frame;
    frame.origin.x = 10;
    frame.origin.y = 20;
    
    _titleView.frame = frame;
    [_mNavigationBar addSubview:_titleView];
    
    
    [_mNavigationBar setBackgroundColor:[Utils getColorByRGB:TITLE_COLOR]];
    [self.view addSubview:_mNavigationBar];
    
    //设置状态栏颜色为白色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)setNavLabel:(NSString *)label
{
    _titleView.lableName.text = label;
}

/**
 设置标题
 **/
- (void)setNaviTitle:(NSString *)title
{
    CGRect frame = _mNavigationBar.frame;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [label setCenter:CGPointMake(frame.size.width / 2, frame.size.height - 44 / 2)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [_mNavigationBar addSubview:label];
}

/**
 设置segment标题
 **/
- (void)setSegmentTitleLeft:(NSString *)left right:(NSString *)right
{
    CGRect frame = _mNavigationBar.frame;
    
    TitleSegmentView *segment = [TitleSegmentView viewFromNib];
    [segment setTitleOfLeft:left right:right];
    
    segment.delegate = self;
    
    [segment setCenter:CGPointMake(frame.size.width / 2, frame.size.height - 44 / 2)];
    
    [_mNavigationBar addSubview:segment];
    
}


/**
 设置后退按钮
 **/
- (void)setNaviIcon
{
    if (!self.navigationController)
    {
        return;
    }
    
    NSArray *controllers = self.navigationController.viewControllers;
    
    
    if (self == controllers[0])
    {
        return;
    }
    
    CGRect frame = _mNavigationBar.frame;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [imageView setCenter:CGPointMake(25, frame.size.height - 44 / 2)];
    
    imageView.image = [UIImage imageNamed:@"icon_back"];
    
    [_mNavigationBar addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(popup)]];
    
}

/**
 使用图标初始化导航栏右侧按钮
 **/
- (void)initNavRightWithImage:(UIImage *)image
{
    if (!self.navigationController)
    {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:image forState:UIControlStateNormal];
    
    
    CGRect frame = _mNavigationBar.frame;
    
    [btnRight setCenter:CGPointMake(frame.size.width - 25, frame.size.height - 44 /2)];
    
    [_mNavigationBar addSubview:btnRight];
    [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
}

/**
 使用文字初始化导航栏右侧按钮
 **/
-  (void)initNavRightWithText:(NSString *)text
{
    if (!self.navigationController)
    {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [btnRight setTitle:text forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    
    CGRect frame = _mNavigationBar.frame;
    
    [btnRight setCenter:CGPointMake(frame.size.width - 40, frame.size.height - 44 /2)];
    
    [_mNavigationBar addSubview:btnRight];
    [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initNaviLeftWithText:(NSString *)text
{
    if (!self.navigationController)
    {
        return;
    }
    
    CGRect frame = _mNavigationBar.frame;
    
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    btn.center = CGPointMake(38, frame.size.height - 44 / 2);
    
    btn.layer.masksToBounds = YES;
    
    btn.layer.cornerRadius = 10;
    
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    
    
    if ([self respondsToSelector:@selector(onClickNaviLeft)])
    {
        [btn addTarget:self action:@selector(onClickNaviLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_mNavigationBar addSubview:btn];
}


- (void)onClickNaviLeft
{
    
}

- (void)onClickNavRight
{
}

- (void)popup
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickLeftSegment
{
    
}

- (void)onClickRightSegment
{
    
}



#pragma mark -- TitleSegmentDelegate
-(void)onClickLeft
{
    [self onClickLeftSegment];
}

- (void)onClickRight
{
    [self onClickRightSegment];
}

@end
