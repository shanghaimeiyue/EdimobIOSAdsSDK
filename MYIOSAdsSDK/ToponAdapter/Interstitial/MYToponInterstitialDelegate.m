//
//  MYToponInterstitialDelegate.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponInterstitialDelegate.h"

@implementation MYToponInterstitialDelegate
- (void)MY_interstitialSuccessToLoadAd {
    NSMutableDictionary * extraDic = [MYToponBaseAdapter getC2SInfo:[self.interstitialAd eCPM] networkAdObj:self.interstitialAd];
    [self.adStatusBridge atOnInterstitialAdLoadedExtra:extraDic];
}
- (void)MY_interstitialFailToLoadAd:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];

}
- (void)MY_interstitialClose {
    [self.adStatusBridge atOnAdClosed:nil];
}
- (void)MY_interstitialExposure {
    [self.adStatusBridge atOnAdShow:nil];
}
- (void)MY_interstitialClicked {
    [self.adStatusBridge atOnAdClick:nil];
}
- (void)MY_adReqId: (NSString *)reqId {
    
}

@end
