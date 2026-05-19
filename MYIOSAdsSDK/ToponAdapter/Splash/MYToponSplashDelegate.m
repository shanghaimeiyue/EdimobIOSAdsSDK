//
//  MYToponSplashDelegate.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponSplashDelegate.h"

@implementation MYToponSplashDelegate
-(void)MY_splashAdDidLoad {
    NSMutableDictionary * extraDic = [MYToponBaseAdapter getC2SInfo:[self.splashView eCPM] networkAdObj:self.splashView];
    [self.adStatusBridge atOnSplashAdLoadedExtra:extraDic];
}
-(void)MY_splashAdSuccessPresentScreen {
    
}
-(void)MY_splashAdFailToPresent:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}
-(void)MY_splashAdExposured {
    [self.adStatusBridge atOnAdShow:nil];
}
- (void)MY_splashAdClicked {
    [self.adStatusBridge atOnAdClick:nil];
}
- (void)MY_splashAdWillClose {
    [self.adStatusBridge atOnAdWillClosed:nil];
}
- (void)MY_splashAdClosed {
    [self.adStatusBridge atOnAdClosed:nil];
}
- (void)MY_splashAdLifeTime:(NSUInteger)time {
    
}
- (void)MY_adReqId: (NSString *)reqId {
    
}
@end
