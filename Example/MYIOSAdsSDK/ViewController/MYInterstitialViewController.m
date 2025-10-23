//
//  MYInterstitialViewController.m
//  MYMobAds_Demo
//
//  Created by Eric on 2017/8/29.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "MYInterstitialViewController.h"
#import <MYAdsFramework/MYAdsFramework.h>
//#import <AnyThinkInterstitial//AnyThinkInterstitial.h>
#import "LogManager.h"
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kIntertialSplaceId @"b67d3d4057e525"
@interface MYInterstitialViewController ()<MYInterstitialAdDelegate>
@property (nonatomic, strong)MYInterstitialAd *interstitialObj;
@end

@implementation MYInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.interstitialObj = [[MYInterstitialAd alloc] initWithInterstitialWithAppId:MYMobAdsAppID spaceId:InterID];
//    self.interstitialObj.viewController = self;
//    self.interstitialObj.delegate = self;
//    [_interstitialObj MY_loadAd];
    
}
#pragma mark - 插屏广告代理方法
- (void)MY_interstitialSuccessToLoadAd{
    NSLog(@"插屏广告加载成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.interstitialObj MY_presentFromRootViewController:self];
    });
}

- (void)MY_interstitialFailToLoadAd:(NSError *)error{
    NSLog(@"插屏广告加载失败%@",error);
}

- (void)MY_interstitialExposure{
    NSLog(@"插屏广告曝光成功");
}

- (void)MY_interstitialClicked{
    NSLog(@"插屏广告点击");
    MYAppDelegate *delegate = (MYAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.toastLab.text = @"插屏广告点击";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delegate.toastLab.text = @"";
    });
}
- (void)MY_interstitialClose{
    NSLog(@"插屏广告关闭");
}
#pragma mark - 加载广告
- (IBAction)loadAd:(id)sender {
    [self.interstitialObj MY_loadAd];
//    [[ATAdManager sharedManager] loadADWithPlacementID:kIntertialSplaceId extra:@{} delegate:self];
}
#pragma mark - 展示广告
- (IBAction)showAd:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -- ATAdLoadingDelegate
/// Callback when the successful loading of the ad
//- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
//    NSLog(@"-----%s______%@", __func__, placementID);
//    BOOL isReady = [[ATAdManager sharedManager] interstitialReadyForPlacementID:kIntertialSplaceId];
//    // 展示前需判断广告是否填充
//    if (isReady) {
//       // 广告已填充，展示广告
////       [[ATAdManager sharedManager] showInterstitialWithPlacementID:kIntertialSplaceId inViewController:self delegate:self];
//        [[ATAdManager sharedManager] showInterstitialWithPlacementID:kIntertialSplaceId scene:@"" inViewController:self delegate:self];
//   }
//}



/// Callback of ad loading failure
- (void)didFailToLoadADWithPlacementID:(NSString*)placementID
                                 error:(NSError*)error {
    NSLog(@"-----%s______%@", __func__, error);
    [[LogManager shared] logToTextView:error.localizedDescription];
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra error:(NSError *)error {
    NSLog(@"-----%s______%@", __func__, error);
    [[LogManager shared] logToTextView:error.localizedDescription];
}


- (void)didFailToLoadADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra error:(NSError *)error {
    NSLog(@"-----%s______%@", __func__, error);
    [[LogManager shared] logToTextView:error.localizedDescription];
}


- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}


- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}


- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}


- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}


- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}


#pragma mark -- ATInterstitialDelegate

/// Interstitial ad displayed successfully
- (void)interstitialDidShowForPlacementID:(NSString *)placementID
                                    extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}

/// Interstitial ad clicked
- (void)interstitialDidClickForPlacementID:(NSString *)placementID
                                     extra:(NSDictionary *)extra {
    NSLog(@"-----%s______", __func__);
}

/// Interstitial ad closed
- (void)interstitialDidCloseForPlacementID:(NSString *)placementID
                                     extra:(NSDictionary *)extra {
}
@end
