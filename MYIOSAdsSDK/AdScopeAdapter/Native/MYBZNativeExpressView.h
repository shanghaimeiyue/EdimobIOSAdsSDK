//
//  MYBZNativeExpressView.h
//  FalconAd_Demo
//
//  Created by Eric on 2026/7/3.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBZAdapterCommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYBZNativeExpressView : UIView<AMPSCustomNativeViewProtocol>
@property (nonatomic, weak, nullable) id<AMPSCustomNativeViewAdapterDelegate> viewDelegate;

@property (nonatomic, strong) id adapterModel;

@property (nonatomic, strong, nullable) MYNativeExpressAdView *myNativeAdView;

@property (nonatomic, weak) UIViewController *viewController;


@end

NS_ASSUME_NONNULL_END
