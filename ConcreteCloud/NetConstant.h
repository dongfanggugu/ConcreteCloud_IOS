//
//  NetConstant.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef NetConstant_h
#define NetConstant_h

#define URL_LOGIN @"login"

#define URL_LOGOUT @"logout"

//获取采购订单列表
#define URL_P_ORDER @"getSupplierOrderList"

//获取信息列表
#define URL_GET_MSG @"getMessage"

//获取供应商列表
#define URL_GET_SUPPLIER @"getSupplierByHzsIdMatters"

//采购员获取统计数据
#define URL_P_STATISTICS @"getStatisticalByHzsId"

//获取商品相关信息字典表
#define URL_P_DICS @"getDictionary"

//获取供应商列表
#define URL_GET_SUPPLIER2 @"getSupplierList"

//采购订单添加
#define URL_P_ADD @"addSupplierOrder"

//获取采购订单详情
#define URL_P_DETAIL @"getSuppOrderDetailsById"

//获取采购订单运送进度
#define URL_P_PROCESS @"getSuppOrderStateById"

//获取采购订单运送车辆信息
#define URL_P_VEHICLE @"getVehiclePositionInfo"

//获取车辆轨迹
#define URL_VEHICLE_TRAIL @"getHzsOrderProcessTrackByTaskId"

//阅读消息
#define URL_MSG_READ @"updateMessage"

//修改密码
#define URL_PWD_MODIFY @"editUserPwd"

//获取接收的消息类型
#define URL_MY_MSG @"getMsgTypeByUserId"

//更新接收的消息类型
#define URL_UPDATE_MY_MSG @"updateMsgTypeByUserId"

//获取混凝土订单列表
#define URL_D_ORDER @"getHzsOrderList"

//搅拌站获取工程列表
#define URL_PROJECT_LIST @"getSiteListByHzs"

//获取可见的租赁商
#define URL_GET_RENTER @"getLeaseByIsRelease"

//给工地授权
#define URL_AUTHORIZE @"addSiteAuthByHzs"

//解除工地授权
#define URL_UNAUTHORIZE @"deleteSiteAuthByHzs"

//获取混凝土订单详情
#define URL_D_DETAIL @"getHzsOrderDetail"

//获取混凝土订单进度
#define URL_D_PROCESS @"getHzsOrderTransportProgress"

//获取混凝土运输单列表
#define URL_D_TASK @"getHzsOrderTransportProcess"

//确认混凝土订单
#define URL_D_CONFIRM @"confirmHzsOrder"

//运送完成
#define URL_CARRY_FINISH @"confirmHzsOrderSendComplete"

//混凝土订单完成
#define URL_D_FINISH @"confirmHzsOrderFinish"

//搅拌站获取闲置的租赁车辆
#define URL_RENT_VIHICLES @"getVehicleByLease"

//获取授权过的搅拌站
#define URL_HZS_AUTH @"getHzsListBySite"

//获取未授权过的搅拌站
#define URL_HZS_UNAUTH @"getHzsListBySiteNotSiteauth"

//添加混凝土订单
#define URL_S_ADD @"addHzsOrder"

//获取机构人员列表
#define URL_STAFF_LIST @"getLeaseUserList"

//添加工地人员
#define URL_SITE_STAFF_ADD @"addUserBySite"

//工地获取泵车任务单列表
#define URL_PUMP_LIST @"getHzsOrderProcessBySiteIdNotCompletePumpTruck"

//获取上下班状态
#define URL_WORK_STATE @"getWorkStateByUserId"

//A单待检验的运输单列表
#define URL_A_CHECK @"getWaitExamHzsOrderProcess"

//A单待工地检验运输单列表
#define URL_A_CHECK_SITE @"getWaitSpotExamHzsOrderProcess"

//A单检验任务历史
#define URL_A_CHECK_LIST @"getHistoryHzsOrderProcessByExam"

//获取A单检验视频
#define URL_A_CHECK_VIDEO @"getVideoList"

//获取上下班状态
#define URL_WORK_STATE @"getWorkStateByUserId"

//上班
#define URL_UP_WORK @"upWork"

//下班
#define URL_DOWN_WORK @"downWork"

//B单待检验的运输单列表
#define URL_B_CHECK @"getIngSuppOrderDerpocessListByhzsId"

//搅拌站罐车司机获取未完成的搅拌站订单列表
#define URL_TANKER_ORDERS @"getTransportOrderListByDriver"

//获取搅拌站车辆列表
#define URL_HZS_VEHICEL @"getVehicleListByHzsDriver"

//搅拌站司机添加运输单
#define URL_ADD_TASK @"addHzsOrderProcessByDriver"

//搅拌站罐车司机后去未完成的运输单
#define URL_UNFINISHED_TASK @"getUnFinishHzsOrderProcessByDriver"

//司机到达工程
#define URL_ARRIVED_SITE @"edit_arriveAtTheSite"

//司机完成运输单
#define URL_FINISH_TASK @"updateHzsOrderProcessFinish"

//搅拌站司机获取历史运输单
#define URL_HZS_TASK_HISTORY @"getHistoryHzsOrderProcessByDriver"

//司机获取统计数据
#define URL_DRIVER_STATISTICS @"getHzsOrderProcessDriverStatistical"

//租赁车辆列表
#define URL_RENT_VEHICLE @"getLeaseVehicleList"

//租赁车司机上班，获取当前绑定车辆
#define URL_RENT_CUR_VEHICLE @"getLeaseVehicleByDriverId"

//租赁获取搅拌站列表
#define URL_RENT_GET_HZS @"getHzsList"

//租赁司机和车绑定
#define URL_RENT_BIND @"editDriver"

//租赁司机和车解绑
#define URL_RENT_UNBIND @"editDriverEmpty"

//租赁司机获取历史任务单
#define URL_RENT_HISTORY @"getCompleteHzsOrderProcessByDriverId"

//删除租赁车辆
#define URL_RENT_DEL @"deleteVehicle"

//添加租赁车辆
#define URL_RENT_ADD @"addLeaseVehicle"

//供应商司机获取进行中任务
#define URL_SUP_TASK @"getVehicleAndSupplierOrderProcessByDriverId"

//供应商司机获取历史任务单
#define URL_SUP_HISTORY @"getSuppHistoricalOrderDerpocessList"

//供应商车辆启运
#define URL_SUP_START @"editSupplierorderprocessDeparture"

//供应商司机确认完成当前运输单
#define URL_SUP_COMPLETE @"updateSuppOrderDerpocessFinish"

//供应商管理员获取已经指派的车辆列表
#define URL_SUP_VEHICLE_LIST @"getSuppOrderDerpocessListByOrderId"

//供应商管理员获取空闲车辆列表
#define URL_SUP_FREE_VEHICLE @"getVehicleListForAssign"

//供应商管理员获取空闲司机列表
#define URL_SUP_FREE_DRIVER @"getUserListForAssign"

//供应商管理员指派车辆
#define URL_SUP_DISPATCH_VEHICLE @"addSuppOrderDerpocess"

//供应商管理员确认订单
#define URL_SUP_CONFIRM @"updateSuppAffirmById"

//供应商管理员获取人员列表
#define URL_SUP_STAFF @"getSupplierPersonnelList"

//供应商管理员获取车辆列表
#define URL_SUP_VEHICLE @"getVehicleList"

//原材料检验员获取历史任务单
#define  URL_B_CHECK_HISTORY @"getHistorySuppOrderDerpocessListByhzsId"

//获取统计的工地列表
#define URL_HZS_STA_SITE @"getSiteByHzsIdMatters"

//原材料检验视频上传
#define URL_B_CHECK_VIDEO @"updateSupplierOrderProcessByExam"

//工地现场检验视频上传
#define URL_A_CHECK_SPOT @"updateHzsOrderProcessBySpot"

//混凝土出厂视频上传
#define URL_A_CHECK_OUT @"updateHzsOrderProcessByExam"

//视频上传
#define URL_VIDEO_UPLOAD @"uploadVideo"

//原材料检验员退货
#define URL_B_CHECK_REJECT @"editOperationSuppOrderDerpocess"

//获取聊天记录
#define URL_GET_CHAT_LIST @"getChatList"

//上传音频
#define URL_UPLOAD_MP3 @"uploadAudio"

//添加聊天记录
#define URL_ADD_CHAT @"addChat"

//司机点击启运的操作距离限制
#define URL_START_UP_LIMIT @"getRegion"

//车辆上传位置
#define URL_VEHICLE_UPLOAD_LOCATION @"uploadLocationWithHzsOrderProcess"

//租赁车空闲时上传位置
#define URL_RENT_RELAX_UPLOAD_LOCATION @"editVehiclePosition"

//供应商司机上传位置
#define URL_SUPPLIER_UPLOAD_LOCATION @"uploadLocationWithSupplierOrderProcess"

//工程工地注册
#define URL_SITE_REGISTER @"addSite"

//供应商注册
#define URL_SUPPLIER_REGISTER @"addSupplier"

//租赁商注册
#define URL_RENTER_REGISTER @"addLease"

//搅拌站获取正在执行任务的工地列表
#define URL_HZS_SITE @"getSiteByHzsOrder"

//工地获取正在执行任务的搅拌站列表
#define URL_SITE_HZS @"getHzsBySiteOnHzsOrder"

//搅拌站获取产生采购关系的供应商列表
#define URL_HZS_SUPPLIER @"getSupplierByhzsOnSupplierOrder"

//B单订单完成
#define URL_B_COMPLETE @"updateSuppOrderFinishById"

//调度员获取混凝土订单运输详情
#define URL_A_CARRY_DETAIL @"getHzsOrderAllTransportProcess"

//A单距离和时间预估
#define URL_A_DIS_TIME @"checkTimeAndDistanceWithHzsOrderProcess"

//B单距离和时间预估
#define URL_B_DIS_TIME @"checkTimeAndDistanceWithSupplierOrderProcess"

//供应商删除未启运的运输单
#define URL_SUP_DELETE_TASK @"deleteSupplierOrderProcess"

//修改供应商地址
#define URL_SUP_ADDRESS_MODIFY @"editSupplierAddress"

//供应商添加人员
#define URL_SUP_ADD_STAFF @"AddSupplierPersonnel"

//租赁添加司机
#define URL_RENTER_ADD_DRIVER @"addLeaseDriver"

//供应商添加车辆
#define URL_SUP_ADD_VEHICLE @"AddsuppVehicle"

//供应商删除车辆
#define URL_SUP_DEL_VEHICLE @"DelsuppVehicleById"

//供应商删除人员
#define URL_SUP_DEL_STAFF @"delSupplierPersonnel"

//工地删除人员
#define URL_SITE_DEL_STAFF @"deleteUserBySite"

//租赁删除司机
#define URL_RENTER_DEL_STAFF @"deleteLeaseUser"

//租赁获取正在执行的泵车
#define URL_RENTER_GET_PUMP @"getVehicleListByNotCompletePumpTruck"

//根据车辆id获取运输单
#define URL_A_TASK_BY_VEHICLE_ID @"getNotCompleteHzsOrderProcessByVehicleId"

//检测版本
#define URL_VERSION_CHECK @"checkVersion"

#endif /* NetConstant_h */
