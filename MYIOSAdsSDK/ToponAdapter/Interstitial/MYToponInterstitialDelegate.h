//
//  MYToponInterstitialDelegate.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYToponAdapterCommonHeader.h"

@interface MYToponInterstitialDelegate : NSObject<MYInterstitialAdDelegate>

@property (nonatomic, strong) ATInterstitialAdStatusBridge *adStatusBridge;

@property (nonatomic, strong) MYInterstitialAd *interstitialAd;

@end
