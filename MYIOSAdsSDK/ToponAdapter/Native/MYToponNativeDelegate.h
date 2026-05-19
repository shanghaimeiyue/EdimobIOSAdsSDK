//
//  MYToponNativeDelegate.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYToponAdapterCommonHeader.h"

@interface MYToponNativeDelegate : NSObject<MYNativeExpressAdDelegate>

@property (nonatomic,strong) ATNativeAdStatusBridge *adStatusBridge;

@property (nonatomic, strong) ATAdMediationArgument *adMediationArgument;

@property (nonatomic, strong) MYNativeExpressAd *nativeAd;

@property (nonatomic, strong) MYNativeExpressAdView *expressView;

@end
