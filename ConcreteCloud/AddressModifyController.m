//
//  AddressModifyController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/12.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AddressModifyController.h"
#import "AddressLocationController.h"

@interface AddressModifyController () <LocationControllerDelegate>

@property (strong, nonatomic) UITextView *textView;

@property (assign, nonatomic) CGFloat lat;

@property (assign, nonatomic) CGFloat lng;

@end

@implementation AddressModifyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"地址修改"];
    [self initNavRightWithText:@"提交"];
    [self initView];
}


- (void)onClickNavRight
{
    if (0 == _textView.text.length) {
        [HUDClass showHUDWithText:@"请先填写你的地址并在地图中标记"];
        return;
    }
    
    if (_lat <= 0 || _lng <= 0) {
        [HUDClass showHUDWithText:@"请先点击定位图标在地图中标记您的地址"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    G_Agent_Type agent = [[[Config shareConfig] getType] integerValue];
    
    if (Agent_Supplier == agent) {
    
        param[@"supplierId"] = [[Config shareConfig] getBranchId];
        param[@"address"] = _textView.text;
        param[@"lat"] = [NSNumber numberWithFloat:_lat];
        param[@"lng"] = [NSNumber numberWithFloat:_lng];
        
        [[HttpClient shareClient] view:self.view post:URL_SUP_ADDRESS_MODIFY parameters:param
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   [HUDClass showHUDWithText:@"地址修改成功"];
                                   [self updateAddress];
        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
            
        }];
    }
}

- (void)updateAddress
{
    [[Config shareConfig] setBranchAddress:_textView.text];
    [[Config shareConfig] setLat:_lat];
    [[Config shareConfig] setLng:_lng];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 94 + 8, self.screenWidth - 80, 80)];
    _textView.text = [[Config shareConfig] getBranchAddress];
    
    _textView.layer.borderWidth = 1;
    
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    
    _textView.font = [UIFont systemFontOfSize:14];
    
    _textView.layer.masksToBounds = YES;
    
    _textView.layer.cornerRadius = 5;
    
    [self.view addSubview:_textView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 80 + 20, 94 + 20, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"location_point"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}


- (void)location
{
    if (0 == _textView.text.length) {
        [HUDClass showHUDWithText:@"请先填写大概地址"];
        return;
    }
    AddressLocationController *controller = [[AddressLocationController alloc] init];
    
    controller.delegate = self;
    controller.address = _textView.text;
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - LocationViewControllerDelegate

- (void)onChooseAddressLat:(CGFloat)lat lng:(CGFloat)lng
{
    _lat = lat;
    _lng = lng;
    
    [HUDClass showHUDWithText:@"请继续完善您的具体地址"];
}

@end
