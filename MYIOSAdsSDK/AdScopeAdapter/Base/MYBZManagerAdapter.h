//
//  MYAMPSSDKManagerAdapter.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/1.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBZAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYBZManagerAdapter : NSObject<AMPSCustomConfigureProtocol>

@property (nonatomic, assign, class) AdScopeMediationAdapterInitSDKState initState;

@end

NS_ASSUME_NONNULL_END
