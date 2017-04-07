//
//  Constant.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark - 第三方key

#define BM_KEY @"VnoOOtp914ZVrNPmKBF3TlGhzeqMy4B0"

#define JPUSH_APPKEY @"7bae52ee2e1cc866435b7999"

#pragma mark- 订单类型

typedef NS_ENUM(NSInteger, Order_Type) {
    Order_A = 2,
    Order_B = 1
};

typedef NS_ENUM(NSInteger, G_Vehicle_Type) {
    Vehicle_Tanker,
    Vehicle_Pump
};

#pragma mark - 商品字典表
//供应商商品
#define GOODS @"supplierGoods"

//砂子品种
#define SZPZ @"szpz"

//搅拌站商品
#define HZSGOODS @"hzsGoods"

//强度等级
#define LEVEL @"intensityLevel"

//塌落度
#define SLUMP @"slump"

//抗渗等级
#define KSDJ @"ksdj"

//砂浆强度等级
#define SJQDDJ @"sjqddj"

//细度模数
#define XDMS @"xdms"

//含泥量
#define HNL @"hnl"

//石子品种
#define SHZPZ @"shzpz"

//粒径规格
#define LJGG @"ljgg"

//针片状含量
#define ZPZHL @"zpzhl"

//水泥品种
#define SNPZ @"snpz"

//水泥强度等级
#define SNQDDJ @"snqddj"

//矿粉等级标准
#define KFDJBZ @"kfdjbz"

//粉煤灰等级标准
#define FMHDJBZ @"fmhdjbz"

//外加剂品种
#define WJJPZ @"wjjpz"

#pragma mark - 公共资源

//接收定位广播
#define Location_Complete @"location_complete"

#define User_Location @"user_location"

#define User_Custom @"user_custom"

#define Custom_Location_Complete @"custom_location_complete"


#pragma mark -- 商品类型

#define SHUINI @"水泥"

#define SHIZI @"石子"

#define SHAZI @"砂子"

#define KUANGFEN @"矿粉"

#define FENMEIHUI @"粉煤灰"

#define WAIJIAJI @"外加剂"

#define OTHERS @"其他"

#define HNT @"混凝土"

#define SHAJIANG  @"砂浆"

#pragma mark - 角色表


//搅拌站采购员
#define HZS_PURCHASER @"525b263c-43bb-4d5c-8165-9914047c7695"

//搅拌站调度员
#define HZS_DISPATCHER @"094c2ad5-d1f7-4b4f-8966-0e6a78e24a6b"

//工地管理员，比工地下单员多一个人员管理功能
#define SITE_ADMIN @"f5bc9ea3-68a0-45e2-9999-9a4effffad70"

//工地下单员
#define SITE_PURCHASER @"b8027140-624c-437d-b23a-67ef6590a9ad"

//工地查看员
#define SITE_CHECKER @"bd0a4efa-0dcf-41d4-9356-7e1efacf67c3"

//混凝土检验员
#define HZS_A_CHECKER @"a0ec472f-ab47-4807-94c4-e93d469a8a2d"

//原材料检验员
#define HZS_B_CHECKER @"6cc049d5-452d-4fc7-ac8d-5d248a869a05"

//搅拌站最高权限人员
#define HZS_OTHERS @"820469f4-04f6-4ba0-979d-fcdc8c10dc0c"

//搅拌站罐车司机
#define HZS_TANKER @"442a3a6d-cb77-46c2-ab7d-ec96c4c670fd"

//搅拌站泵车司机
#define HZS_PUMP @"2d62a890-27bd-45f5-b2c7-f5b82a5b1ea7"

//租赁罐车司机
#define RENT_TANKER @"81f26515-1866-41b2-8c54-4d7559964a6f"

//租赁泵车司机
#define RENT_PUMP @"f0a83552-69e2-4407-bb9d-b696829f2f1c"

//租赁管理员
#define RENT_ADMIN @"d219187e-5d88-4f8c-8e8b-ac3f2f0c2b96"

//供应商司机
#define SUP_DRIVER @"9ca4c507-bac3-4f62-88e4-fc463941e13b"

//供应商管理员
#define SUP_ADMIN @"802264ad-ac81-4e16-b7fe-77150c69ccd2"


#pragma mark - 注册协议

#define REGISTER_PROTOCOL @"1、一切移动客户端用户在下载并浏览APP手机APP软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本网站相关声明和用户服务协议的约束。\n \
2、APP手机APP转载的内容并不代表APP手机APP之意见及观点，也不意味着本网赞同其观点或证实其内容的真实性.\n \
3、APP手机APP转载的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。APP手机APP不提供任何保证，并不承担任何法律责任。\n \
4、APP手机APP所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。\n \
5、APP手机APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由APP手机APP实际控制的任何网页上的内容，APP手机APP不承担任何责任。\n \
6、用户明确并同意其使用APP手机APP网络服务所存在的风险将完全由其本人承担；因其使用APP手机APP网络服务而产生的一切后果也由其本人承担，APP手机APP对此不承担任何责任。\n \
7、除APP手机APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，APP手机APP概不负责，亦不承担任何法律责任。\n \
8、对于因不可抗力或因黑客攻击、通讯线路中断等APP手机APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用APP手机APP，APP手机APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n \
9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n \
10、本网站相关声明版权及其修改权、更新权和最终解释权均属APP手机APP所有。\n"


#endif /* Constant_h */
