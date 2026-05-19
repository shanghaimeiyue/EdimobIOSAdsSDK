//
//  MYToponRewardVideoDelegate.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYToponAdapterCommonHeader.h"

@interface MYToponRewardVideoDelegate : NSObject<MYRewardedVideoAdDelagate>

@property (nonatomic, strong) ATRewardedAdStatusBridge * adStatusBridge;

@property (nonatomic, strong) MYRewardedVideoAd *rewardAd;

@end
