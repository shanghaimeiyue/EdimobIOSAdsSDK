//
//  MYToponBannerAdapter.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/17.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponBannerAdapter.h"
#import "MYToponBannerDelegate.h"

@interface MYToponBannerAdapter()

@property (nonatomic, strong) MYToponBannerDelegate * bannerDelegate;

@property (nonatomic, strong) MYBannerView *bannerView;

@end

@implementation MYToponBannerAdapter

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize bannerSize = CGSizeMake(320, 50);
        if (!CGSizeEqualToSize(argument.bannerSize, CGSizeZero)) {
            bannerSize = argument.bannerSize;
        }
        NSString *spaceId = argument.serverContentDic[@"unit_id"] ?: @"";
        NSString *appId = argument.serverContentDic[@"app_id"] ?: @"";
        self.bannerView = [[MYBannerView alloc] initBannerFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height) AppId:appId withSpaceId:spaceId];
        self.bannerView.delegate = self.bannerDelegate;
        self.bannerDelegate.bannerView = self.bannerView;
        [self.bannerView MY_loadAdAndShow];
    });
}

#pragma mark - lazy
- (MYToponBannerDelegate *)bannerDelegate{
    if (_bannerDelegate == nil) {
        _bannerDelegate = [[MYToponBannerDelegate alloc] init];
        _bannerDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _bannerDelegate;
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
    [self.bannerView sendWinNotificationWithInfo:infoDic];
}

- (void)sendLoss:(ATBidWinLossResult *)result {
    NSString *priceStr = [NSString stringWithFormat:@"%ld",self.bannerView.eCPM];
    NSMutableDictionary *infoDict = [MYToponBaseAdapter getLossInfoResult:result];
    [infoDict AT_setDictValue:priceStr key:MY_M_L_WIN_PRICE];
    [self.bannerView sendLossNotificationWithInfo:infoDict];
}
@end
