//
//  MYToponNativeAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/17.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponNativeAdapter.h"
#import "MYToponNativeDelegate.h"

@interface MYToponNativeAdapter()

@property (nonatomic, strong) MYToponNativeDelegate *nativeDelegate;
@property (nonatomic, strong) MYNativeExpressAd     *nativeExpressAd;
 
@end
@implementation MYToponNativeAdapter

#pragma mark - init
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize adSize = CGSizeZero;
        if ([argument.localInfoDic[kATExtraInfoNativeAdSizeKey] respondsToSelector:@selector(CGSizeValue)]) {
            CGSize size = [argument.localInfoDic[kATExtraInfoNativeAdSizeKey] CGSizeValue];
            adSize = size;
        }
        NSString *spaceId = argument.serverContentDic[@"unit_id"] ?: @"";
        NSString *appId = argument.serverContentDic[@"app_id"] ?: @"";
        self.nativeExpressAd = [[MYNativeExpressAd alloc] initWithExpressWithAppId:appId spaceId:spaceId adSize:adSize];
        self.nativeExpressAd.delegate = self.nativeDelegate;
        self.nativeDelegate.adMediationArgument = argument;
        self.nativeDelegate.nativeAd = self.nativeExpressAd;
        int adCount = [argument.serverContentDic[@"request_num"] intValue] ? [argument.serverContentDic[@"request_num"] intValue] : 1;
        [self.nativeExpressAd MY_loadAd:adCount];
    });
}

#pragma mark - Ad ready
- (BOOL)adReadyRewardedWithInfo:(NSDictionary *)info {
    return YES;
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    if (result.bidResultType == ATBidWinLossResultTypeWin) {
        [self sendWin:result];
        return;
    }
    [self sendLoss:result];
}

- (void)sendWin:(ATBidWinLossResult *)result {
    NSMutableDictionary *infoDict = [MYToponBaseAdapter getWinInfoResult:result];
    
    NSString *priceStr = [NSString stringWithFormat:@"%ld",self.nativeDelegate.expressView.eCPM];
    [infoDict AT_setDictValue:priceStr key:MY_M_L_WIN_PRICE];
    [self.nativeExpressAd sendWinNotificationWithInfo:infoDict];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
    NSMutableDictionary *infoDic = [MYToponBaseAdapter getLossInfoResult:result];
    [self.nativeExpressAd sendLossNotificationWithInfo:infoDic];
}
 
#pragma mark - lazy
- (MYToponNativeDelegate *)nativeDelegate{
    if (_nativeDelegate == nil) {
        _nativeDelegate = [[MYToponNativeDelegate alloc] init];
        _nativeDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _nativeDelegate;
}

@end
