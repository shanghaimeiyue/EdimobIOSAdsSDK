//
//  MYVideoViewController.m
//  MYMobAds_Demo
//
//  Created by Eric on 2017/12/26.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "MYVideoViewController.h"
#import <MYAdsFramework/MYAdsFramework.h>
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface MYVideoViewController ()<MYRewardedVideoAdDelagate>{
    MYRewardedVideoAd *rewardedVideoAd;
}
@property (nonatomic, strong) UIButton *button;
@end

@implementation MYVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    MYRewardedVideoModel *model = [[MYRewardedVideoModel alloc]init];
    model.userId = @"123";
    rewardedVideoAd= [[MYRewardedVideoAd alloc]initRewardedVideoWithAppId:MYMobAdsAppID spaceId:VideoID andRewardModel:model];
    rewardedVideoAd.delegate = self;
    [rewardedVideoAd MY_loadAdData];
}


#pragma mark - 激励视频的代理方法
- (void)MY_rewardedVideoAdDidLoad{
    NSLog(@"激励视频 video did load");
    NSString *info = @"激励视频加载成功";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"激励视频" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 展示激励视屏
- (void)buttonTapped:(id)sender {
    [rewardedVideoAd MY_showAdFromRootViewController:self];
}

- (void)MY_rewardedVideoAdWillVisible{
    NSLog(@"激励视频即将展示");
}
- (void)MY_rewardedVideoAdDidClose{
    NSLog(@"激励视频关闭");
}
- (void)MY_rewardedVideoAdDidClickDownload{
    NSLog(@"激励视频点击下载");
    MYAppDelegate *delegate = (MYAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.toastLab.text = @"激励视频点击下载";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delegate.toastLab.text = @"";
    });
}
- (void)MY_rewardedVideoAdDidFailWithError:(NSError *)error{
    NSLog(@"激励视频素材加载失败");
}
- (void)MY_rewardedVideoAdServerRewardDidSucceed:(MYRewardedVideoModel *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@"激励视频播放有效性验证:%d",verify);
}

#pragma mark - lazy
- (UIButton *)button {
    if (!_button) {
        NSDictionary *attributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:20.0],
            NSForegroundColorAttributeName: [UIColor blackColor]
        };
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"点击观看激励视频" attributes:attributes];
        CGSize stringSize = [attributeString boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading context:nil].size;
        _button = [[UIButton alloc] init];
        [_button setAttributedTitle:attributeString forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, 0, stringSize.width + 16, stringSize.height + 10);
        _button.center = self.view.center;
        [_button.layer setBorderWidth:1.0];
        [_button.layer setBorderColor: [UIColor blackColor].CGColor];
        [_button.layer setCornerRadius:3];
        [_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
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
