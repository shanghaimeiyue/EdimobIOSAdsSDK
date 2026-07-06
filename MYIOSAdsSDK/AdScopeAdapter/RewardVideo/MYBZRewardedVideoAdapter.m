//
//  MYAMPSRewardedVieoAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/2.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYBZRewardedVideoAdapter.h"
#import "MYBZManagerAdapter.h"

@interface MYBZRewardedVideoAdapter ()<MYRewardedVideoAdDelagate>
@property (nonatomic, strong) MYRewardedVideoAd *rewardVideoAd;

@property (nonatomic, assign) BOOL isBiddingRequest;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@property (nonatomic, strong) AMPSAdConfiguration *adConfiguration;

@end

@implementation MYBZRewardedVideoAdapter
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
                    if (strongSelf.customDelegate && [strongSelf.customDelegate respondsToSelector:@selector(rewardedVideoAdLoadFail:error:ext:)]) {
                        [strongSelf.customDelegate rewardedVideoAdLoadFail:strongSelf error:error ext:adConfiguration.ext];
                    }
                }
            }
        }];
    } else {
        [self myLoadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
    }
}

- (void)myLoadAdWithSpaceId:(NSString *)spaceId adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    MYRewardedVideoModel *model = [[MYRewardedVideoModel alloc] init];
    model.userId = adConfiguration.userID;
    self.rewardVideoAd = [[MYRewardedVideoAd alloc] initRewardedVideoWithAppId:self.appId spaceId:spaceId andRewardModel:model];
    if ([self.rewardVideoAd respondsToSelector:@selector(delegate)]) {
        self.rewardVideoAd.delegate = self;
    }
    self.adConfiguration = adConfiguration;
    [self startTimeoutTimerWithInterval:adConfiguration.timeoutInterval];
    if ([self.rewardVideoAd respondsToSelector:@selector(MY_loadAdData)]) {
        [self.rewardVideoAd MY_loadAdData];
    }
}

- (void)timeoutTimerSelector {
    NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:-9999 userInfo:@{@"NSLocalizedDescription": @"MYBZRewardedVideoAdapter load ad timeout"}];
    [self MY_rewardedVideoAdDidFailWithError:error];
}

- (void)loadC2SAdWithSpaceId:(NSString *)spaceId biddingToken:(id)biddingToken adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    if (self.isLoadAdSuccess) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdRenderSuccess:)]) {
            [self.customDelegate rewardedVideoAdRenderSuccess:self];
        }
    }
}

- (void)loadS2SAdWithSpaceId:(NSString *)spaceId biddingToken:(id)biddingToken adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    
}

- (NSInteger)eCPM {
    @try {
        if ([self.rewardVideoAd respondsToSelector:@selector(eCPM)]) {
            return self.rewardVideoAd.eCPM;
        }
        return 0;
    } @catch (NSException *exception) {
        
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
        if ([self.rewardVideoAd respondsToSelector:@selector(sendLossNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_L_WIN_PRICE:@(winPrice),MY_M_L_LOSS_REASON:@(reason)};
            [self.rewardVideoAd sendLossNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)sendWinNotificationWithInfo:(nonnull NSDictionary *)winInfo {
    @try {
        NSInteger lossPrice = [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] ? [[winInfo objectForKey:AMPS_HEIGHT_PRICE] integerValue] : [[winInfo objectForKey:AMPS_WIN_PRICE] integerValue] - 1;
        if ([self.rewardVideoAd respondsToSelector:@selector(sendWinNotificationWithInfo:)]) {
            NSDictionary *info = @{MY_M_W_H_LOSS_PRICE:@(lossPrice)};
            [self.rewardVideoAd sendWinNotificationWithInfo:info];
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)removeAd {
    [self invalidateTimeoutTimer];
    if (_rewardVideoAd) {
        if ([_rewardVideoAd respondsToSelector:@selector(delegate)]) {
            _rewardVideoAd.delegate = nil;
        }
        _rewardVideoAd = nil;
    }
}

- (BOOL)isValid {
    return self.isLoadAdSuccess;
}

- (void)showRewardedVideoInViewController:(nonnull UIViewController *)viewController {
    if ( [self.rewardVideoAd respondsToSelector:@selector(MY_showAdFromRootViewController:)]) {
        [self.rewardVideoAd MY_showAdFromRootViewController:viewController];
    }
}

- (void)MY_rewardedVideoAdDidLoad{
    [self invalidateTimeoutTimer];
    self.isLoadAdSuccess = YES;
    if (!self.isBiddingRequest) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdLoadSuccess:ext:)]) {
            [self.customDelegate rewardedVideoAdLoadSuccess:self ext:self.adConfiguration.ext];
        }
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdRenderSuccess:)]) {
            [self.customDelegate rewardedVideoAdRenderSuccess:self];
        }
        return;
    }
    if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceSuccess:ext:)]) {
        [self.bidDelegate requestBiddingPriceSuccess:self ext:self.adConfiguration.ext];
    }
}

- (void)MY_rewardedVideoAdWillVisible {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdDidShow:)]) {
        [self.customDelegate rewardedVideoAdDidShow:self];
    }
}

- (void)MY_rewardedVideoAdDidClose {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdDidClose:)]) {
        [self.customDelegate rewardedVideoAdDidClose:self];
    }
    [self removeAd];
}

- (void)MY_rewardedVideoAdDidClickDownload{
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdDidClick:ext:)]) {
        [self.customDelegate rewardedVideoAdDidClick:self ext:self.adConfiguration.ext];
    }
}

- (void)MY_rewardedVideoAdDidFailWithError:(NSError *)error {
    if (self.isBiddingRequest) {
        if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
            [self.bidDelegate requestBiddingPriceFail:self error:error ext:self.adConfiguration.ext];
        }
    } else {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdLoadFail:error:ext:)]) {
            [self.customDelegate rewardedVideoAdLoadFail:self error:error ext:self.adConfiguration.ext];
        }
    }
    [self removeAd];
}

- (void)MY_rewardedVideoAdServerRewardDidSucceed:(MYRewardedVideoModel *)rewardedVideoAd verify:(BOOL)verify {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(rewardedVideoAdDidRewardEffective:rewardInfo:ext:)]) {
        [self.customDelegate rewardedVideoAdDidRewardEffective:self rewardInfo:[NSString stringWithFormat:@"%@",rewardedVideoAd.userId] ext:self.adConfiguration.ext];
    }
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
