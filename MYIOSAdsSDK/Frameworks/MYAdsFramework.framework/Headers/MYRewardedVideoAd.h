//
//  MYRewardedVideoAd.h
//  MYAdsSDK
//
//  Created by liudehan on 2018/7/16.
//  Copyright © 2018年 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MYRewardedVideoAdDelagate;
@class MYRewardedVideoModel;

@interface MYRewardedVideoAd : NSObject<MyAdProtocol>

@property (nonatomic, strong) MYRewardedVideoModel *rewardVieoModel;

@property (nonatomic, weak) id<MYRewardedVideoAdDelagate> delegate;

/**
 * 构造方法

 @param spaceId spaceId
 @param model 激励视频Model
 @return 激励视频对象
 */
- (instancetype)initRewardedVideoWithAppId:(NSString *)appId spaceId:(NSString *)spaceId andRewardModel:(MYRewardedVideoModel *)model;

/**
 * 加载数据
 */
- (void)MY_loadAdData;

/**
 展示
 @param rootViewController 将要弹出的视图控制器
 */
- (void)MY_showAdFromRootViewController:(UIViewController *)rootViewController;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;

@end

@protocol MYRewardedVideoAdDelagate <NSObject>

@optional
/**
 rewardedVideoAd 激励视频广告素材加载成功 
 
 */
- (void)MY_rewardedVideoAdDidLoad;

/**
 rewardedVideoAd 广告位即将展示
 
 */
- (void)MY_rewardedVideoAdWillVisible;

/**
 rewardedVideoAd 激励视频广告关闭
 
 */
- (void)MY_rewardedVideoAdDidClose;

/**
 rewardedVideoAd 激励视频广告点击下载

 */
- (void)MY_rewardedVideoAdDidClickDownload;

/**
 rewardedVideoAd 激励视频广告素材加载失败
 @param error 错误对象
 */
- (void)MY_rewardedVideoAdDidFailWithError:(NSError *)error;

/**
 校验后的结果
 
 @param rewardedVideoAd 当前激励视频Model
 @param verify 有效性验证结果
 */
- (void)MY_rewardedVideoAdServerRewardDidSucceed:(MYRewardedVideoModel *)rewardedVideoAd verify:(BOOL)verify;

/**
 * 广告请求唯一ID
 */
- (void)MY_adReqId: (NSString *)reqId;

@end

NS_ASSUME_NONNULL_END
