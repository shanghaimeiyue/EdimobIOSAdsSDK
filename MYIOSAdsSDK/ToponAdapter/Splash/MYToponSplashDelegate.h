//
//  MYToponSplashDelegate.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYToponAdapterCommonHeader.h"

@interface MYToponSplashDelegate : NSObject<MYSplashAdDelegate>

@property (nonatomic, strong) ATSplashAdStatusBridge * adStatusBridge;

@property (nonatomic, strong,nullable) MYSplashAd *splashView;

@property (nonatomic, strong,nullable) UIView *containerView;


@end
