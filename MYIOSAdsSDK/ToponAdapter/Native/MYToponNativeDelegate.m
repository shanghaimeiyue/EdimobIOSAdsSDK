//
//  MYToponNativeDelegate.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponNativeDelegate.h"
#import "MYToponNativeObject.h"

@implementation MYToponNativeDelegate

- (void)MY_nativeExpressAdSuccessToViews:(NSArray<__kindof MYNativeExpressAdView *> *)views {
    self.expressView = views.firstObject;
    NSMutableArray *offerArray = [NSMutableArray array];
    NSDictionary *infoDic = [MYToponBaseAdapter getC2SInfo:[views.firstObject eCPM] networkAdObj:views];
    [views enumerateObjectsUsingBlock:^(MYNativeExpressAdView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MYToponNativeObject *nativeObject = [[MYToponNativeObject alloc] init];
        nativeObject.expressView = obj;
        nativeObject.templateView = obj;
        nativeObject.isExpressAd = YES;
        nativeObject.nativeAdRenderType = ATNativeAdRenderExpress;
        nativeObject.nativeExpressAdViewWidth = obj.frame.size.width;
        nativeObject.nativeExpressAdViewHeight = obj.frame.size.height;
        [offerArray addObject:nativeObject];
    }];
    [self.adStatusBridge atOnNativeAdLoadedArray:offerArray adExtra:infoDic];
}
- (void)MY_nativeExpressAdFailToLoad:(NSError *)error {
    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
}
- (void)MY_nativeExpressAdExposure {
    [self.adStatusBridge atOnAdShow:nil];
}
- (void)MY_nativeExpressAdClick {
    [self.adStatusBridge atOnAdClick:nil];
}
- (void)MY_nativeExpressAdViewRenderSuccess {
    
}
- (void)MY_nativeExpressAdViewClosed:(MYNativeExpressAdView *)nativeExpressAdView {
    [self.adStatusBridge atOnAdClosed:nil];
}
- (void)MY_adReqId: (NSString *)reqId {
    
}

@end
