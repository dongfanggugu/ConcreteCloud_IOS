//
//  RentVehicleAddController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleAddController.h"
#import "KeyEditCell.h"
#import "SelectableCell.h"
#import "SelectableData.h"
#import "KeyValueCell.h"
#import "DatePickerDialog.h"
#import "RentVehicleAddRequest.h"


#define DATE_INIT @"点击选择日期"

typedef NS_ENUM(NSInteger, Vehicle)
{
    V_TANKER,
    V_PUMP_1,
    V_PUMP_2,
    V_PUMP_3
};

@interface RentVehicleAddController()<UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *plate;

@property (weak, nonatomic) UITextField *tfPlate;

@property (weak, nonatomic) UITextField *tfLoad;

@property (weak, nonatomic) UITextField *tfWeight;

@property (copy, nonatomic) NSString *category;

@property (copy, nonatomic) NSString *type;

@property (weak, nonatomic) UITextField *tfBrand;

@property (weak, nonatomic) UILabel *lbDate;

@property (weak, nonatomic) UITextField *tfArm;

@property (weak, nonatomic) UITextField *tfFlow;

@property (assign, nonatomic) Vehicle vehicle;

@end

@implementation RentVehicleAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"车辆添加"];
    [self initNavRightWithText:@"确定"];
    [self initData];
    [self initView];
}

- (void)initData
{
    _vehicle = V_TANKER;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 50)];
    
    _tableView.bounces = NO;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (void)onClickNavRight
{
    NSString *plate = _tfPlate.text;
    if (0 == plate.length)
    {
        [HUDClass showHUDWithLabel:@"请填写车牌号" view:self.view];
        return;
    }
    
    if (V_TANKER == _vehicle)
    {
        NSString *selfNet = _tfWeight.text;
        
        if (0 == selfNet.length)
        {
            [HUDClass showHUDWithLabel:@"请填写车辆净重" view:self.view];
            return;
        }
        
        NSString *weight = _tfLoad.text;
        
        if (0 == weight.length)
        {
            [HUDClass showHUDWithLabel:@"请填写车辆载重量" view:self.view];
            return;
        }
        
        RentVehicleAddRequest *request = [[RentVehicleAddRequest alloc] init];
        
        request.type = [[Config shareConfig] getType];
        request.leaseId = [[Config shareConfig] getBranchId];
        request.plateNum = plate;
        request.cls = @"1";
        request.selfNet = selfNet.floatValue;
        request.weight = weight.floatValue;
        
        [self vehicleAdd:request];
    }
    else if (V_PUMP_1 == _vehicle)
    {
        
        NSString *brand = _tfBrand.text;
        
        if (0 == brand.length)
        {
            [HUDClass showHUDWithLabel:@"请填写品牌" view:self.view];
            return;
        }
        
        NSString *productionTime = _lbDate.text;
        
        if ([productionTime isEqualToString:DATE_INIT])
        {
            [HUDClass showHUDWithLabel:@"请选择出厂日期" view:self.view];
            return;
        }
        
        NSString *arm = _tfArm.text;
        
        if (0 == arm.length)
        {
            [HUDClass showHUDWithLabel:@"请填写臂长" view:self.view];
            return;
        }
        
        NSString *flow = _tfFlow.text;
        
        if (0 == flow.length)
        {
            [HUDClass showHUDWithLabel:@"请填写理论输送方量" view:self.view];
            return;
        }
        
        RentVehicleAddRequest *request = [[RentVehicleAddRequest alloc] init];
        
        request.type = [[Config shareConfig] getType];
        request.leaseId = [[Config shareConfig] getBranchId];
        request.plateNum = plate;
        request.cls = @"3";
        request.mold = @"1";
        request.brand = brand;
        request.productionTime = productionTime;
        request.armLength = arm.floatValue;
        request.flow = flow.floatValue;
        
        [self vehicleAdd:request];
    }
    else if (V_PUMP_2 == _vehicle || V_PUMP_3 == _vehicle)
    {
        NSString *brand = _tfBrand.text;
        
        if (0 == brand.length)
        {
            [HUDClass showHUDWithLabel:@"请填写品牌" view:self.view];
            return;
        }
        
        NSString *productionTime = _lbDate.text;
        
        if ([productionTime isEqualToString:DATE_INIT])
        {
            [HUDClass showHUDWithLabel:@"请选择出厂日期" view:self.view];
            return;
        }

        
        NSString *flow = _tfFlow.text;
        
        if (0 == flow.length)
        {
            [HUDClass showHUDWithLabel:@"请填写理论输送方量" view:self.view];
            return;
        }
        
        RentVehicleAddRequest *request = [[RentVehicleAddRequest alloc] init];
        
        request.type = [[Config shareConfig] getType];
        request.leaseId = [[Config shareConfig] getBranchId];
        request.plateNum = plate;
        request.cls = @"3";
        request.mold = [NSString stringWithFormat:@"%ld", _vehicle];
        request.brand = brand;
        request.productionTime = productionTime;
        request.flow = flow.floatValue;
        [self vehicleAdd:request];
    }
    
}

- (void)showDateDialog
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    [dialog setDateMode];
    dialog.delegate = self;
    [self.view addSubview:dialog];
}

#pragma mark - Network Request

- (void)vehicleAdd:(RentVehicleAddRequest *)request
{
    [[HttpClient shareClient] view:self.view post:URL_RENT_ADD parameters:[request parsToDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithLabel:@"车辆添加成功" view:self.view];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DatePickerDelegate

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [format stringFromDate:date];
    _lbDate.text = dateStr;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_vehicle == V_TANKER)
    {
        return 4;
    }
    else if (_vehicle == V_PUMP_1)
    {
        return 7;
    }
    else if (_vehicle == V_PUMP_2)
    {
        return 6;
    }
    else if (_vehicle == V_PUMP_3)
    {
        return 6;
    }
    
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        
        cell.lbKey.text = @"车牌号";
        
        cell.tfValue.placeholder = @"车牌号";
        
        if (_plate)
        {
            cell.tfValue.text = _plate;
        }
        
        _tfPlate = cell.tfValue;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (1 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        
        SelectableData *data1 = [[SelectableData alloc] initWithKey:@"0" content:@"混凝土罐车"];
        
        SelectableData *data2 = [[SelectableData alloc] initWithKey:@"1" content:@"泵车"];
        
        [cell setView:self.view data:[NSArray arrayWithObjects:data1, data2, nil]];
        
        cell.lbKey.text = @"车辆种类";
        
        if (_category)
        {
            cell.lbContent.text = _category;
        }
        else
        {
            _category = @"混凝土罐车";
        }
        
        
        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            
            _plate = _tfPlate.text;
            
            _category = content;
            
            NSInteger type = key.integerValue;
            
            if (0 == type)
            {
                _vehicle = V_TANKER;
            }
            else if (1 == type)
            {
                _vehicle = V_PUMP_1;
            }
            [_tableView reloadData];
        }];
        
        return cell;
    }
    else if (2 == indexPath.row)
    {
        if (V_TANKER == _vehicle)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            
            cell.lbKey.text = @"运载量";
            
            cell.tfValue.placeholder = @"运载量";
            
            _tfLoad = cell.tfValue;
            
            cell.lbUnit.hidden = NO;
            
            cell.lbUnit.text = @"m³";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else
        {
            SelectableCell *cell = [SelectableCell viewFromNib];
            
            SelectableData *data1 = [[SelectableData alloc] initWithKey:@"1" content:@"汽车泵"];
            
            SelectableData *data2 = [[SelectableData alloc] initWithKey:@"2" content:@"车载泵"];
            
            SelectableData *data3 = [[SelectableData alloc] initWithKey:@"3" content:@"拖式泵"];
            
            cell.lbKey.text = @"车辆类型";
            
            _type = @"汽车泵";
            
            [cell setView:self.view data:[NSArray arrayWithObjects:data1, data2, data3, nil]];
            
            [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                
                _type = content;
                
                NSInteger type = key.integerValue;
                
                _vehicle = type;
                
                [_tableView reloadData];
                
            }];
            
            return cell;
        }
    }
    else if (3 == indexPath.row)
    {
        if (V_TANKER == _vehicle)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            
            cell.lbKey.text = @"车辆净重";
            
            cell.tfValue.placeholder = @"车辆净重";
            
            _tfWeight = cell.tfValue;
            
            cell.lbUnit.hidden = NO;
            
            cell.lbUnit.text = @"吨";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            
            cell.lbKey.text = @"品牌";
            
            cell.tfValue.placeholder = @"品牌";
            
            _tfBrand = cell.tfValue;
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else if (4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        
        cell.lbKey.text = @"出厂时间";
        
        cell.lbValue.text = DATE_INIT;
        
        _lbDate = cell.lbValue;
        
        cell.valueWidth.constant = self.screenWidth - 8 - 150 - 8 - 8;
        
        
        cell.lbValue.userInteractionEnabled = YES;
        
        [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDateDialog)]];
    
        return cell;
    }
    else if (5 == indexPath.row)
    {
        if (_vehicle == V_PUMP_1)
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            
            cell.lbKey.text = @"臂长";
            
            cell.tfValue.placeholder = @"臂长";
            
            _tfArm = cell.tfValue;
            
            cell.lbUnit.hidden = NO;
            cell.lbUnit.text = @"米";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else
        {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            
            cell.lbKey.text = @"理论输送方量";
            
            cell.tfValue.placeholder = @"理论输送方量";
            
            _tfFlow = cell.tfValue;
            
            cell.lbUnit.hidden = NO;
            cell.lbUnit.text = @"方/小时";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else if (6 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        
        cell.lbKey.text = @"理论输送方量";
        
        cell.tfValue.placeholder = @"理论输送方量";
        
        _tfFlow = cell.tfValue;
        
        cell.lbUnit.hidden = NO;
        cell.lbUnit.text = @"方/小时";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return [KeyValueCell viewFromNib];
}

@end
