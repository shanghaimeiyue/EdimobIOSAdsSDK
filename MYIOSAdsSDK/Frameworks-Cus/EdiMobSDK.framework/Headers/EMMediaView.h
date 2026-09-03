//
//  EMMediaView.h
//  EdiMobSDK
//
//  Created by 刘德汉 on 2023/8/19.
//

#import <UIKit/UIKit.h>


@interface EMMediaView : UIView

/// 是否在视频准备完成后自动播放，默认为 YES。
@property (nonatomic, assign, getter=isAutoPlay) BOOL autoPlay;

/// 是否静音播放，默认为 YES。
@property (nonatomic, assign, getter=isMuted) BOOL muted;

/// 当前视频总时长，单位：秒。
@property (nonatomic, assign, readonly) NSInteger totalTime;

/// 当前播放进度，单位：秒。
@property (nonatomic, assign, readonly) NSInteger currentTime;

/// 准备视频资源。
- (void)preparePlay;
/// 开始播放。
- (void)play;
/// 暂停播放。
- (void)pause;
/// 停止并回到起点。
- (void)stop;
/// 切换静音状态。
- (void)muted;
/// 跳转到指定秒数。
- (void)seekToTime:(NSTimeInterval)time block:(void (^)(BOOL finish))block;

@end
