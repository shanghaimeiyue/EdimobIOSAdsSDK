//
//  MYNativeAdDataObject.h
//  MYAdsSDK
//
//  Created by Eric on 2021/5/4.
//  Copyright © 2021 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class EMMediaView;

@protocol EMNativeAdDataObjectDelegate <NSObject>

/**
 * 原生广告曝光
 */
- (void)EM_nativeAdDataExpose;


/**
 * 原生广告点击
 */
- (void)EM_nativeAdDataDidClick;

@end


@interface EMNativeAdDataObject : NSObject
/**
 代理方法
 */
@property (nonatomic, weak) id<EMNativeAdDataObjectDelegate> delegate;

/**
 广告标题
 */
@property (nonatomic, copy) NSString *title;

/**
 广告描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 广告大图Url
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 应用类广告App 图标Url
 */
@property (nonatomic, copy) NSString *iconUrl;

/**
 三小图广告的图片Url集合
 */
@property (nonatomic, copy) NSArray *mediaUrlList;

/**
是否为应用类广告
*/
@property (nonatomic, assign) BOOL isAppAd;

/**
 是否为视频广告
 */
@property (nonatomic, assign) BOOL isVideoAd;


/**
 当返回的为视频广告时，返回Video View  */
@property (nonatomic, strong) EMMediaView *mediaView;

/**
 是否为摇一摇广告
 */
@property (nonatomic, assign) BOOL isShakeAd;

/**
 预算广告标识
 */
@property (nonatomic, copy) NSString *adMarkUrl;

@property (nonatomic, weak) UIViewController *controller;

/**
 价格
 */
@property (nonatomic, assign) NSInteger ecpm;

/**
 *  自渲染视图点击事件注册方法
 *  @param view  媒体自渲染容易视图，必传字段（因为适配需求，建议统一传入GDTUnifiedNativeAdView的子视图）
 *  @param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
 *  注册后会在 view 进入手机窗口并可见时触发曝光回调，同一广告只触发一次
 *  该方法可从任意线程调用，SDK 会将容器注册和曝光检测切换到主线程执行；重复注册会自动解除上一次注册的手势和监听。
 */
- (void)registerContainer:(UIView *)view clickableViews:(NSArray<UIView *> *)clickableViews;

@end
