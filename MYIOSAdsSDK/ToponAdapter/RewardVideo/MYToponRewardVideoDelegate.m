//
//  MYToponRewardVideoDelegate.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponRewardVideoDelegate.h"

@implementation MYToponRewardVideoDelegate

- (void)MY_rewardedVideoAdDidLoad {
    NSDictionary * extraDic = [MYToponBaseAdapter getC2SInfo:[self.rewardAd eCPM] networkAdObj:self.rewardAd];
    [self.adStatusBridge atOnRewardedAdLoadedExtra:extraDic];
}
- (void)MY_rewardedVideoAdWillVisible {
    // 广告展示成功回调
    [self.adStatusBridge atOnAdShow:nil];
}
- (void)MY_rewardedVideoAdDidClose {
    [self.adStatusBridge atOnAdClosed:nil];
}
- (void)MY_rewardedVideoAdDidClickDownload {
    [self.adStatusBridge atOnAdClick:nil];
}
- (void)MY_rewardedVideoAdDidFailWithError:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}
- (void)MY_rewardedVideoAdServerRewardDidSucceed:(MYRewardedVideoModel *)rewardedVideoAd verify:(BOOL)verify {
    if (verify == YES) {
        [self.adStatusBridge atOnRewardedVideoAdRewarded];
    }
}
- (void)MY_adReqId:(NSString *)reqId {
    
}

@end
