//
//  MYBannerViewController.m
//  MYMobAds_Demo
//
//  Created by Eric on 2017/8/29.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "MYBannerViewController.h"
#import <MYAdsFramework/MYAdsFramework.h>

@interface MYBannerViewController ()<MYBannerViewDelegate>{
    /// 声明一个MYMobBannerView的实例
    MYBannerView *bannerView;
}

@end

@implementation MYBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
    bannerView = [[MYBannerView alloc]initBannerFrame:CGRectMake(0, 100, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetWidth([UIScreen mainScreen].bounds)/6.4) AppId:MYMobAdsAppID withSpaceId:BannerID];
    bannerView.delegate = self; //设置Delegate
    bannerView.currentViewController = self; //设置当前的ViewController
    [self.view addSubview:bannerView];
    [bannerView MY_loadAdAndShow];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[bannerView removeFromSuperview];
}
#pragma mark - 加载广告
- (IBAction)loadAd:(id)sender {
    [self unLoad:nil];
    bannerView = [[MYBannerView alloc]initBannerFrame:CGRectMake(0, 100, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetWidth([UIScreen mainScreen].bounds)/6.4) AppId:MYMobAdsAppID withSpaceId:BannerID];
    bannerView.delegate = self;
    bannerView.currentViewController = self;
    [self.view addSubview:bannerView];
    [bannerView MY_loadAdAndShow];
}
#pragma mark - 移除广告
- (IBAction)unLoad:(id)sender {
    [bannerView removeFromSuperview];
    // 移除banner的时候一定要置空
    bannerView = nil;
    bannerView.delegate = nil;
}

- (void)MY_bannerViewExposure{
    NSLog(@"横幅广告曝光成功");
}

- (void)MY_bannerViewWillClose{
    NSLog(@"横幅广告即将关闭");
    bannerView = nil;
    bannerView.delegate = nil;
}

- (void)MY_bannerViewClicked{
    NSLog(@"横幅广告被点击");
    MYAppDelegate *delegate = (MYAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.toastLab.text = @"横幅广告被点击";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delegate.toastLab.text = @"";
    });
}
- (void)MY_bannerViewFailToReceived:(NSError *)error{
    NSLog(@"横幅广告加载失败%@",error);
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
