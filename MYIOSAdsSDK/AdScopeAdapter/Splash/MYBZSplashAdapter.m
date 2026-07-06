//
//  MYAMPSSplashAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/2.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYBZSplashAdapter.h"
#import "MYBZManagerAdapter.h"

@interface MYBZSplashAdapter ()<MYSplashAdDelegate>
@property (nonatomic, assign) BOOL isBiddingRequest;
@property (nonatomic, strong) MYSplashAd *splashAd;
@property (nonatomic, strong) AMPSAdConfiguration *adConfiguration;
@property (nonatomic, strong) NSTimer *timeoutTimer;

@end

@implementation MYBZSplashAdapter

- (void)sendWinNotificationWithInfo:(NSDictionary *)winInfo {
    @try {
        NSInteger lossPrice = [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] ? [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] : [[winInfo objectForKey:AMPS_WIN_PRICE] integerValue] - 1;
        if ([self.splashAd respondsToSelector:@selector(sendWinNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_W_H_LOSS_PRICE:@(lossPrice)};
            [self.splashAd sendWinNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)sendLossNotificationWithInfo:(NSDictionary *)lossInfo {
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
        if ([self.splashAd respondsToSelector:@selector(sendLossNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_L_WIN_PRICE:@(winPrice),MY_M_L_LOSS_REASON:@(reason)};
            [self.splashAd sendLossNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)requestBiddingPriceWithSpaceId:(NSString *)spaceId adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    @try {
        self.isBiddingRequest = YES;
        [self loadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
    } @catch (NSException *exception) {
        
    }
}

- (void)loadAdWithSpaceId:(NSString *)spaceId adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    @try {
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
                        NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:250401 userInfo:@{@"NSLocalizedDescription": @"MYBZSplashAdapter init fail"}];
                        if (strongSelf.bidDelegate && [strongSelf.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
                            [strongSelf.bidDelegate requestBiddingPriceFail:strongSelf error:error ext:adConfiguration.ext];
                        }
                    } else {
                        NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:270401 userInfo:@{@"NSLocalizedDescription": @"MYBZSplashAdapter init fail"}];
                        if (strongSelf.customDelegate && [strongSelf.customDelegate respondsToSelector:@selector(splashAdLoadFail:error:ext:)]) {
                            [strongSelf.customDelegate splashAdLoadFail:strongSelf error:error ext:adConfiguration.ext];
                        }
                    }
                }
            }];
        } else {
            [self myLoadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)myLoadAdWithSpaceId:(NSString *)spaceId adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    @try {
        [self invalidateTimeoutTimer];
        self.isLoadAdSuccess = NO;
        self.splashAd = [[MYSplashAd alloc] initWithSpaceId:spaceId];
        UIView *bottomView = adConfiguration.bottomView ?: nil;
        if (bottomView != nil) {
            self.splashAd.customBottomView = bottomView;
        }
        if ([self.splashAd respondsToSelector:@selector(fetchDelay)]) {
            self.splashAd.fetchDelay = adConfiguration.timeoutInterval/1000;
        }
        self.adConfiguration = adConfiguration;
        if ([self.splashAd respondsToSelector:@selector(delegate)]) {
            self.splashAd.delegate = self;
        }
        [self startTimeoutTimerWithInterval:adConfiguration.timeoutInterval];
        if ([self.splashAd respondsToSelector:@selector(MY_loadAd)]) {
            [self.splashAd MY_loadAd];
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
        NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:-9999 userInfo:@{@"NSLocalizedDescription": @"MYBZSplashAdapter load ad timeout"}];
        [self MY_splashAdFailToPresent:error];
    } @catch (NSException *exception) {
        
    }
}

- (void)loadC2SAdWithSpaceId:(NSString *)spaceId
                biddingToken:(id)biddingToken
             adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    if (self.isLoadAdSuccess) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(splashAdLoadSuccess:ext:)]) {
            [self.customDelegate splashAdLoadSuccess:self ext:self.adConfiguration.ext];
        }
    }
}

- (void)loadS2SAdWithSpaceId:(NSString *)spaceId
                biddingToken:(id)biddingToken
             adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    
}

- (NSInteger)eCPM {
    if ([self.splashAd respondsToSelector:@selector(eCPM)]) {
        return self.splashAd.eCPM;
    }
    return 0;
}

- (BOOL)isValid {
    return self.isLoadAdSuccess;
}

- (void)showSplashViewInWindow:(UIWindow *)window {
    @try {
        if ([self.splashAd respondsToSelector:@selector(MY_showInWindow:withBottomView:)]) {
            if (self.adConfiguration.bottomView) {
                UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, self.adConfiguration.bottomView.frame.size.height)];
                [bottomView addSubview:self.adConfiguration.bottomView];
                [self.splashAd MY_showInWindow:window withBottomView:bottomView];
            } else {
                [self.splashAd MY_showInWindow:window withBottomView:nil];
            }
        }
    } @catch (NSException *exception) {
        
    }
}

#pragma mark - MYSplashAdDelegate
- (void)MY_splashAdDidLoad {
    [self invalidateTimeoutTimer];
    self.isLoadAdSuccess = YES;
    if (!self.isBiddingRequest) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(splashAdLoadSuccess:ext:)]) {
            [self.customDelegate splashAdLoadSuccess:self ext:self.adConfiguration.ext];
        }
        return;
    }
    if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceSuccess:ext:)]) {
        [self.bidDelegate requestBiddingPriceSuccess:self ext:self.adConfiguration.ext];
    }
}

- (void)MY_splashAdSuccessPresentScreen {
    if (self.customDelegate &&
        [self.customDelegate respondsToSelector:@selector(splashAdDidShow:)]) {
        [self.customDelegate splashAdDidShow:self];
    }
}

- (void)MY_splashAdExposured {
    if (self.customDelegate &&
        [self.customDelegate respondsToSelector:@selector(splashAdExposured:)]) {
        [self.customDelegate splashAdExposured:self];
    }
}

- (void)MY_splashAdClicked {
    if (self.customDelegate &&
        [self.customDelegate respondsToSelector:@selector(splashAdDidClick:ext:)]) {
        [self.customDelegate splashAdDidClick:self ext:self.adConfiguration.ext];
    }
}

- (void)MY_splashAdClosed {
    if (self.customDelegate &&
        [self.customDelegate respondsToSelector:@selector(splashAdDidClose:)]) {
        [self.customDelegate splashAdDidClose:self];
    }
    [self removeAd];
}

- (void)MY_splashAdFailToPresent:(NSError *)error {
    [self invalidateTimeoutTimer];
    if (self.isBiddingRequest) {
        if (self.bidDelegate &&
            [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
            [self.bidDelegate requestBiddingPriceFail:self error:error ext:self.adConfiguration.ext];
        }
    } else {
        if (self.isLoadAdSuccess) {
            if (self.customDelegate &&
                [self.customDelegate respondsToSelector:@selector(splashAdShowFail:error:ext:)]) {
                [self.customDelegate splashAdShowFail:self error:error ext:self.adConfiguration.ext];
            }
        } else {
            if (self.customDelegate &&
                [self.customDelegate respondsToSelector:@selector(splashAdLoadFail:error:ext:)]) {
                [self.customDelegate splashAdLoadFail:self error:error ext:self.adConfiguration.ext];
            }
        }
    }
    [self removeAd];
}

- (void)MY_splashAdWillClose {
    
}
- (void)MY_splashAdLifeTime:(NSUInteger)time {
    
}
- (void)MY_adReqId:(NSString *)reqId {
    
}

- (void)removeAd {
    [self invalidateTimeoutTimer];
    if (_splashAd) {
        _splashAd.delegate = nil;
        _splashAd = nil;
    }
    self.isBiddingRequest = NO;
    self.isLoadAdSuccess = NO;
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
