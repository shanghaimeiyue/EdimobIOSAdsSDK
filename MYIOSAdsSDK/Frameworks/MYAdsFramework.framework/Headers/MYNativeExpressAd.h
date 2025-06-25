//
//  MYNativeExpressAd.h
//  MYAdsSDK
//
//  Created by liudehan on 2018/8/13.
//  Copyright © 2018年 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYNativeExpressAdView;

@protocol MYNativeExpressAdDelegate <NSObject>
/**
 * 拉取原生模板广告成功
 */
- (void)MY_nativeExpressAdSuccessToViews:(NSArray<__kindof MYNativeExpressAdView *> *)views;

/**
 * 拉取原生模板广告失败
 */
- (void)MY_nativeExpressAdFailToLoad:(NSError *)error;

/**
 * 原生模板广告曝光回调
 */
- (void)MY_nativeExpressAdExposure;

/**
 *  原生模板广告点击回调
 */
- (void)MY_nativeExpressAdClick;

@optional
/**
 * 原生模板广告渲染成功后回调;
 */
- (void)MY_nativeExpressAdViewRenderSuccess;

/**
 * 原生模板广告点击关闭按钮回调;
 */
- (void)MY_nativeExpressAdViewClosed:(MYNativeExpressAdView *)nativeExpressAdView;

/**
 * 广告请求唯一ID
 */
- (void)MY_adReqId: (NSString *)reqId;
@end


@interface MYNativeExpressAd : NSObject

@property (nonatomic, weak) id<MYNativeExpressAdDelegate> delegate;

/*
 *  viewControllerForPresentingModalView
 *  详解：[必选]开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *currentController;

/**
 *  构造方法
 *  详解：appId - 媒体 ID
 *       spaceId - 广告位 ID
 *       adSize - 广告展示的宽高,宽为屏幕宽度 高度最优自适应
 */
- (instancetype)initWithExpressWithAppId:(NSString *)appId spaceId:(NSString *)spaceId adSize:(CGSize)size;

/**
 * 拉取广告
 @param count 广告条数
 *  详解：[必选]发起拉取广告请求,在获得广告数据后回调delegate
 *  最多十条
 */
- (void)MY_loadAd:(int)count;

@end
