//
//  MYBZNativeExpressView.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/3.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYBZNativeExpressView.h"

@interface MYBZNativeExpressView ()

@end

@implementation MYBZNativeExpressView

- (void)removeAd {
    if (_myNativeAdView) {
        [_myNativeAdView removeFromSuperview];
        _myNativeAdView = nil;
    }
}

- (void)render {
    if ([self.myNativeAdView respondsToSelector:@selector(MY_render)]) {
        ([self.myNativeAdView MY_render]);
    }
}

- (NSInteger)eCPM {
    if ([self.myNativeAdView respondsToSelector:@selector(eCPM)]) {
        return self.myNativeAdView.eCPM;
    }
    return 0;
}

- (BOOL)isValid {
    return YES;
}

- (void)dealloc {
    [self removeAd];
}

- (void)sendLossNotificationWithInfo:(nonnull NSDictionary *)lossInfo {
    @try {
        NSInteger winPrice = [[lossInfo objectForKey:AMPS_WIN_PRICE] integerValue];
        NSInteger reason = MYAdBiddingLossReasonLowPriceFilter;
        if ([[lossInfo objectForKey:AMPS_LOSS_REASON] integerValue]) {
            if ([[lossInfo objectForKey:AMPS_LOSS_REASON] integerValue] == kAMPSBiddingLossReasonLowPrice) {
                reason = MYAdBiddingLossReasonBidPriceBelowMaxPrice;
            } else if ([[lossInfo objectForKey:AMPS_LOSS_REASON] integerValue] == kAMPSBiddingLossReasonTimeout) {
                reason = MYAdBiddingLossReasonTimeOut;
            } else if ([[lossInfo objectForKey:AMPS_LOSS_REASON] integerValue] == kAMPSBiddingLossReasonNoBid) {
                reason = MYAdBiddingLossReasonCompetitorFilter;
            }
        }
        if ([self.myNativeAdView respondsToSelector:@selector(sendLossNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_L_WIN_PRICE:@(winPrice),MY_M_L_LOSS_REASON:@(reason)};
            [self.myNativeAdView sendLossNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)sendWinNotificationWithInfo:(nonnull NSDictionary *)winInfo {
    @try {
        NSInteger lossPrice = [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] ? [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] : [[winInfo objectForKey:AMPS_WIN_PRICE] integerValue] - 1;
        if ([self.myNativeAdView respondsToSelector:@selector(sendWinNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_W_H_LOSS_PRICE:@(lossPrice)};
            [self.myNativeAdView sendWinNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

@end
