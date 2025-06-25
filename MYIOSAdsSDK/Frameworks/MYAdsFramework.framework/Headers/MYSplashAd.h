//
//  MYSplashAd.h
//  Created by liudehan on 2017/8/28.
//  Copyright © 2017年 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdProtocol.h"

@protocol MYSplashAdDelegate <NSObject>

@optional
/**
 *  开屏广告素材加载成功，在此回调中调用show方法展示广告
 */
-(void)MY_splashAdDidLoad;
/**
 *  开屏广告加载成功
 */
-(void)MY_splashAdSuccessPresentScreen;

/**
 *  开屏广告展示失败
 */
-(void)MY_splashAdFailToPresent:(NSError *)error;

/**
 *  开屏广告曝光回调
 */
-(void)MY_splashAdExposured;

/**
 *  开屏广告点击回调
 */
- (void)MY_splashAdClicked;

/**
 *  开屏广告即将关闭回调
 */
- (void)MY_splashAdWillClose;

/**
 *  开屏广告关闭回调
 */
- (void)MY_splashAdClosed;

/**
 * 开屏广告剩余时间回调
 */
- (void)MY_splashAdLifeTime:(NSUInteger)time;

/**
 * 广告请求唯一ID
 */
- (void)MY_adReqId: (NSString *)reqId;
@end

@interface MYSplashAd : NSObject<MyAdProtocol>

/**
 *  委托对象
 */
@property (nonatomic, weak) id<MYSplashAdDelegate> delegate;

/**
 *  拉取广告超时时间，默认为5秒,建议不超过5s。
 */
@property (nonatomic, assign) CGFloat fetchDelay;

/**
 *  传入首页视图控制器，用于开屏V+广告的展示。必传*
 */
@property (nonatomic, weak) UIViewController *zoomController;

/**
 *  自定义底部视图，当需要设置bottomView时必传。
 */
@property (nonatomic, strong) UIView *customBottomView;
/**
 *  构造方法
 */
-(instancetype)initWithSpaceId:(NSString *)spaceId;

/**
 *  发起拉取广告请求，只拉取不展示
 *  详解：广告素材及广告图片拉取成功后会回调splashAdDidLoad方法，当拉取失败时会回调splashAdFailToPresent方法
 */
-(void)MY_loadAd;

/**
 *  展示广告
 *  详解：广告展示成功时会回调splashAdSuccessPresentScreen方法，展示失败时会回调splashAdFailToPresent方法
 *       [可选]将获取的广告以半屏形式展示在传入的Window的上半部，剩余部分展示传入的bottomView
 *       请注意1.bottomView需设置好宽高，所占的空间不能过大，并保证高度不超过屏幕高度的 25%。2.Splash广告只支持竖屏。3.如果展示全屏则bottomView传nil
 *  @param window 展示开屏的容器
 *         bottomView 自定义底部View，可以在此View中设置应用Logo，可为空
 */
-(void)MY_showInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;

@end
