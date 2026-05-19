//
//  MYToponNativeObject.m
//  FalconAd_Demo
//
//  Created by Eric on 2026/5/17.
//  Copyright © 2026 King_liu. All rights reserved.
//

#import "MYToponNativeObject.h"

@interface MYToponNativeObject()

@property (nonatomic, strong) ATNativeAdRenderConfig *configuration;

@end

@implementation MYToponNativeObject

#pragma mark - 必须实现，获取配置并设置给自定义广告平台 SDK
- (void)setNativeADConfiguration:(ATNativeAdRenderConfig *)configuration {
    self.configuration = configuration;
}

#pragma mark - 必须实现，根据渲染类型注册容器
- (void)registerClickableViews:(NSArray<UIView *> *)clickableViews withContainer:(UIView *)container registerArgument:(ATNativeRegisterArgument *)registerArgument {
    UIViewController *rootVC = self.configuration.rootViewController;
    if (rootVC == nil) {
        rootVC = [ATGeneralManage getCurrentViewControllerWithWindow:nil];
    }
    [self.expressView MY_render];
}

@end
