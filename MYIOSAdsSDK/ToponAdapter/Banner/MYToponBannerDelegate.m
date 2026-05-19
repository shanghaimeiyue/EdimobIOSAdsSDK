//
//  MYToponBannerDelegate.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponBannerDelegate.h"

@implementation MYToponBannerDelegate
- (void)MY_bannerViewDidLoad {
    NSMutableDictionary * extraDic = [MYToponBaseAdapter getC2SInfo:self.bannerView.eCPM networkAdObj:self.bannerView];
    [self.adStatusBridge atOnBannerAdLoadedWithView:self.bannerView adExtra:extraDic];
}
- (void)MY_bannerViewExposure {
    [self.adStatusBridge atOnAdShow:nil];
    
}
- (void)MY_bannerViewFailToReceived:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}
- (void)MY_bannerViewWillClose {
    [self.adStatusBridge atOnAdClosed:nil];
}
- (void)MY_bannerViewClicked {
    [self.adStatusBridge atOnAdClick:nil];
}
- (void)MY_adReqId: (NSString *)reqId {
    
}
@end
