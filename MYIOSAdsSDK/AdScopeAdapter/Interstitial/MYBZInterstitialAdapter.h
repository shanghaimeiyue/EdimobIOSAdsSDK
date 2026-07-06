//
//  MYAMPSInterstitialAdapter.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/2.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBZAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYBZInterstitialAdapter : NSObject<AMPSCustomInterstitialProtocol>

@property (nonatomic, weak, nullable) id<AMPSCustomInterstitialAdapterDelegate> customDelegate;

@property (nonatomic, weak, nullable) id<AMPSCustomBiddingDelegate> bidDelegate;

@property (nonatomic, assign) BOOL isLoadAdSuccess;

@property (nonatomic, strong) id adapterModel;

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, strong) AMPSAdSDKConfiguration *sdkConfiguration;

@end

NS_ASSUME_NONNULL_END
