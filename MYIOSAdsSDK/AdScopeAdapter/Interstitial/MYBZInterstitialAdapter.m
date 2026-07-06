//
//  MYAMPSInterstitialAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/2.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYBZInterstitialAdapter.h"
#import "MYBZManagerAdapter.h"

@interface MYBZInterstitialAdapter ()<MYInterstitialAdDelegate>

@property (nonatomic, strong) MYInterstitialAd *interstitial;

@property (nonatomic, assign) BOOL isLoadFailHasCallBack;

@property (nonatomic, assign) BOOL isBiddingRequest;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@property (nonatomic, strong) AMPSAdConfiguration *adConfiguration;

@end

@implementation MYBZInterstitialAdapter

- (void)requestBiddingPriceWithSpaceId:(NSString *)spaceId
                       adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    self.isBiddingRequest = YES;
    [self loadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
}

- (void)loadAdWithSpaceId:(nonnull NSString *)spaceId adConfiguration:(nonnull AMPSAdConfiguration *)adConfiguration {
    if (MYBZManagerAdapter.initState != kAdScopeMediationAdapterInitSDKStateSuccess) {
        __weak typeof(self)weakSelf = self;
        [MYBZManagerAdapter startAsyncWithAppId:self.appId configuration:self.sdkConfiguration results:^(BOOL adapterResult) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (adapterResult) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf myLoadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
                });
            } else {
                if (strongSelf.isBiddingRequest) {
                    NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:250401 userInfo:@{@"NSLocalizedDescription": @"MYBZManagerAdapter init fail"}];
                    if (strongSelf.bidDelegate && [strongSelf.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
                        [strongSelf.bidDelegate requestBiddingPriceFail:strongSelf error:error ext:adConfiguration.ext];
                    }
                } else {
                    NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:270401 userInfo:@{@"NSLocalizedDescription": @"MYBZManagerAdapter init fail"}];
                    if (strongSelf.customDelegate && [strongSelf.customDelegate respondsToSelector:@selector(interstitialAdLoadFail:error:ext:)]) {
                        [strongSelf.customDelegate interstitialAdLoadFail:strongSelf error:error ext:adConfiguration.ext];
                    }
                }
            }
        }];
    } else {
        [self myLoadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
    }
}

- (void)myLoadAdWithSpaceId:(NSString *)spaceId adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    @try {
        self.interstitial = [[MYInterstitialAd alloc] initWithInterstitialWithAppId:self.appId spaceId:spaceId];
        if ([self.interstitial respondsToSelector:@selector(delegate)]) {
            self.interstitial.delegate = self;
        }
        if (adConfiguration.viewController != nil) {
            self.interstitial.viewController = adConfiguration.viewController;
        }
        self.adConfiguration = adConfiguration;
        [self startTimeoutTimerWithInterval:adConfiguration.timeoutInterval];
        if ([self.interstitial respondsToSelector:@selector(MY_loadAd)]) {
            [self.interstitial MY_loadAd];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)timeoutTimerSelector {
    @try {
        if (self.isLoadAdSuccess) {
            [self invalidateTimeoutTimer];
            return;
        }
        NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:-9999 userInfo:@{@"NSLocalizedDescription": @"MYBZInterstitialAdapter load ad timeout"}];
        [self MY_interstitialFailToLoadAd:error];
    } @catch (NSException *exception) {
        
    }
}

- (void)removeAd {
    @try {
        [self invalidateTimeoutTimer];
        if (_interstitial) {
            if ([_interstitial respondsToSelector:@selector(delegate)]) {
                _interstitial.delegate = nil;
            }
            _interstitial = nil;
        }
    } @catch (NSException *exception) {
        
    }
}

- (BOOL)isValid {
    return self.isLoadAdSuccess;
}

- (void)showInterstitialAdInViewController:(nonnull UIViewController *)viewController {
    if ([self.interstitial respondsToSelector:@selector(MY_presentFromRootViewController:)]) {
        [self.interstitial MY_presentFromRootViewController:viewController];
    }
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
        if ([self.interstitial respondsToSelector:@selector(sendLossNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_L_WIN_PRICE:@(winPrice),MY_M_L_LOSS_REASON:@(reason)};
            [self.interstitial sendLossNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)sendWinNotificationWithInfo:(nonnull NSDictionary *)winInfo {
    @try {
        NSInteger lossPrice = [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] ? [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] : [[winInfo objectForKey:AMPS_WIN_PRICE] integerValue] - 1;
        if ([self.interstitial respondsToSelector:@selector(sendWinNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_W_H_LOSS_PRICE:@(lossPrice)};
            [self.interstitial sendWinNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)loadC2SAdWithSpaceId:(NSString *)spaceId biddingToken:(id)biddingToken adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    if (self.isLoadAdSuccess) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(interstitialAdLoadSuccess:ext:)]) {
            [self.customDelegate interstitialAdLoadSuccess:self ext:self.adConfiguration.ext];
        }
    }
}

- (void)loadS2SAdWithSpaceId:(NSString *)spaceId biddingToken:(id)biddingToken adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    
}

- (NSInteger)eCPM {
    @try {
        if ([self.interstitial respondsToSelector:@selector(eCPM)]) {
            return self.interstitial.eCPM;
        }
        return 0;
    } @catch (NSException *exception) {
        
    }
}

- (void)MY_interstitialSuccessToLoadAd {
    @try {
        [self invalidateTimeoutTimer];
        self.isLoadAdSuccess = YES;
        if (!self.isBiddingRequest) {
            if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(interstitialAdLoadSuccess:ext:)]) {
                [self.customDelegate interstitialAdLoadSuccess:self ext:self.adConfiguration.ext];
            }
            return;
        }
        if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceSuccess:ext:)]) {
            [self.bidDelegate requestBiddingPriceSuccess:self ext:self.adConfiguration.ext];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)MY_interstitialFailToLoadAd:(NSError *)error {
    @try {
        if (!_isLoadFailHasCallBack) {
            _isLoadFailHasCallBack = YES;
            if (self.isBiddingRequest) {
                if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
                    [self.bidDelegate requestBiddingPriceFail:self error:error ext:self.adConfiguration.ext];
                }
            } else {
                if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(interstitialAdLoadFail:error:ext:)]) {
                    [self.customDelegate interstitialAdLoadFail:self error:error ext:self.adConfiguration.ext];
                }
            }
            [self removeAd];
        }
    } @catch (NSException *exception) {
        
    }
}
- (void)MY_interstitialExposure {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(interstitialAdDidShow:)]) {
        [self.customDelegate interstitialAdDidShow:self];
    }
}

- (void)MY_interstitialClicked {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(interstitialAdDidClick:)]) {
        [self.customDelegate interstitialAdDidClick:self];
    }
}

- (void)MY_interstitialClose {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(interstitialAdDidClose:)]) {
        [self.customDelegate interstitialAdDidClose:self];
    }
    [self removeAd];
}

- (void)dealloc {
    [self removeAd];
}

#pragma mark - Private
- (void)startTimeoutTimerWithInterval:(NSTimeInterval)timeoutInterval {
    [self invalidateTimeoutTimer];
    NSTimeInterval interval = timeoutInterval > 0 ? timeoutInterval / 1000.0 : 5.0;
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:self
                                                       selector:@selector(timeoutTimerSelector)
                                                       userInfo:nil
                                                        repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timeoutTimer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimeoutTimer {
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
}
@end
