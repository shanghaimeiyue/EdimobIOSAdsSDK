//
//  MYBannerView.h
//  MYAdsSDK
//
//  Created by liudehan on 2018/1/3.
//  Copyright © 2018年 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdProtocol.h"

@protocol MYBannerViewDelegate <NSObject>

@optional
/**
 Banner广告加载成功
 */
- (void)MY_bannerViewDidLoad;
/**
 Banner广告展示回调
 */
- (void)MY_bannerViewExposure;

/**
 *  请求广告条数据失败后调用
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)MY_bannerViewFailToReceived:(NSError *)error;

/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)MY_bannerViewWillClose;

/**
 *  banner条点击回调
 */
- (void)MY_bannerViewClicked;

/**
 * 广告请求唯一ID
 */
- (void)MY_adReqId: (NSString *)reqId;

@end

@interface MYBannerView : UIView<MyAdProtocol>

/**
 *  父视图
 *  详解：[必选]需设置为显示广告的UIViewController
 */
@property (nonatomic, weak) UIViewController *currentViewController;

/**
 *  委托 [可选]
 *  横幅被移除后要将delegate置为nil
 */
@property(nonatomic, weak) id<MYBannerViewDelegate> delegate;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值，-1表示无权限或后台出现异常
 */
- (NSInteger)eCPM;

/**
 *  构造方法
 *  详解：frame是广告banner展示的位置和大小，包含四个参数(x, y, width, height);
 *  推荐宽高比为6.4:1；传入过高或过低的高度会影响展示;
 */
- (instancetype)initBannerFrame:(CGRect)frame AppId:(NSString *)appId withSpaceId:(NSString *)spaceId;

/**
 *  拉取并展示广告
 */
- (void)MY_loadAdAndShow;


@end
