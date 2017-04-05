//
//  SOrderAddController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOrderAddController.h"
#import "SelectableCell.h"
#import "DicRequest.h"
#import "DicResponse.h"
#import "DicInfo.h"
#import "TaluoduCell.h"
#import "TaluoduDivInfo.h"
#import "KeyValueCell.h"
#import "KeyEditCell.h"
#import "DatePickerDialog.h"
#import "KeyMultiEditCell.h"
#import "DOrderInfo.h"
#import "HzsInfo.h"
#import "SOrderAddConfirmController.h"

@interface SOrderAddController()<UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate>
{
    //商品类型
    NSMutableArray<id<ListDialogDataDelegate>> *_arrayGoods;
    
    NSString *_goodsName;
    
    //强度等级
    NSMutableArray<DicInfo *> *_arrayLevel;
    
    NSString *_level;
    
    //抗渗等级
    NSMutableArray<DicInfo *> *_arrayKsdj;
    
    NSString *_ksdj;
    
    //塌落度
    NSMutableArray<DicInfo *> *_arraySlump;
    
    NSString *_slump;
    
    NSString *_slumpDiv;
    
    //静态行的起始序号
    NSInteger _dyIndex;
    
    //订货量
    UITextField *_tfAmount;
    
    //浇筑时间
    UILabel *_lbArriveDate;
    
    //浇筑部位
    UITextField *_tfCastPart;
    
    //技术要求
    UITextView *_tvTechReq;
    
    //泵送要求
    UITextView *_tvPumpReq;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation SOrderAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"添加订单"];
    [self initNavRightWithText:@"确定"];
    [self initData];
    [self initView];
}

- (void)onClickNavRight
{
    if (0 == _tfAmount.text.length || 0 == [_tfAmount.text floatValue])
    {
        [HUDClass showHUDWithLabel:@"请填写正确的订货量" view:self.view];
        return;
    }
    
    if ([_lbArriveDate.text isEqualToString:@"点击选择浇筑时间"])
    {
        [HUDClass showHUDWithLabel:@"请选择浇筑时间" view:self.view];
        return;
    }
    
    if (0 == _tfCastPart.text.length)
    {
        [HUDClass showHUDWithLabel:@"请填写浇筑部位" view:self.view];
        return;
    }
    
    DOrderInfo *orderInfo = [[DOrderInfo alloc] init];
    orderInfo.hzsName = _hzsInfo.name;
    orderInfo.hzsAddrress = _hzsInfo.address;
    orderInfo.goodsName = _goodsName;
    orderInfo.intensityLevel = _level;
    orderInfo.ksdj = _ksdj;
    orderInfo.slump = _slump;
    orderInfo.dev = _slumpDiv;
    orderInfo.number = [_tfAmount.text floatValue];
    orderInfo.useTime = _lbArriveDate.text;
    orderInfo.castingPart = _tfCastPart.text;
    
    orderInfo.hzsId = _hzsInfo.hzsId;
    orderInfo.siteId = [[Config shareConfig] getBranchId];
    orderInfo.siteAddress = [[Config shareConfig] getBranchAddress];
    
    if (0 == _tvTechReq.text.length)
    {
        orderInfo.techReq = @"无";
    }
    else
    {
        orderInfo.techReq = _tvTechReq.text;
    }
    
    if (0 == _tvPumpReq.text.length)
    {
        orderInfo.pumpUpReq = @"无";
    }
    else
    {
        orderInfo.pumpUpReq = _tvPumpReq.text;
    }
    orderInfo.orderUserName = [[Config shareConfig] getName];
    orderInfo.orderUserTel = [[Config shareConfig] getUserName];
    
    SOrderAddConfirmController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"s_order_add_confirm_controller"];
    controller.orderInfo = orderInfo;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData
{
    _arrayGoods = [NSMutableArray array];
    
    TaluoduDivInfo *info1 = [[TaluoduDivInfo alloc] initWithKey:@"" content:HNT];
    TaluoduDivInfo *info2 = [[TaluoduDivInfo alloc] initWithKey:@"" content:SHAJIANG];

    [_arrayGoods addObject:info1];
    [_arrayGoods addObject:info2];
    
    _goodsName = [_arrayGoods[0] getShowContent];
    
    _arrayLevel = [NSMutableArray array];
    
    _arrayKsdj = [NSMutableArray array];
    
    _arraySlump = [NSMutableArray array];
    
    _dyIndex = 0;
}

- (void)initView
{
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_goodsName isEqualToString:HNT])
    {
        _dyIndex = 4;
    }
    else
    {
        _dyIndex = 2;
    }
    
    return _dyIndex + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setView:self.view data:[_arrayGoods copy]];
        cell.lbKey.text = @"商品名称";
        
        [cell setContentValue:_goodsName];
        
        __weak typeof(self) weakSelf = self;
        
        void (^block)(NSString *key, NSString *content) = ^(NSString *key, NSString *content) {
            
            _goodsName = content;
            [weakSelf.tableView reloadData];
            
        };
        
        [cell setAfterSelectedListener:block];
        

        return cell;

    }
    else if (1 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([_goodsName isEqualToString:HNT])
        {
            cell.lbKey.text = @"强度等级";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = LEVEL;
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arrayLevel removeAllObjects];
                                       [_arrayLevel addObjectsFromArray:response.body];
                                       
                                       _level = _arrayLevel[0].value;
                                       
                                       [cell setView:weakSelf.view data:[_arrayLevel copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           _level = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
        }
        else
        {
            cell.lbKey.text = @"强度等级";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SJQDDJ;
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arrayLevel removeAllObjects];
                                       [_arrayLevel addObjectsFromArray:response.body];
                                       
                                       _level = _arrayLevel[0].value;
                                       
                                       [cell setView:weakSelf.view data:[_arrayLevel copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           _level = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];

        }
        return cell;
    }
    else if (2 == indexPath.row)
    {
        if ([_goodsName isEqualToString:HNT])
        {
            SelectableCell *cell = [SelectableCell viewFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"抗渗等级";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = KSDJ;
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arrayKsdj removeAllObjects];
                                       [_arrayKsdj addObjectsFromArray:response.body];
                                       
                                       _ksdj = _arrayKsdj[0].value;
                                       
                                       [cell setView:weakSelf.view data:[_arrayKsdj copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           _ksdj = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            
            return cell;
        }
    }
    else if (3 == indexPath.row)
    {
        
         if ([_goodsName isEqualToString:HNT])
         {
             TaluoduCell *cell = [TaluoduCell viewFromNib];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
             
             if ([_goodsName isEqualToString:HNT])
             {
                 
                 DicRequest *request = [[DicRequest alloc] init];
                 request.type = SLUMP;
                 
                 __weak typeof(self) weakSelf = self;
                 
                 [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                            [_arraySlump removeAllObjects];
                                            [_arraySlump addObjectsFromArray:response.body];
                                            
                                            _slump = _arraySlump[0].value;
                                            _slumpDiv = @"10";
                                            
                                            [cell setView:weakSelf.view data:[_arraySlump copy]];
                                            
                                            [cell setLeftAfterSelectedListener:^(NSString *key, NSString *content) {
                                                
                                                _slump = content;
                                            }];
                                            
                                            [cell setRightAfterSelectedListener:^(NSString *key, NSString *content) {
                                                
                                                _slumpDiv = content;
                                            }];
                                            
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                            
                                        }];
             }
             
             return cell;
         }
    }
    
    if (_dyIndex == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbKey.text = @"订货量";
        
        cell.tfValue.placeholder = @"订货量";
        cell.tfValue.keyboardType = UIKeyboardTypeDecimalPad;
        
        cell.lbUnit.hidden = NO;
        cell.lbUnit.text = @"m³";
        
        _tfAmount = cell.tfValue;
        
        return cell;
    }
    else if (_dyIndex + 1 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        
        CGFloat width = self.view.frame.size.width;
        cell.valueWidth.constant = width - 150 - 8 - 8 - 8;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbValue.textAlignment = NSTextAlignmentLeft;
        cell.lbKey.text = @"浇筑时间";
        cell.lbValue.text = @"点击选择浇筑时间";
        
        
        cell.lbValue.userInteractionEnabled = YES;
        
        _lbArriveDate = cell.lbValue;
        
        [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)]];
        
        return cell;
    }
    else if (_dyIndex + 2 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbKey.text = @"浇筑部位";
        
        cell.tfValue.placeholder = @"浇筑部位";
        
        cell.lbUnit.hidden = YES;
        
        _tfCastPart = cell.tfValue;
        
        return cell;
    }
    else if (_dyIndex + 3 == indexPath.row)
    {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"技术要求";
        cell.lbPlaceHolder.text = @"技术要求……";
        
        _tvTechReq = cell.tvContent;
        
        return cell;
    }
    else if (_dyIndex + 4 == indexPath.row)
    {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"泵送要求";
        cell.lbPlaceHolder.text = @"泵送要求……";
        
        _tvPumpReq = cell.tvContent;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dyIndex + 3 ==  indexPath.row || _dyIndex + 4 == indexPath.row)
    {
        return [KeyMultiEditCell cellHeight];
    }
    
    return 44;
}


- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;
    
    [self.view addSubview:dialog];
}

#pragma mark - DatePickerDelegate

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [format stringFromDate:date];
    _lbArriveDate.text = dateStr;
}

@end
