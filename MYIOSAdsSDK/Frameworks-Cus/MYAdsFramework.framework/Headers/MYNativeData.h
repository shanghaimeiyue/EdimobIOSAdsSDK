//
//  FalconNativeData.h
//  FalconAdSDK
//
//  Created by liudehan on 2017/12/26.
//  Copyright © 2017年 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAdProtocol.h"
@interface MYNativeData : NSObject

/**
 *  viewControllerForPresentingModalView
 *  详解：开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *viewController;

/**
 *  描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  icon
 */
@property (nonatomic, copy) NSString *iconUrl;

/**
 *  主图
 */
@property (nonatomic, copy) NSString *imgUrl;

/**
 *  是否视频广告
 */
@property (nonatomic, assign) BOOL isVideoAd;

/**
 *  是否为摇一摇广告，如果为摇一摇广告，需要自定义展示摇一摇标识
 */
@property (nonatomic, assign) BOOL isShakeAd;

/**
 *  预算广告标识
 */
@property (nonatomic, strong) UIImage *adMarkImage;

/**
 *  返回广告源
 */
@property (nonatomic, assign) MYAdSource adSource;

/**
 * 返回广告的eCPM，单位：分
 */
@property (nonatomic, assign) NSInteger eCPM;

/**
 *  自渲染视图点击事件注册方法
 *  @param view  媒体自渲染容易视图，必传字段（优量汇的有要求，当adSource == MYAdSourceGDT时传入GDTUnifiedNativeAdView）
 *  @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
 */
- (void)registerContainer:(UIView *)view clickableViews:(NSArray<UIView *> *)clickableViews;

/**
 *  自渲染视图绑定视频类View
 *  @param mediaView  视频类广告，用来展示视频的view
 */
- (void)bindMediaView:(UIView *)mediaView;

/**
 *  自渲染视图绑定摇一摇图标
 *  @param shakeImage  摇一摇类广告，用来展示摇一摇的image
 */
- (void)bindShakeImage:(UIImageView *)shakeImage;

@end
