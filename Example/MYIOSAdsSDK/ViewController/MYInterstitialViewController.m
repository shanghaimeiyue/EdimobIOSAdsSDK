//
//  MYInterstitialViewController.m
//  MYMobAds_Demo
//
//  Created by Eric on 2017/8/29.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "MYInterstitialViewController.h"
#import <MYAdsFramework/MYAdsFramework.h>

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface MYInterstitialViewController ()<MYInterstitialAdDelegate>
@property (nonatomic, strong)MYInterstitialAd *interstitialObj;
@end

@implementation MYInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.interstitialObj = [[MYInterstitialAd alloc] initWithInterstitialWithAppId:MYMobAdsAppID spaceId:InterID];
    self.interstitialObj.viewController = self;
    self.interstitialObj.delegate = self;
    [_interstitialObj MY_loadAd];
    
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

@end
