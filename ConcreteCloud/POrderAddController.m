//
//  POrderAddController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POrderAddController.h"
#import "SelectableCell.h"
#import "SupplierInfo.h"
#import "DicRequest.h"
#import "DicResponse.h"
#import "DicInfo.h"
#import "KeyValueCell.h"
#import "DatePickerDialog.h"
#import "KeyEditCell.h"
#import "SupplierListResponse.h"
#import "KeyMultiEditCell.h"
#import "POrderAddRequest.h"


#pragma mark - POrderAddController

@interface POrderAddController()<UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


//商品种类
@property (strong, nonatomic) NSMutableArray<DicInfo *> *arrayGoods;

//等级标准
@property (strong, nonatomic) NSMutableArray<DicInfo *> *arrayStandard;

//品种
@property (strong, nonatomic) NSMutableArray<DicInfo *> *arrayVariety;

//强度等级
@property (strong, nonatomic) NSMutableArray<DicInfo *> *arrayIntensityLevel;

//细度模数/径粒规格
@property (strong, nonatomic) NSMutableArray<DicInfo *> *arrayKld;

//含量
@property (strong, nonatomic) NSMutableArray<DicInfo *> *arrayContents;

//供应商列表
@property (strong, nonatomic) NSMutableArray<SupplierInfo *> *arraySupplier;

//商品
@property (strong, nonatomic) NSString *goodsName;

//等级标准
@property (strong, nonatomic) NSString *standard;

//品种
@property (strong, nonatomic) NSString *variety;

//强度等级
@property (strong, nonatomic) NSString *intensityLevel;

//细度模数/径粒规格 mm
@property (strong, nonatomic) NSString *kld;

//含量
@property (strong, nonatomic) NSString *contents;

//供应商
@property (strong, nonatomic) NSString *supplier;

//运达时间
@property (weak, nonatomic) UILabel *lbArriveDate;

//特殊要求
@property (weak, nonatomic) UITextView *tvTechReq;

//供应商负责人
@property (weak, nonatomic) UILabel *lbSupplierAdmin;

//联系电话
@property (weak, nonatomic) UILabel *lbSupplierTel;

//订货量
@property (weak, nonatomic) UITextField *tfAmount;

//静态行的起始序号
@property NSInteger dyIndex;

@end

@implementation POrderAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"订单添加"];
    [self initNavRightWithText:@"确定"];
    
    [self initView];
    [self initData];
}

- (void)initData
{
    _arrayGoods = [[NSMutableArray alloc] init];
    _arrayVariety = [[NSMutableArray alloc] init];
    _arrayStandard = [[NSMutableArray alloc] init];
    _arrayIntensityLevel = [[NSMutableArray alloc] init];
    _arrayKld = [[NSMutableArray alloc] init];
    _arrayContents = [[NSMutableArray alloc] init];
    _arraySupplier = [[NSMutableArray alloc] init];
    
    _dyIndex = 0;
    
    [self getGoods];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.bounces =NO;
}

- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;
    
    [dialog show];
}

- (void)onClickNavRight
{
    [self orderAdd];
}

#pragma mark - Network Request

- (void)getGoods
{
    DicRequest *request = [[DicRequest alloc] init];
    request.type = GOODS;
    
    __weak POrderAddController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arrayGoods removeAllObjects];
                               [weakSelf.arrayGoods addObjectsFromArray:response.body];
                               
                               weakSelf.goodsName = weakSelf.arrayGoods[0].value;
                               
                               [self getSuppliers];
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                            
                           }];

}

- (void)getSuppliers
{
    __weak POrderAddController *weakSelf = self;
    
    [[HttpClient shareClient] view:self.view post:URL_GET_SUPPLIER2 parameters:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               SupplierListResponse *response = [[SupplierListResponse alloc] initWithDictionary:responseObject];
                               [weakSelf.arraySupplier removeAllObjects];
                               [weakSelf.arraySupplier addObjectsFromArray:response.body];
                               
                               weakSelf.supplier = weakSelf.arraySupplier[0].name;
                               
                               [weakSelf.tableView reloadData];
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                               
                           }];

}

- (void)orderAdd
{
    POrderAddRequest *request = [[POrderAddRequest alloc] init];
    request.goodsName = _goodsName;
    request.hzsId = [[Config shareConfig] getBranchId];
    request.number = [_tfAmount.text floatValue];
    request.standard = _standard;
    request.variety = _variety;
    request.intensityLevel = _intensityLevel;
    request.kld = _kld;
    request.contents = _contents;
    
    for (SupplierInfo *info in _arraySupplier)
    {
        if ([info.name isEqualToString:_supplier])
        {
            request.supplierId = info.supplierId;
            break;
        }
    }
    request.userName = [[Config shareConfig] getName];
    request.arriveTime = _lbArriveDate.text;
    request.techReq = _tvTechReq.text;
    
    
    NSLog(@"goodsName:%@", request.goodsName);
    NSLog(@"hzsId:%@", request.hzsId);
    NSLog(@"number:%lf", request.number);
    NSLog(@"standard:%@", request.standard);
    NSLog(@"variety:%@", request.variety);
    NSLog(@"intensityLevel:%@", request.intensityLevel);
    NSLog(@"kld:%@", request.kld);
    NSLog(@"contents:%@", request.contents);
    NSLog(@"supplierId:%@", request.supplierId);
    NSLog(@"userName:%@", request.userName);
    NSLog(@"arrvierTime:%@", request.arriveTime);
    NSLog(@"techReq:%@", request.techReq);
    
    [[HttpClient shareClient] view:self.view post:URL_P_ADD parameters:[request parsToDictionary]
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [self.navigationController popViewControllerAnimated:YES];
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
    
    if ([_goodsName isEqualToString:SHUINI])
    {
        _dyIndex = 3;
    }
    else if ([_goodsName isEqualToString:SHIZI])
    {
        _dyIndex = 4;
    }
    else if ([_goodsName isEqualToString:SHAZI])
    {
        _dyIndex = 4;
    }
    else if ([_goodsName isEqualToString:KUANGFEN])
    {
        _dyIndex = 2;
    }
    else if ([_goodsName isEqualToString:FENMEIHUI])
    {
        _dyIndex = 2;
    }
    else if ([_goodsName isEqualToString:WAIJIAJI])
    {
        _dyIndex = 2;
    }
    else if ([_goodsName isEqualToString:OTHERS])
    {
        _dyIndex = 1;
    }
    return _dyIndex + 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setView:self.view data:[_arrayGoods copy]];
        cell.lbKey.text = @"商品类型";
        
        NSLog(@"goods:%@", _goodsName);
        
        [cell setContentValue:_goodsName];
        
        
        __weak POrderAddController *weakSelf = self;
        
        
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
        
        if ([_goodsName isEqualToString:SHUINI])
        {
            cell.lbKey.text = @"品种";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SNPZ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayVariety removeAllObjects];
                                       [weakSelf.arrayVariety addObjectsFromArray:response.body];
                                       
                                       weakSelf.variety = weakSelf.arrayVariety[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayVariety copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.variety = content;
                                       }];

                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;
        }
        else if ([_goodsName isEqualToString:SHIZI])
        {
            cell.lbKey.text = @"品种";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SHZPZ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayVariety removeAllObjects];
                                       [weakSelf.arrayVariety addObjectsFromArray:response.body];
                                       
                                       weakSelf.variety = weakSelf.arrayVariety[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayVariety copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.variety = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;
        }
        else if ([_goodsName isEqualToString:SHAZI])
        {
            cell.lbKey.text = @"品种";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SZPZ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayVariety removeAllObjects];
                                       [weakSelf.arrayVariety addObjectsFromArray:response.body];
                                       
                                       weakSelf.variety = weakSelf.arrayVariety[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayVariety copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.variety = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;

        }
        else if ([_goodsName isEqualToString:KUANGFEN])
        {
            cell.lbKey.text = @"等级标准";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = KFDJBZ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayStandard removeAllObjects];
                                       [weakSelf.arrayStandard addObjectsFromArray:response.body];
                                       
                                       weakSelf.standard = weakSelf.arrayStandard[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayStandard copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.standard = content;
                                       }];

                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;

        }
        else if ([_goodsName isEqualToString:FENMEIHUI])
        {
            cell.lbKey.text = @"等级标准";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = FMHDJBZ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayStandard removeAllObjects];
                                       [weakSelf.arrayStandard addObjectsFromArray:response.body];
                                       
                                       weakSelf.standard = weakSelf.arrayStandard[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayStandard copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.standard = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;
        }
        else if ([_goodsName isEqualToString:WAIJIAJI])
        {
            cell.lbKey.text = @"品种";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = WJJPZ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayVariety removeAllObjects];
                                       [weakSelf.arrayVariety addObjectsFromArray:response.body];
                                       
                                       weakSelf.variety = weakSelf.arrayVariety[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayVariety copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.variety = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;
        }
        
    }
    else if (2 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([_goodsName isEqualToString:SHUINI])
        {
            cell.lbKey.text = @"强度等级";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SNQDDJ;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayStandard removeAllObjects];
                                       [weakSelf.arrayStandard addObjectsFromArray:response.body];
                                       
                                       weakSelf.intensityLevel = weakSelf.arrayStandard[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayStandard copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.intensityLevel = content;
                                       }];

                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;

        }
        else if ([_goodsName isEqualToString:SHIZI])
        {
            cell.lbKey.text = @"粒径规格";
            DicRequest *request = [[DicRequest alloc] init];
            request.type = LJGG;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayKld removeAllObjects];
                                       [weakSelf.arrayKld addObjectsFromArray:response.body];
                                       
                                       weakSelf.kld = weakSelf.arrayKld[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayKld copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.kld = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;

        }
        else if ([_goodsName isEqualToString:SHAZI])
        {
            cell.lbKey.text = @"细度模数";
            DicRequest *request = [[DicRequest alloc] init];
            request.type = XDMS;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayKld removeAllObjects];
                                       [weakSelf.arrayKld addObjectsFromArray:response.body];
                                       
                                       weakSelf.kld = weakSelf.arrayKld[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayKld copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.kld = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;
        }
        
    }
    else if (3 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([_goodsName isEqualToString:SHIZI])
        {
            cell.lbKey.text = @"针片状含量";
            DicRequest *request = [[DicRequest alloc] init];
            request.type = ZPZHL;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayContents removeAllObjects];
                                       [weakSelf.arrayContents addObjectsFromArray:response.body];
                                       
                                       weakSelf.contents = weakSelf.arrayContents[0].value;
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayContents copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.contents = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;

        }
        else if ([_goodsName isEqualToString:SHAZI])
        {
            cell.lbKey.text = @"含泥量";
            DicRequest *request = [[DicRequest alloc] init];
            request.type = HNL;
            
            __weak POrderAddController *weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [weakSelf.arrayContents removeAllObjects];
                                       [weakSelf.arrayContents addObjectsFromArray:response.body];
                                       
                                       weakSelf.contents = weakSelf.arrayContents[0].value;
                                       
                                       
                                       
                                       [cell setView:weakSelf.view data:[weakSelf.arrayContents copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.contents = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            return cell;
        }
        
    }
    
    if (_dyIndex == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"运达时间";
        cell.lbValue.text = @"点击选择运达时间";
        
        cell.lbValue.userInteractionEnabled = YES;
        
        _lbArriveDate = cell.lbValue;
        
        [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)]];
        
        return cell;
    }
    else if (_dyIndex + 1 == indexPath.row)
    {
        KeyEditCell *cell = [KeyEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbKey.text = @"订货量";
        
        cell.tfValue.placeholder = @"订货量";
        
        cell.lbUnit.hidden = NO;
        cell.lbUnit.text = @"吨";
        
        _tfAmount = cell.tfValue;
        
        return cell;
    }
    else if (_dyIndex + 2 == indexPath.row)
    {
        SelectableCell *cell = [SelectableCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbKey.text = @"供应商名称";
        
        [cell setView:self.view data:[_arraySupplier copy]];
        
        __weak POrderAddController *weakSelf = self;
        [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
            
            weakSelf.supplier = content;
            
            for (SupplierInfo *info in _arraySupplier)
            {
                if ([info.name isEqualToString:_supplier])
                {
                    weakSelf.lbSupplierAdmin.text = info.contactsUser;
                    weakSelf.lbSupplierTel.text = info.tel;
                    break;
                }
            }
        }];

        return cell;
    }
    else if (_dyIndex + 3 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"供应商负责人";
        cell.lbValue.text = @"";
        
        _lbSupplierAdmin = cell.lbValue;
        
        for (SupplierInfo *info in _arraySupplier)
        {
            if ([info.name isEqualToString:_supplier])
            {
                cell.lbValue.text = info.contactsUser;
                break;
            }
        }
        
        return cell;
    }
    else if (_dyIndex + 4 == indexPath.row)
    {
        KeyValueCell *cell = [KeyValueCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"供应商电话";
        cell.lbValue.text = @"";
        
        
        _lbSupplierTel = cell.lbValue;
        
        for (SupplierInfo *info in _arraySupplier)
        {
            if ([info.name isEqualToString:_supplier])
            {
                cell.lbValue.text = info.tel;
                break;
            }
        }
        
        return cell;
    }
    else if (_dyIndex + 5 == indexPath.row)
    {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"特殊要求";
        cell.lbPlaceHolder.text = @"特殊要求……";
        
        _tvTechReq = cell.tvContent;
        
        return cell;
    }
    
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dyIndex + 5 ==  indexPath.row)
    {
        return [KeyMultiEditCell cellHeight];
    }
    
    return 44;
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
