//
//  MYToponSplashAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/15.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponSplashAdapter.h"
#import "MYToponSplashDelegate.h"

@interface MYToponSplashAdapter()

@property (nonatomic, strong) MYSplashAd *splashAd;

@property (nonatomic, strong) MYToponSplashDelegate *splashDelegate;
 
@end

@implementation MYToponSplashAdapter

#pragma mark - load Ad
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.splashAd = [[MYSplashAd alloc] initWithSpaceId:argument.serverContentDic[@"unit_id"] ?: @""];
        self.splashAd.delegate = self.splashDelegate;
        //Get the bottom logo view
        UIView *containerView = argument.localInfoDic[kATSplashExtraContainerViewKey];
        if (containerView) {
            self.containerView = containerView;
            self.splashAd.customBottomView = containerView;
        }
        self.splashDelegate.splashView = self.splashAd;
        [self.splashAd MY_loadAd];
    });
}
 
// Ad ready
- (BOOL)adReadySplashWithInfo:(NSDictionary *)info {
    return YES;
}

// Ad show
- (void)showSplashAdInWindow:(UIWindow *)window inViewController:(UIViewController *)inViewController parameter:(NSDictionary *)parameter {
    [self.splashAd MY_showInWindow:window withBottomView:self.containerView ? self.containerView : nil];
}

#pragma mark - C2S Win Loss
- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    if (result.bidResultType == ATBidWinLossResultTypeWin) {
        [self sendWin:result];
        return;
    }
    [self sendLoss:result];
}

- (void)sendWin:(ATBidWinLossResult *)result {
    NSMutableDictionary *infoDic = [MYToponBaseAdapter getWinInfoResult:result];
    [self.splashAd sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
    NSString *priceStr = [NSString stringWithFormat:@"%ld",self.splashAd.eCPM];
    NSMutableDictionary *infoDict = [MYToponBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:MY_M_L_WIN_PRICE];
    [self.splashAd sendLossNotificationWithInfo:infoDict];
}

#pragma mark - lazy
- (MYToponSplashDelegate *)splashDelegate {
    if (_splashDelegate == nil) {
        _splashDelegate = [[MYToponSplashDelegate alloc] init];
        _splashDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _splashDelegate;
}

@end
