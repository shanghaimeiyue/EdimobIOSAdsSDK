//
//  MYNativeExpressAdView.h
//  MYAdsSDK
//
//  Created by liudehan on 2018/8/13.
//  Copyright © 2018年 King_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdProtocol.h"

@interface MYNativeExpressAdView : UIView<MyAdProtocol>

/**
 *[必选]
 *原生模板广告渲染,在广告展示时调用,否则会影响收益;
 */
- (void)MY_render;

/**
 返回广告的eCPM，单位：分
 
 @return 成功返回一个大于等于0的值
 */
- (NSInteger)eCPM;

/**
 返回广告源，注意需要在广告成功返回后调用
 
 @return 成功返回当前广告源
 */
- (MYAdSource)getSouce;

@end

