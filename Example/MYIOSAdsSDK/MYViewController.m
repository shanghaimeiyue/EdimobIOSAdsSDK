//
//  MYViewController.m
//  MYIOSAdsSDK
//
//  Created by zhulonghaigit on 03/07/2024.
//  Copyright (c) 2024 zhulonghaigit. All rights reserved.
//

#import "MYViewController.h"
#import "MYAdsFramework/MYAdsFramework.h"
#import <EdiMobSDK/EdiMobSDK.h>
#import "MYBannerViewController.h"
#import "MYInterstitialViewController.h"
#import "MYNativeViewController.h"
#import "MYVideoViewController.h"
#import "MYAdInfoViewController.h"

//#import <HRAdSDK/HRAdSDK.h>
//#import <BeiZiSDK/BeiZiSDK.h>
//#import <QMAdSDK/QMAdSDK.h>
//#import <OctAdSDK/OctAdManager.h>
#import <JADYun/JADYun.h>
//#import <BUAdSDK/BUAdSDK.h>
//#import <GDTMobSDK/GDTMobSDK.h>
//#import <KSAdSDK/KSAdSDK.h>
#import <UbiXMediation/UbiXMediation.h>
#import <UbiXAdSDK/UbiXAdSDK.h>
//#import <CocoaLumberjack/CocoaLumberjack.h>

@interface MYViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *listArray;
}

@property (nonatomic, strong)UITableView *adList;

@end

@implementation MYViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MYMobAds广告样式";
    listArray = @[@"横幅广告",@"插屏广告",@"原生模板广告",@"激励视频",@"基础信息"];
    [self.view addSubview:self.adList];
    
    NSLog(@"MYAdsConfiguration sdkVersion - %@",[MYAdsConfiguration.shareInstance sdkVersion]);
    NSLog(@"EMSDKConfig sdkVersion - %@",[EMSDKConfig.shareInstance sdkVersion]);
    NSLog(@"[JADYunSDK sdkVersion] = %@",[JADYunSDK sdkVersion]);
//    NSLog(@"[QMAdSDKManager sdkVersion] = %@",[QMAdSDKManager sdkVersion]);
//    NSLog(@"[HRAdSDK sdkVersion] = %@",[HRAdSDK getVersionName]);
//    NSLog(@"[BeiZiSDKManager sdkVersion] = %@",[BeiZiSDKManager sdkVersion]);
//    NSLog(@"[OctAdManager sdkVersion] = %@",[OctAdManager sdkVersion]);
//    
//    NSLog(@"[KSAdSDKManager sdkVersion] = %@",[KSAdSDKManager SDKVersion]);
//    NSLog(@"[BUAdSDKManager sdkVersion] = %@",[BUAdSDKManager SDKVersion]);
//    NSLog(@"[GDTSDKConfig sdkVersion] = %@",[GDTSDKConfig sdkVersion]);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //横幅广告
        MYBannerViewController *banner = [[MYBannerViewController alloc]init];
        [self.navigationController pushViewController:banner animated:YES];
    }else if (indexPath.row == 1){
        //插屏广告
        MYInterstitialViewController *inter = [[MYInterstitialViewController alloc]init];
        [self.navigationController pushViewController:inter animated:YES];
        
    }else if (indexPath.row == 2){
        //原生模板广告
        MYNativeViewController *native = [[MYNativeViewController alloc]init];
        [self.navigationController pushViewController:native animated:YES];
    }else if (indexPath.row == 3){
        MYVideoViewController *video = [[MYVideoViewController alloc]init];
        [self.navigationController pushViewController:video animated:YES];
    }else{
        MYAdInfoViewController *vc = [[MYAdInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma maek - lazy
- (UITableView *)adList{
    if (!_adList) {
        _adList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-64) style:UITableViewStylePlain];
        _adList.delegate = self;
        _adList.dataSource = self;
        [_adList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _adList.tableFooterView = [UIView new];
    }
    return _adList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
