//
//  MYInterstitialAd.h
//  MYAdsSDK

//  Created by liudehan on 2017/8/28.
//  Copyright © 2017年 King_liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EdiMobSDK/EMAdsProtocol.h>

@interface EMInterstitialObject : NSObject
/// 广告标题
@property (nonatomic, copy) NSString *title;
/// 详细信息
@property (nonatomic, copy) NSString *desc;
/// 图片 url
@property (nonatomic, copy) NSString *iurl;
/// icon 图标url
@property (nonatomic, copy) NSString *icurl;

/// 当前素材列表对应的id,用于追踪、排查问题
@property (nonatomic, copy) NSString *Id;
/// 对应 BidRequest.imp.id
@property (nonatomic, copy) NSString *impid;
/// 广告ID
@property (nonatomic, copy) NSString *adid;
/// 价格（单位分）
@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSArray *opurl;
/// 广告点击跳转的地址
@property (nonatomic, copy) NSString *laurl;
/// 广告点击交互类型 0:普通h5，1：下载，2：微信⼩程序唤起，3：deeplink直呼
@property (nonatomic, assign) NSInteger interact;
/// 小程序原始ID
@property (nonatomic, copy) NSString *miniId;
/// 小程序跳转路径
@property (nonatomic, copy) NSString *path;
/// 小程序操作上报，需宏替换{CALL_UP_RESULT}
@property (nonatomic, copy) NSArray *trackings;

@property(nonatomic,strong)NSString *fallback;
@end

@protocol EMInterstitialAdDelegate <NSObject>

@optional

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 *  在此方法中调用FAL_presentFromRootViewController：需放在主线程中
 */
- (void)EM_interstitialSuccessToLoadAd:(EMInterstitialObject *)adObject;

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)EM_interstitialFailToLoadAd:(NSError *)error;

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)EM_interstitialClose;

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)EM_interstitialExposure;

/**
 *  插屏广告点击回调
 */
- (void)EM_interstitialClicked;


@end

@interface EMInterstitialAd : NSObject<EMAdsProtocol>

/**
 *  委托对象
 */
@property (nonatomic, weak) id<EMInterstitialAdDelegate> delegate;


/*
 *  viewControllerForPresentingModalView
 *  详解：[必选]开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 *  当需要在Tabbar页面弹出时，根视图须设置为Tabbar，否则会影响广告后续点击
 */
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) NSString *requestUid;

/**
 *  构造方法
 */
-(instancetype)initWithSlotId:(NSString *)slotId;

/**
 *  广告发起请求方法
 *  详解：[必选]发起拉取广告请求
 */
-(void)EM_loadAd;

/**
 *  广告展示方法
 *  详解：[必选]发起展示广告请求, 必须传入用于显示插播广告的UIViewController
 */
-(void)EM_presentFromRootViewController:(UIViewController *)rootViewController;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;
@end

