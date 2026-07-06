//
//  MYAMPSNativeExpressAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/2.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYBZNativeExpressAdapter.h"
#import "MYBZManagerAdapter.h"
#import "MYBZNativeExpressView.h"

@interface MYBZNativeExpressAdapter ()<MYNativeExpressAdDelegate>

@property (nonatomic, strong) MYNativeExpressAd *nativeExpressAd;

@property (nonatomic, assign) BOOL isBiddingRequest;

@property (nonatomic, strong) NSMapTable <MYNativeExpressAdView *, MYBZNativeExpressView *> *nativeMapTable;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@property (nonatomic, strong) AMPSAdConfiguration *adConfiguration;

@end

@implementation MYBZNativeExpressAdapter

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
                    [self myLoadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
                });
            } else {
                if (strongSelf.isBiddingRequest) {
                    NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:250401 userInfo:@{@"NSLocalizedDescription": @"MYBZManagerAdapter init fail"}];
                    if (strongSelf.bidDelegate && [strongSelf.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
                        [strongSelf.bidDelegate requestBiddingPriceFail:strongSelf error:error ext:adConfiguration.ext];
                    }
                } else {
                    NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:270401 userInfo:@{@"NSLocalizedDescription": @"MYBZManagerAdapter init fail"}];
                    if (strongSelf.customDelegate && [strongSelf.customDelegate respondsToSelector:@selector(nativeAdManagerLoadFail:error:ext:)]) {
                        [strongSelf.customDelegate nativeAdManagerLoadFail:strongSelf error:error ext:adConfiguration.ext];
                    }
                }
            }
        }];
    } else {
        [self myLoadAdWithSpaceId:spaceId adConfiguration:adConfiguration];
    }
}

- (void)myLoadAdWithSpaceId:(NSString *)spaceId adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    self.nativeExpressAd = [[MYNativeExpressAd alloc] initWithExpressWithAppId:self.appId spaceId:spaceId adSize:adConfiguration.adSize];
    if ([self.nativeExpressAd respondsToSelector:@selector(delegate)]) {
        self.nativeExpressAd.delegate = self;
    }
    self.adConfiguration = adConfiguration;
    [self startTimeoutTimerWithInterval:adConfiguration.timeoutInterval];
    if ([self.nativeExpressAd respondsToSelector:@selector(MY_loadAd:)]) {
        int adCount = [@(adConfiguration.adCount ?: 1) intValue];
        [self.nativeExpressAd MY_loadAd:adCount];
    }
}

- (void)timeoutTimerSelector {
    NSError *error = [NSError errorWithDomain:@"xyz.adscope.MediationErrorDomain" code:-9999 userInfo:@{@"NSLocalizedDescription": @"MYBZNativeExpressAdapter load ad timeout"}];
    [self MY_nativeExpressAdFailToLoad:error];
}

- (void)removeAd {
    [self invalidateTimeoutTimer];
    if (_viewsArray) {
        _viewsArray = nil;
    }
    if (_nativeExpressAd) {
        if ([_nativeExpressAd respondsToSelector:@selector(delegate)]) {
            _nativeExpressAd.delegate = nil;
        }
        _nativeExpressAd = nil;
    }
}

- (BOOL)isValid {
    return YES;
}

- (void)loadC2SAdWithSpaceId:(NSString *)spaceId
                biddingToken:(id)biddingToken
             adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    if (self.isLoadAdSuccess) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(nativeAdManagerLoadSuccess:ext:)]) {
            [self.customDelegate nativeAdManagerLoadSuccess:self ext:self.adConfiguration.ext];
        }
    }
}

- (void)loadS2SAdWithSpaceId:(NSString *)spaceId
                biddingToken:(id)biddingToken
             adConfiguration:(AMPSAdConfiguration *)adConfiguration {
    
}

- (void)MY_nativeExpressAdSuccessToViews:(NSArray<__kindof MYNativeExpressAdView *> *)views {
    if (_timeoutTimer) {
        [_timeoutTimer invalidate];
        _timeoutTimer = nil;
    }
    NSMutableArray *nativeAdViewArr = [NSMutableArray array];
    NSInteger ecpm = 0;
    for (MYNativeExpressAdView *nativeExpressview in views) {
        if ([nativeExpressview respondsToSelector:@selector(eCPM)]) {
            ecpm = nativeExpressview.eCPM;
        }
        MYBZNativeExpressView *gdtNativeExpressView = [[MYBZNativeExpressView alloc] init];
        gdtNativeExpressView.myNativeAdView = nativeExpressview;
        if (gdtNativeExpressView && nativeExpressview) {
            [self.nativeMapTable setObject:gdtNativeExpressView forKey:nativeExpressview];
            [nativeAdViewArr addObject:gdtNativeExpressView];
        }
    }
    self.viewsArray = [NSArray arrayWithArray:nativeAdViewArr];
    self.isLoadAdSuccess = YES;
    if (!self.isBiddingRequest) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(nativeAdManagerLoadSuccess:ext:)]) {
            [self.customDelegate nativeAdManagerLoadSuccess:self ext:self.adConfiguration.ext];
        }
        return;
    }
    if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceSuccess:ext:)]) {
        [self.bidDelegate requestBiddingPriceSuccess:self ext:self.adConfiguration.ext];
    }
}
 
- (void)MY_nativeExpressAdFailToLoad:(NSError *)error {
    if (self.isBiddingRequest) {
        if (self.bidDelegate && [self.bidDelegate respondsToSelector:@selector(requestBiddingPriceFail:error:ext:)]) {
            [self.bidDelegate requestBiddingPriceFail:self error:error ext:self.adConfiguration.ext];
        }
    } else {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(nativeAdManagerLoadFail:error:ext:)]) {
            [self.customDelegate nativeAdManagerLoadFail:self error:error ext:self.adConfiguration.ext];
        }
    }
    [self removeAd];
}

- (void)MY_nativeExpressAdViewRenderSuccess {
//    MYBZNativeExpressView *myNativeExpressView = [self.nativeMapTable objectForKey:nativeExpressAdView];
//    myNativeExpressView.frame = nativeExpressAdView.frame;
//    [myNativeExpressView addSubview:nativeExpressAdView];
//    if ([nativeExpressAdView respondsToSelector:@selector(controller)]) {
//        nativeExpressAdView.controller = myNativeExpressView.viewController;
//    }
//    if (myNativeExpressView.viewDelegate && [myNativeExpressView.viewDelegate respondsToSelector:@selector(nativeViewRenderSuccess:ext:)]) {
//        [gdtNativeExpressView.viewDelegate nativeViewRenderSuccess:myNativeExpressView ext:self.adConfiguration.ext];
//    }
}

- (void)MY_nativeExpressAdExposure {
//    MYBZNativeExpressView *gdtNativeExpressView = [self.nativeMapTable objectForKey:nativeExpressAdView];
//    if (gdtNativeExpressView.viewDelegate && [gdtNativeExpressView.viewDelegate respondsToSelector:@selector(nativeViewExposured:)]) {
//        [gdtNativeExpressView.viewDelegate nativeViewExposured:gdtNativeExpressView];
//    }
}

- (void)MY_nativeExpressAdClick{
//    MYBZNativeExpressView *gdtNativeExpressView = [self.nativeMapTable objectForKey:nativeExpressAdView];
//    if (gdtNativeExpressView.viewDelegate && [gdtNativeExpressView.viewDelegate respondsToSelector:@selector(nativeViewDidClick:)]) {
//        [gdtNativeExpressView.viewDelegate nativeViewDidClick:gdtNativeExpressView];
//    }
}


- (void)MY_nativeExpressAdViewClosed:(MYNativeExpressAdView *)nativeExpressAdView {
    MYBZNativeExpressView *myNativeExpressView = [self.nativeMapTable objectForKey:nativeExpressAdView];
    if (myNativeExpressView.viewDelegate && [myNativeExpressView.viewDelegate respondsToSelector:@selector(nativeViewDidClose:)]) {
        [myNativeExpressView.viewDelegate nativeViewDidClose:myNativeExpressView];
    }
    [myNativeExpressView removeAd];
}

- (NSMapTable *)nativeMapTable {
    if (!_nativeMapTable) {
        _nativeMapTable = [NSMapTable weakToWeakObjectsMapTable];
    }
    return _nativeMapTable;
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
