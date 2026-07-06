//
//  MYAMPSNativeExpressAdapter.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/2.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBZAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYBZNativeExpressAdapter : NSObject<AMPSCustomNativeManagerProtocol>

@property (nonatomic, weak, nullable) id<AMPSCustomNativeDelegate> customDelegate;

@property (nonatomic, weak, nullable) id<AMPSCustomBiddingDelegate> bidDelegate;

@property (nonatomic, strong) id adapterModel;

@property (nonatomic, strong) NSArray<id<AMPSCustomNativeViewProtocol>> *viewsArray;

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, strong) AMPSAdSDKConfiguration *sdkConfiguration;

@end

NS_ASSUME_NONNULL_END
