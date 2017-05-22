//
//  SOrderAdd2Controller.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/5/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//  当和金钻石对接成功后，在这里添加混凝土订单
//

#import "SOrderAdd2Controller.h"
#import "SelectableCell.h"
#import "DicInfo.h"
#import "TaluoduDivInfo.h"
#import "KeyValueCell.h"
#import "DicRequest.h"
#import "HzsInfo.h"
#import "DicResponse.h"
#import "TaluoduCell.h"
#import "KeyEditCell.h"
#import "KeyMultiEditCell.h"
#import "DOrderInfo.h"
#import "DatePickerDialog.h"
#import "SOrderAddConfirm2Controller.h"

@interface SOrderAdd2Controller () <UITableViewDelegate, UITableViewDataSource, DatePickerDialogDelegate> {
    //商品类型
    NSMutableArray<id<ListDialogDataDelegate>> *_arrayGoods;
    
    //强度等级
    NSMutableArray<DicInfo *> *_arrayLevel;
    
    //抗渗等级
    NSMutableArray<DicInfo *> *_arrayKsdj;
    
    //石子种类
    NSMutableArray<DicInfo *> *_arraySzzl;
    
    //浇筑方式
    NSMutableArray<DicInfo *> *_arrayJzfs;
    
    //特殊项目
    NSMutableArray<DicInfo *> *_arrayTsxm;
    
    //是否冬施
    NSMutableArray<id<ListDialogDataDelegate>> *_arrayDs;
    
    //塌落度
    NSMutableArray<DicInfo *> *_arraySlump;
    
    
    //静态行的起始序号
    NSInteger _dyIndex;
    
    //订货量
    UITextField *_tfAmount;
    
    //浇筑时间
    UILabel *_lbArriveDate;
    
    //浇筑部位
    UITextField *_tfCastPart;
    
    //生产调度
    UITextView *_tvProduct;
    
    //技术要求
    UITextView *_tvTechReq;
    
    //泵送要求
    UITextView *_tvPumpReq;
}

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *goodsName;

@property (copy, nonatomic) NSString *level;

@property (copy, nonatomic) NSString *ksdj;

@property (copy, nonatomic) NSString *szzl;

@property (copy, nonatomic) NSString *jzfs;

@property (copy, nonatomic) NSString *tsxm;

@property (copy, nonatomic) NSString *slump;

@property (copy, nonatomic) NSString *slumpDiv;

//是否冬施
@property (copy, nonatomic) NSString *ds;


//保存cell状态,用于解决滑出屏幕之后滑回来后文本小时问题
@property (weak, nonatomic) SelectableCell *goodsCell;

@property (weak, nonatomic) SelectableCell *hntLevelCell;

@property (weak, nonatomic) SelectableCell *sjqddjCell;

@property (weak, nonatomic) SelectableCell *ksdjCell;

@property (weak, nonatomic) SelectableCell *szzlCell;

@property (weak, nonatomic) SelectableCell *jzfsCell;

@property (weak, nonatomic) SelectableCell *tsxmCell;

@property (weak, nonatomic) SelectableCell *dsCell;

@property (weak, nonatomic) TaluoduCell *taluoduCell;

@property (weak, nonatomic) KeyEditCell *amountCell;

@property (weak, nonatomic) KeyValueCell *useTimeCell;

@property (weak, nonatomic) KeyEditCell *partCell;

@end

@implementation SOrderAdd2Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"添加订单"];
    [self initNavRightWithText:@"确定"];
    [self initData];
    [self initTableView];
}

- (void)onClickNavRight
{
    if (0 == _level.length
        || 0 == _szzl.length
        || 0 == _jzfs.length
        || 0 == _tsxm.length
        || 0 == _ksdj.length
        || 0 == _slump.length) {
        [HUDClass showHUDWithText:@"无法获取系统商品信息,请返回上一个页面再次进入!"];
        return;
    }
    
    if (0 == _tfAmount.text.length || 0 == [_tfAmount.text floatValue]) {
        [HUDClass showHUDWithText:@"请填写正确的订货量"];
        return;
    }
    
    if ([_lbArriveDate.text isEqualToString:@"点击选择浇筑时间"]) {
        [HUDClass showHUDWithText:@"请选择浇筑时间"];
        return;
    }
    
    if (0 == _tfCastPart.text.length) {
        [HUDClass showHUDWithText:@"请填写浇筑部位"];
        return;
    }
    
    DOrderInfo *orderInfo = [[DOrderInfo alloc] init];
    orderInfo.hzsName = _hzsInfo.name;
    orderInfo.hzsAddrress = _hzsInfo.address;
    orderInfo.goodsName = _goodsName;
    
    
    orderInfo.intensityLevel = _level;
    orderInfo.szzl = _szzl;
    
    orderInfo.jzfs = _jzfs;
    
    orderInfo.tsxm = _tsxm;
    
    orderInfo.ksdj = _ksdj;
    orderInfo.slump = _slump;
    
    orderInfo.dev = _slumpDiv;
    
    orderInfo.ds = [_ds isEqualToString:@"是"] ? 1 : 0;
    
    orderInfo.number = [_tfAmount.text floatValue];
    
    orderInfo.useTime = _lbArriveDate.text;
    
    orderInfo.castingPart = _tfCastPart.text;
    
    orderInfo.hzsId = _hzsInfo.hzsId;
    orderInfo.siteId = [[Config shareConfig] getBranchId];
    orderInfo.siteAddress = [[Config shareConfig] getBranchAddress];
    
    if (0 == _tvProduct.text.length) {
        orderInfo.scdd = @"无";
        
    } else {
        orderInfo.scdd = _tvProduct.text;
    }
    
    if (0 == _tvTechReq.text.length) {
        orderInfo.techReq = @"无";
        
    } else {
        orderInfo.techReq = _tvTechReq.text;
    }
    
    if (0 == _tvPumpReq.text.length) {
        orderInfo.pumpUpReq = @"无";
        
    } else {
        orderInfo.pumpUpReq = _tvPumpReq.text;
    }
    orderInfo.orderUserName = [[Config shareConfig] getName];
    orderInfo.orderUserTel = [[Config shareConfig] getUserName];
    
    SOrderAddConfirm2Controller *controller = [[SOrderAddConfirm2Controller alloc] init];
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
    
    _arrayDs = [NSMutableArray array];
    
    TaluoduDivInfo *ds1 = [[TaluoduDivInfo alloc] initWithKey:@"" content:@"否"];
    TaluoduDivInfo *ds2 = [[TaluoduDivInfo alloc] initWithKey:@"" content:@"是"];
    
    [_arrayDs addObject:ds1];
    [_arrayDs addObject:ds2];
    
    
    _goodsName = [_arrayGoods[0] getShowContent];
    
    _arrayLevel = [NSMutableArray array];
    
    _arrayKsdj = [NSMutableArray array];
    
    _arraySlump = [NSMutableArray array];
    
    _dyIndex = 0;
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.screenWidth, self.screenHeight - 94)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        
        if (_goodsCell) {
            return _goodsCell;
            
        } else {
            SelectableCell *cell = [SelectableCell viewFromNib];
            
            _goodsCell = cell;
            
            [cell setData:[_arrayGoods copy]];
            
            cell.lbKey.text = @"商品名称";
            
            __weak typeof(self) weakSelf = self;
            
            
            void (^block)(NSString *key, NSString *content) = ^(NSString *key, NSString *content) {
                
                weakSelf.goodsName = content;
                [weakSelf.tableView reloadData];
                
            };
            
            [cell setAfterSelectedListener:block];
            
            return cell;
        }
        
    } else if (1 == indexPath.row) {
        
        if ([_goodsName isEqualToString:HNT]) {
            
            if (_hntLevelCell) {
                return _hntLevelCell;
                
            } else {
                
                SelectableCell *cell = [SelectableCell viewFromNib];
                
                _hntLevelCell = cell;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.lbKey.text = @"强度等级";
                
                
                DicRequest *request = [[DicRequest alloc] init];
                request.type = LEVEL;
                
                request.hzsId = _hzsInfo.hzsId;
                
                request.siteName = [[Config shareConfig] getBranchName];
                
                __weak typeof(self) weakSelf = self;
                
                [[HttpClient shareClient] view:self.view post:URL_GET_REMOTE_DIC parameters:[request parsToDictionary]
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                           [_arrayLevel removeAllObjects];
                                           [_arrayLevel addObjectsFromArray:response.body];
                                           
                                           if (0 == _arrayLevel.count) {
                                               return;
                                           }
                                           _level = _arrayLevel[0].value;
                                           
                                           [cell setData:[_arrayLevel copy]];
                                           
                                           [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                               
                                               weakSelf.level = content;
                                           }];
                                           
                                           
                                       } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                           
                                       }];
                return cell;
            }
            
        } else {
            
            if (_sjqddjCell) {
                return _sjqddjCell;
                
            } else {
                
                SelectableCell *cell = [SelectableCell viewFromNib];
                _sjqddjCell = cell;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lbKey.text = @"强度等级";
                
                DicRequest *request = [[DicRequest alloc] init];
                request.type = SJQDDJ;
                request.hzsId = _hzsInfo.hzsId;
                
                request.siteName = [[Config shareConfig] getBranchName];
                
                __weak typeof(self) weakSelf = self;
                
                [[HttpClient shareClient] view:self.view post:URL_GET_REMOTE_DIC parameters:[request parsToDictionary]
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                           [_arrayLevel removeAllObjects];
                                           [_arrayLevel addObjectsFromArray:response.body];
                                           
                                           _level = _arrayLevel[0].value;
                                           
                                           [cell setData:[_arrayLevel copy]];
                                           
                                           [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                               
                                               weakSelf.level = content;
                                           }];
                                           
                                           
                                       } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                           
                                       }];
                
                return cell;
                
            }
        }
    } else if (2 == indexPath.row) {
        if (_ksdjCell) {
            return _ksdjCell;
            
        } else {
            SelectableCell *cell = [SelectableCell viewFromNib];
            _ksdjCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"抗渗等级";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = KSDJ;
            
            request.hzsId = _hzsInfo.hzsId;
            
            request.siteName = [[Config shareConfig] getBranchName];
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_GET_REMOTE_DIC parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arrayKsdj removeAllObjects];
                                       [_arrayKsdj addObjectsFromArray:response.body];
                                       
                                       if (0 == _arrayKsdj.count) {
                                           return;
                                       }
                                       
                                       _ksdj = _arrayKsdj[0].value;
                                       
                                       [cell setData:[_arrayKsdj copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.ksdj = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            
            return cell;
        }
    } else if (3 == indexPath.row) {
        if (_szzlCell) {
            return _szzlCell;
            
        } else {
            SelectableCell *cell = [SelectableCell viewFromNib];
            _szzlCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"石子种类";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SZZL;
            
            request.hzsId = _hzsInfo.hzsId;
            
            request.siteName = [[Config shareConfig] getBranchName];
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_GET_REMOTE_DIC parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arraySzzl removeAllObjects];
                                       [_arraySzzl addObjectsFromArray:response.body];
                                       
                                       if (0 == _arrayKsdj) {
                                           return;
                                       }
                                       
                                       _szzl = _arrayKsdj[0].value;
                                       
                                       [cell setData:[_arraySzzl copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.szzl = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            
            return cell;
        }
    } else if (4 == indexPath.row) {
        if (_taluoduCell) {
            return _taluoduCell;
            
        } else {
            TaluoduCell *cell = [TaluoduCell viewFromNib];
            _taluoduCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = SLUMP;
            
            request.hzsId = _hzsInfo.hzsId;
            
            request.siteName = [[Config shareConfig] getBranchName];
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_P_DICS parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arraySlump removeAllObjects];
                                       [_arraySlump addObjectsFromArray:response.body];
                                       
                                       if (0 == _arraySlump) {
                                           return;
                                       }
                                       
                                       _slump = _arraySlump[0].value;
                                       _slumpDiv = @"10";
                                       
                                       [cell setView:weakSelf.view data:[_arraySlump copy]];
                                       
                                       [cell setLeftAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.slump = content;
                                       }];
                                       
                                       [cell setRightAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.slumpDiv = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            
            
            return cell;
        }
    } else if (5 == indexPath.row) {
        if (_jzfsCell) {
            return _jzfsCell;
            
        } else {
            SelectableCell *cell = [SelectableCell viewFromNib];
            _jzfsCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"浇筑方式";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = JZFS;
            
            request.hzsId = _hzsInfo.hzsId;
            
            request.siteName = [[Config shareConfig] getBranchName];
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_GET_REMOTE_DIC parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arrayJzfs removeAllObjects];
                                       [_arrayJzfs addObjectsFromArray:response.body];
                                       
                                       if (0 == _arrayJzfs.count) {
                                           return;
                                       }
                                       _jzfs = _arrayJzfs[0].value;
                                       
                                       [cell setData:[_arrayJzfs copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.jzfs = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            
            return cell;
        }
    } else if (6 == indexPath.row) {
        if (_tsxmCell) {
            return _tsxmCell;
            
        } else {
            SelectableCell *cell = [SelectableCell viewFromNib];
            _tsxmCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"特殊项目";
            
            DicRequest *request = [[DicRequest alloc] init];
            request.type = TSXM;
            
            request.hzsId = _hzsInfo.hzsId;
            
            request.siteName = [[Config shareConfig] getBranchName];
            
            __weak typeof(self) weakSelf = self;
            
            [[HttpClient shareClient] view:self.view post:URL_GET_REMOTE_DIC parameters:[request parsToDictionary]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       DicResponse *response = [[DicResponse alloc] initWithDictionary:responseObject];
                                       [_arrayTsxm removeAllObjects];
                                       [_arrayTsxm addObjectsFromArray:response.body];
                                       
                                       if (0 == _arrayTsxm.count) {
                                           return;
                                       }
                                       
                                       _tsxm = _arrayTsxm[0].value;
                                       
                                       [cell setData:[_arrayTsxm copy]];
                                       
                                       [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                                           
                                           weakSelf.tsxm = content;
                                       }];
                                       
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *errr) {
                                       
                                   }];
            
            return cell;
        }
    } else if (7 == indexPath.row) {
        if (_dsCell) {
            return _dsCell;
            
        } else {
            SelectableCell *cell = [SelectableCell viewFromNib];
            _dsCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbKey.text = @"是否冬施";
            
            [cell setData:[_arrayDs copy]];
            
            _ds = _arrayDs[0].getShowContent;
            
            __weak typeof (self) weakSelf = self;
            
            [cell setAfterSelectedListener:^(NSString *key, NSString *content) {
                
                weakSelf.ds = content;
            }];

            
            
            return cell;
        }
    } else if (8 == indexPath.row) {
        if (_amountCell) {
            return _amountCell;
            
        } else {
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            _amountCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lbKey.text = @"订货量";
            
            cell.tfValue.placeholder = @"订货量";
            cell.tfValue.keyboardType = UIKeyboardTypeDecimalPad;
            
            cell.lbUnit.hidden = NO;
            cell.lbUnit.text = @"m³";
            
            _tfAmount = cell.tfValue;
            
            return cell;
        }
        
    } else if (9 == indexPath.row) {
        if (_useTimeCell) {
            return _useTimeCell;
            
        } else {
            
            KeyValueCell *cell = [KeyValueCell viewFromNib];
            _useTimeCell = cell;
            
            CGFloat width = self.view.frame.size.width;
            cell.valueWidth.constant = width - 150 - 8 - 8 - 8;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.lbValue.textAlignment = NSTextAlignmentLeft;
            cell.lbKey.text = @"浇筑时间";
            cell.lbValue.text = @"点击选择浇筑时间";
            
            
            cell.lbValue.userInteractionEnabled = YES;
            
            _lbArriveDate = cell.lbValue;
            
            [cell.lbValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(showDatePicker)]];
            
            return cell;
        }
        
    } else if (10 == indexPath.row) {
        if (_partCell) {
            return _partCell;
            
        } else {
            
            KeyEditCell *cell = [KeyEditCell viewFromNib];
            _partCell = cell;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lbKey.text = @"浇筑部位";
            
            cell.tfValue.placeholder = @"浇筑部位";
            
            cell.lbUnit.hidden = YES;
            
            _tfCastPart = cell.tfValue;
            
            return cell;
        }

        
    } else if (11 == indexPath.row) {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"生产调度";
        cell.lbPlaceHolder.text = @"生产调度……";
        
        _tvProduct = cell.tvContent;
        
        return cell;

    } else if (12 == indexPath.row) {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"技术要求";
        cell.lbPlaceHolder.text = @"技术要求……";
        
        _tvTechReq = cell.tvContent;
        
        return cell;

    } else if (13 == indexPath.row) {
        KeyMultiEditCell *cell = [KeyMultiEditCell viewFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbKey.text = @"泵送要求";
        cell.lbPlaceHolder.text = @"泵送要求……";
        
        _tvPumpReq = cell.tvContent;
        
        return cell;

    }
    
    return [KeyValueCell viewFromNib];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (11 ==  indexPath.row || 12 == indexPath.row || 13 == indexPath.row)
    {
        return [KeyMultiEditCell cellHeight];
    }
    
    return 44;
}


- (void)showDatePicker
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    dialog.delegate = self;
    
    [dialog show];
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
