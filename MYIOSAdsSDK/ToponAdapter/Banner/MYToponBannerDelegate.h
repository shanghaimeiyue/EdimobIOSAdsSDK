//
//  MYToponBannerDelegate.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYToponAdapterCommonHeader.h"

@interface MYToponBannerDelegate : NSObject<MYBannerViewDelegate>

@property (nonatomic, strong) ATBannerAdStatusBridge *adStatusBridge;

@property (nonatomic, strong) MYBannerView *bannerView;

@end
