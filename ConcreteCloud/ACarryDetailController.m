//
//  ACarryDetailController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/30.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ACarryDetailController.h"
#import "ACarryDetailController.h"
#import "DTrackInfo.h"
#import "ACheckListResponse.h"
#import "ACarryCell.h"
#import "VideoPlayerController.h"

@interface ACarryDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayCarry;

@end

@implementation ACarryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle:@"运送详情"];
    
    [self initData];
    
    [self getCarry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    _arrayCarry = [NSMutableArray array];
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.bounces = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


/**
 获取车的类型
 */
- (NSString *)getVehicleName:(DTrackInfo *)info
{
    NSInteger type = [info.cls integerValue];
    
    if (1 == type || 2 == type)
    {
        return @"混凝土运输车";
    }
    else if (3 == type)
    {
        NSInteger gcType = [info.vehicleType integerValue];
        
        if (1 == gcType)
        {
            return @"汽车泵";
        }
        else if (2 == gcType)
        {
            return @"车载泵";
        }
        else if (3 == gcType)
        {
            return @"拖式泵";
        }
        else
        {
            return @"泵车";
        }
    }
    else
    {
        return @"混凝土运输车";
    }
}

#pragma mark - 网络请求

- (void)getCarry
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"hzsOrderId"] = _orderId;
    
    [[HttpClient shareClient] view:self.view post:URL_A_CARRY_DETAIL parameters:param
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        
                               ACheckListResponse *response = [[ACheckListResponse alloc] initWithDictionary:responseObject];
                               
                               [_arrayCarry removeAllObjects];
                               [_arrayCarry addObjectsFromArray:[response getCheckList]];
                               [self initTableView];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayCarry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACarryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ACarryCell identifier]];
    
    if (!cell)
    {
        cell = [ACarryCell cellFromNib];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DTrackInfo *info = _arrayCarry[indexPath.row];
    
    cell.lbCode.text = info.taskCode;
    
    cell.lbDate.text = info.startTime;
    
    cell.lbPlate.text = [NSString stringWithFormat:@"%@ %@ %@", info.plateNum, info.driverName, info.driverTel];
    
    
    NSInteger vehicleType = info.cls.integerValue;
    
    if (3 == vehicleType)
    {
        cell.lbCurNum.text = [NSString stringWithFormat:@"车次:%@ %@", info.currentNum, [self getVehicleName:info]];
    
    }
    else
    {
        cell.lbCurNum.text = [NSString stringWithFormat:@"车次:%@ 运送量:%ld %@",
                              info.currentNum, info.number, [self getVehicleName:info]];

        [cell setOnClickExamVideoListener:^{
            NSString *exam = info.examVideo;
            
            if (0 == exam.length)
            {
                [HUDClass showHUDWithLabel:@"暂无出站检验视频" view:nil];
                return;
            }
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
            
            VideoPlayerController *controller = [board instantiateViewControllerWithIdentifier:@"video_player_controller"];
            
            controller.urlStr = exam;
            
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
        [cell setOnClickSpotVideoListener:^{
            NSString *spot = info.spotVideo;
            
            if (0 == spot.length)
            {
                [HUDClass showHUDWithLabel:@"暂无现场检验视频" view:nil];
                return;
            }
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Purchaser" bundle:nil];
            
            VideoPlayerController *controller = [board instantiateViewControllerWithIdentifier:@"video_player_controller"];
            
            controller.urlStr = spot;
            
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ACarryCell cellHeight];
}


@end
