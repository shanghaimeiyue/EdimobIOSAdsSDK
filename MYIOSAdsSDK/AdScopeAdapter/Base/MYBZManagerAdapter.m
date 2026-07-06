//
//  MYAMPSSDKManagerAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/1.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYBZManagerAdapter.h"

@implementation MYBZManagerAdapter

static AdScopeMediationAdapterInitSDKState _initState = kAdScopeMediationAdapterInitSDKStateNormal;

+ (AdScopeMediationAdapterInitSDKState)initState {
    return _initState;
}

+ (void)setInitState:(AdScopeMediationAdapterInitSDKState)initState {
    _initState = initState;
}

+ (void)startAsyncWithAppId:(NSString *)appId configuration:(AMPSAdSDKConfiguration *)configuration results:(AMPSCustomAdapterSDKInitStatusResults)adapterResult {
    @try {
        if (appId.length == 0) {
            MYBZManagerAdapter.initState = kAdScopeMediationAdapterInitSDKStateFail;
            if (adapterResult) {
                adapterResult(NO);
            }
            return;
        }
        MYBZManagerAdapter.initState = kAdScopeMediationAdapterInitSDKStateLoad;
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [[MYAdsConfiguration shareInstance] initConfigurationWithAppId:appId];
                MYBZManagerAdapter.initState = kAdScopeMediationAdapterInitSDKStateSuccess;
                if (adapterResult) {
                    adapterResult(YES);
                }
            } @catch (NSException *exception) {
                MYBZManagerAdapter.initState = kAdScopeMediationAdapterInitSDKStateFail;
                if (adapterResult) {
                    adapterResult(NO);
                }
            }
        });
    } @catch (NSException *exception) {
        
    }
}

+ (void)setPersonalizedRecommendState:(BOOL)state {
    [[MYAdsConfiguration shareInstance] setPersonalizedState:state == YES ? 0:1];
}

+ (NSString *)sdkVersion {
    return [[MYAdsConfiguration shareInstance] sdkVersion] ?: @"";
}

+ (NSString *)adapterVersion {
    return @"5.9.09";
}

@end
