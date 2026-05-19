//
//  MYToponInterstialAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponInterstialAdapter.h"
#import "MYToponInterstitialDelegate.h"

@interface MYToponInterstialAdapter()

@property (nonatomic, strong) MYToponInterstitialDelegate * interstitialDelegate;

@property (nonatomic, strong) MYInterstitialAd *interstitialAd;

@end

@implementation MYToponInterstialAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *spaceId = argument.serverContentDic[@"unit_id"] ?: @"";
        NSString *appId = argument.serverContentDic[@"app_id"] ?: @"";
        self.interstitialAd = [[MYInterstitialAd alloc] initWithInterstitialWithAppId:appId spaceId:spaceId];
        self.interstitialAd.delegate = self.interstitialDelegate;
        self.interstitialDelegate.interstitialAd = self.interstitialAd;
        [self.interstitialAd MY_loadAd];
    });
}
 
#pragma mark - Ad show
- (void)showInterstitialInViewController:(UIViewController *)viewController {
    [self.interstitialAd MY_presentFromRootViewController:viewController];
}
 
#pragma mark - Ad ready
- (BOOL)adReadyInterstitialWithInfo:(NSDictionary *)info {
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
    NSMutableDictionary *infoDic = [MYToponBaseAdapter getWinInfoResult:result];
    [self.interstitialAd sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
    NSString *priceStr = [NSString stringWithFormat:@"%ld",self.interstitialAd.eCPM];
    NSMutableDictionary *infoDict = [MYToponBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:MY_M_L_WIN_PRICE];
    [self.interstitialAd sendLossNotificationWithInfo:infoDict];
}

#pragma mark - lazy
- (MYToponInterstitialDelegate *)interstitialDelegate{
    if (_interstitialDelegate == nil) {
        _interstitialDelegate = [[MYToponInterstitialDelegate alloc] init];
        _interstitialDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _interstitialDelegate;
}

@end
