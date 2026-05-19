//
//  MyBaseAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponBaseAdapter.h"

@implementation MYToponBaseAdapter

#pragma mark - adapter init class name define
- (Class)initializeClassName {
    return [MYToponInitAdapter class];
}

#pragma mark - tools
+ (NSMutableDictionary *)getC2SInfo:(NSInteger)ecpm networkAdObj:(id)networkAdObj {
    NSMutableDictionary *infoDic = [MYToponInitAdapter getLoadNetworkObjc:networkAdObj];
    NSString *priceStr = [NSString stringWithFormat:@"%ld",ecpm];
    if ([priceStr doubleValue] < 0) {
        priceStr = @"0";
    }
    [infoDic AT_setDictValue:priceStr key:ATAdSendC2SBidPriceKey];
    [infoDic AT_setDictValue:@(ATBiddingCurrencyTypeCNYCents) key:ATAdSendC2SCurrencyTypeKey];
    return infoDic;
}

+ (NSMutableDictionary *)getLossInfoResult:(ATBidWinLossResult *)winLossResult {
    
    //拼装广告平台 SDK 所需要的信息，每个广告平台 SDK需要的信息各不相同，请根据实际情况来创建信息。
    NSString *errorCode = @"1";

    switch (winLossResult.lossReasonType) {
        case ATBiddingLossWithLowPriceInNormal:
        case ATBiddingLossWithLowPriceInHB:
        case ATBiddingLossWithFloorFilter:
            errorCode = @"1";
            break;
        case ATBiddingLossWithExpire:
            errorCode = @"101";
            break;
        default:
            break;
    }
    
    NSString *winADN = @"2";

    NSString *winLossAdWinnerNetworkFirmID = winLossResult.userInfoDic[kATWinLossAdWinnerNetworkFirmID];
    if ([winLossAdWinnerNetworkFirmID isEqualToString:@"93"]) {
        winADN = @"4";
    }
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];

    [infoDic AT_setDictValue:winLossResult.winPrice key:MY_M_L_WIN_PRICE];
//    //竞败原因 (1：竞争力不足 101：未参与竞价 10001：其他)
    [infoDic AT_setDictValue:errorCode key:MY_M_L_LOSS_REASON];
//    //竞胜方渠道ID (1：美数其他非bidding广告位 2：第三方ADN 3：自售广告主 4：美数其他bidding广告位)
    [infoDic AT_setDictValue:winADN key:MY_M_ADNID];
    return infoDic;
}

+ (NSMutableDictionary *)getWinInfoResult:(ATBidWinLossResult *)winLossResult {
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    //通常需要回传二价
    [infoDic AT_setDictValue:winLossResult.secondPrice key:MY_M_L_LOSS_REASON];
    return infoDic;
}

@end
