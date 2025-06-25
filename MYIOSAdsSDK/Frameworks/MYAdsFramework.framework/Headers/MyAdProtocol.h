//
//  MyAdProtocol.h
//  MYAdsSDK
//
//  Created by Mac on 2025/4/10.
//  Copyright © 2025 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 竞胜成功第二高的价格
#define MY_M_W_H_LOSS_PRICE @"upperPrice"

/// 竞价失败时候，获胜方价格
#define MY_M_L_WIN_PRICE @"bidFailPrice"
/// 竞价失败原因
#define MY_M_L_LOSS_REASON @"bidFailReason"
/// 对外竞价失败时 获胜的平台 1、优量汇   2、穿山甲   3、快手   4、百度   5、tanx      6、others       7、可根据实际情况拓展
#define MY_M_ADNID  @"bidSucPlatform"

typedef NS_ENUM(NSInteger, MYAdBiddingLossReason) {
    MYAdBiddingLossReasonLowPriceFilter            = 100,     // 底价过滤
    MYAdBiddingLossReasonBidPriceBelowMaxPrice     = 101,     // bid价格低于最高价
    MYAdBiddingLossReasonMaterialBlacklistFilter   = 102,     // 素材黑名单过滤
    MYAdBiddingLossReasonCompetitorFilter          = 103,     // 竞品过滤
    MYAdBiddingLossReasonTimeOut                   = 104,     // 在有效时间内，未返回广告
};

NS_ASSUME_NONNULL_BEGIN

@protocol MyAdProtocol <NSObject>

/**
 *  竞胜之后调用, 需要在调用广告 show 之前调用
 *
 *  @param winInfo 竞胜信息 字典类型，支持的key为以下，注：key是个宏，在MyAdProtocol.h中有定义

 *  MY_M_W_H_LOSS_PRICE：最高失败出价，值类型为NSNumber  *
 *
 */
- (void)sendWinNotificationWithInfo:(NSDictionary *)winInfo;

/**
 *  竞败之后或未参竞调用
 *
 *  @pararm lossInfo 竞败信息，字典类型，注：key是个宏，在MyAdProtocol.h中有定义
 *  MY_M_L_WIN_PRICE ：竞胜价格 (单位: 分)，值类型为NSNumber *，选填
 *  MY_M_L_LOSS_REASON ：美约广告竞败原因，竞败原因参考枚举MYAdBiddingLossReason中的定义，值类型为NSNumber *，必填
 *  MY_M_ADNID  ：竞胜平台  值类型为NSNumber *，必填,   1、优量汇   2、穿山甲   3、快手   4、百度   5、tanx      6、others       7、可根据实际情况拓展
 */
- (void)sendLossNotificationWithInfo:(NSDictionary *)lossInfo;

@end

NS_ASSUME_NONNULL_END
