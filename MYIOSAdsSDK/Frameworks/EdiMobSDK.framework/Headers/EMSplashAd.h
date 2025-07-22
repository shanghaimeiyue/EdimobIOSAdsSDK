//
//  MYSplashAd.h
//  Created by liudehan on 2017/8/28.
//  Copyright © 2017年 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EdiMobSDK/EMAdsProtocol.h>

@interface EMSPlashObject : NSObject
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


@protocol EMSplashAdDelegate <NSObject>

@optional
/**
 *  开屏广告素材加载成功
 */
-(void)EM_splashAdDidLoad:(EMSPlashObject *)admObject;
/**
 *  开屏广告展示成功
 */
-(void)EM_splashAdSuccessPresentScreen;

/**
 *  开屏广告展示失败
 */
-(void)EM_splashAdFailToPresent:(NSError *)error;

/**
 *  开屏广告曝光回调
 */
-(void)EM_splashAdExposured;

/**
 *  开屏广告点击回调
 */
- (void)EM_splashAdClicked;

/**
 *  开屏广告即将关闭回调
 */
- (void)EM_splashAdWillClose;

/**
 *  开屏广告关闭回调
 */
- (void)EM_splashAdClosed;

/**
 * 开屏广告剩余时间回调
 */
- (void)EM_splashAdLifeTime:(NSUInteger)time;

/**
 * 开屏广告详情页关闭
 */
- (void)EM_splashDetailPageClose;
@end

@interface EMSplashAd : NSObject<EMAdsProtocol>

/**
 *  委托对象
 */
@property (nonatomic, weak) id<EMSplashAdDelegate> delegate;

/**
 *  拉取广告超时时间，默认为3秒,建议不超过5s。
 */
@property (nonatomic, assign) CGFloat fetchDelay;

/**
 *  开屏广告跳过时间，默认为5秒,建议不超过5s。
 */
@property (nonatomic, assign) double skipTime;

@property (nonatomic, copy) NSString *requestUid;

/**
 *  构造方法
 */
-(instancetype)initWithSlotId:(NSString *)slotId;

/**
 *  发起拉取广告请求，只拉取不展示
 *  详解：广告素材及广告图片拉取成功后会回调splashAdDidLoad方法，当拉取失败时会回调splashAdFailToPresent方法
 */
- (void)EM_loadAd;

/**
 *  展示广告
 *  详解：广告展示成功时会回调splashAdSuccessPresentScreen方法，展示失败时会回调splashAdFailToPresent方法
 *  @param window 展示开屏的容器
 *         bottomView 自定义底部View，可以在此View中设置应用Logo，如果需要全屏展示，则只需要把bottomView传nil即可
 */
- (void)EM_showInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView customeView:(UIView *)customeView;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;

@end
