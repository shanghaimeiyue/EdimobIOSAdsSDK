//
//  MyInitAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponInitAdapter.h"

@implementation MYToponInitAdapter

/// Init Ad SDK
/// - Parameter adInitArgument: server info
- (void)initWithInitArgument:(ATAdInitArgument *)adInitArgument {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Get dashboard setting params in serverContentDic
        NSString *appId = adInitArgument.serverContentDic[@"app_id"];
        if (appId != nil && appId.length > 0) {
            [[MYAdsConfiguration shareInstance] initConfigurationWithAppId:adInitArgument.serverContentDic[@"app_id"] ?: @""];
            [self notificationNetworkInitSuccess];
        }else {
            NSError *error = [NSError errorWithDomain:@"MYToponInitAdapter init fail" code:-1 userInfo:@{}];
            [self notificationNetworkInitFail:error];
        }
    });
}

#pragma mark - version
- (nullable NSString *)sdkVersion {
    return [[MYAdsConfiguration shareInstance] sdkVersion];
}

- (nullable NSString *)adapterVersion {
    return @"5.9.05";
}

@end
