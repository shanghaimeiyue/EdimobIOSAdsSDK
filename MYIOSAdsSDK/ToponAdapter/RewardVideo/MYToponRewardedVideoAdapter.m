//
//  MYToponRewardedVideoAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponRewardedVideoAdapter.h"
#import "MYToponRewardVideoDelegate.h"

@interface MYToponRewardedVideoAdapter()

@property (nonatomic, strong) MYToponRewardVideoDelegate *rewardedVideoDelegate;

@property (nonatomic, strong) MYRewardedVideoAd *rewardAd;

@end


@implementation MYToponRewardedVideoAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *spaceId = argument.serverContentDic[@"unit_id"] ?: @"";
        NSString *appId = argument.serverContentDic[@"app_id"] ?: @"";
        MYRewardedVideoModel *model = [[MYRewardedVideoModel alloc]init];
        self.rewardAd = [[MYRewardedVideoAd alloc] initRewardedVideoWithAppId:appId spaceId:spaceId andRewardModel:model];
        self.rewardAd.delegate = self.rewardedVideoDelegate;
        self.rewardedVideoDelegate.rewardAd = self.rewardAd;
        [self.rewardAd MY_loadAdData];
    });
}
 
#pragma mark - Ad show
- (void)showRewardedVideoInViewController:(UIViewController *)viewController {
    [self.rewardAd MY_showAdFromRootViewController:viewController];
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
    NSMutableDictionary *infoDic = [MYToponBaseAdapter getWinInfoResult:result];
    [self.rewardAd sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
    NSString *priceStr = [NSString stringWithFormat:@"%ld",self.rewardAd.eCPM];
    NSMutableDictionary *infoDict = [MYToponBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:MY_M_L_WIN_PRICE];
    [self.rewardAd sendLossNotificationWithInfo:infoDict];
}

#pragma mark - lazy
- (MYToponRewardVideoDelegate *)rewardedVideoDelegate{
    if (_rewardedVideoDelegate == nil) {
        _rewardedVideoDelegate = [[MYToponRewardVideoDelegate alloc] init];
        _rewardedVideoDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _rewardedVideoDelegate;
}
@end
