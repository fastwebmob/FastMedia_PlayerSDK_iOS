//
//  FWPlayerController.h
//  FWHTTPFLVDemo
//
//  Created by jones on 5/17/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FWLivePlayerStatus) {
    FWLivePlayerError = 0,// 无view场景设置为0
    FWLivePlayerReady = 1,// 与FWLivePlayerError 对应
    FWLivePlayerConnecting = 2,// 建立网络连接
    FWLivePlayerBuffering = 3, // 从网络开始有数据返回 到 可以正常播放
    FWLivePlayerFirstPictureRendered = 4,//仅在首帧渲染开启 首帧已经绘制上之后设置一次
    FWLivePlaying = 5,//停止到启动状态 暂停到播放状态
    FWLivePlayerRebuffering = 6,// 播放过程中缓冲
    FWLivePlayerStopping = 7,// 因各种原因调用stop方法 开始时候都要设置Stopping
    FWLivePlayerStopped = 8,// 异步回调中断
};

@protocol FWLivePlayerDelegate <NSObject>
-(void)playerStatusChanged:(FWLivePlayerStatus)playerStatus;
-(void)playerError:(NSError*)error;
@end

@interface FWPlayer : NSObject

@property(nonatomic,weak)id<FWLivePlayerDelegate> delegate;

-(id)initWithView:(UIView*)view;

-(void)play;
-(void)stop;

-(void)playerUrl:(NSString*)url;
-(void)playerViewFrame:(CGRect)frame;
-(void)playerViewScale:(float)scale;
-(void)mediaCacheTime:(float)time;
-(void)quickRenderedFirstPicture:(BOOL)flag;
-(void)playBackground:(BOOL)flag;
-(void)playerVolume:(float)volume;
-(void)timeout:(float)time;
-(void)reconnectTimes:(int)times;
-(void)stuckMaxDuration:(float)time;
-(void)firstMaxPlayTime:(float)maxFirstPlayTime;

//pause decode and render picture when app enter backgroud
-(void)pauseDecodeAndRender;
-(void)resumeDecodeAndRender;

-(void)mute;
-(void)unmute;

-(float)currentPlayTime;
-(FWLivePlayerStatus)getPlayerStatus;
@end
