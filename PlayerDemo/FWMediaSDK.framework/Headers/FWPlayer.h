//
//  FWPlayer.h
//  FastMediaPlayerSDK
//
//  Created by jones on 5/17/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//
#import <UIKit/UIKit.h>
#define FW_PLAYER_SDK_ENTER_BACKGROUND @"FW_PLAYER_SDK_ENTER_BACKGROUND"
#define FW_PLAYER_SDK_ENTER_FOREGROUND @"FW_PLAYER_SDK_ENTER_FOREGROUND"
#define FW_PLAYER_SDK_MEDIA_INFO @"FW_PLAYER_SDK_MEDIA_INFO"

typedef NS_ENUM(NSInteger, FWLivePlayerStatus) {
    FWLivePlayerError = 0,// 播放异常
    FWLivePlayerReady = 1,// 播放器已经准备就绪
    FWLivePlayerConnecting = 2,// 正在和媒体服务器建立连接
    FWLivePlayerBuffering = 3, // 正在缓冲网络媒体数据
    FWLivePlayerFirstPictureRendered = 4,//已经完成首帧快速渲染
    FWLivePlaying = 5,//播放器正在播放
    FWLivePlayerRebuffering = 6,// 播放过程中缓冲网络媒体数据
    FWLivePlayerStopping = 7,// 播放器正在停止
    FWLivePlayerStopped = 8,// 播放器已经停止
};

@protocol FWLivePlayerDelegate <NSObject>
/*
 @function   playerStatusChanged
 @abstract   If the player's state changes, then the method will be callback
 @param      playerStatus(NS_ENUM(NSInteger, FWLivePlayerStatus))
 */
-(void)playerStatusChanged:(FWLivePlayerStatus)playerStatus;
/*
 @function   playerError
 @abstract   If the player has an exception,then the method will be callback
 @param      error(see error code for detail)
 */
-(void)playerError:(NSError*)error;
@end

@interface FWPlayer : NSObject

@property(nonatomic,weak)id<FWLivePlayerDelegate> delegate;
/*
@function   initWithView
@abstract   Initializes a player with view
@param      player interface view
 */
-(id)initWithView:(UIView*)view;
/*
 @function   play
 @abstract   Begin to play the current item
 */
-(void)play;
/*
 @function   stop
 @abstract   Stop playing
 */
-(void)stop;
/*
 @function   playWithUrl
 @abstract   Set player play address
 @param      play address
 */
-(void)playWithUrl:(NSString*)url;
/*
 @function   setFrame
 @abstract   Set player screen size
 @param      player screen size
 */
-(void)setFrame:(CGRect)frame;
/*
 @function   setViewScale
 @abstract   Set player screen zoom scale
 @param      zoom scale,0-1.0
 */
-(void)setViewScale:(float)scale;
/*
 @function   setCacheTime
 @abstract   Set the media data cache time
 @param      cache time(ms)
 */
-(void)setCacheTime:(float)time;
/*
 @function   enableQuickRenderedFirstPicture
 @abstract   Set the first frame to quickly render
 @param      flag(Bool)
 */
-(void)enableQuickRenderedFirstPicture:(BOOL)flag;
/*
 @function   enablePlayingBackground
 @abstract   Set the function to play in the background
 @param      flag(Bool)
 */
-(void)enablePlayingBackground:(BOOL)flag;
/*
 @function   setVolume
 @abstract   Set player volume
 @param      volume(0-1.0)
 */
-(void)setVolume:(float)volume;
/*
 @function   setTimeout
 @abstract   Set timeout with server connection
 @param      time(ms)
 */
-(void)setTimeout:(float)time;
/*
 @function   setReconnectingTimes
 @abstract   Set the number of times to reconnect to the server
 @param      times
 */
-(void)setReconnectingTimes:(int)times;
/*
 @function   setMaxStuckDuration
 @abstract   If stuck total time than the maximum stuck time, the player will be re loaded play address
 @param      time(ms)
 */
-(void)setMaxStuckDuration:(float)time;
/*
 @function   setMaxFirstPlayTime
 @abstract   If the player does not play in the first maximum time, then the player will reload the play address in any case.
 @param      times
 */
-(void)setMaxFirstPlayTime:(float)maxFirstPlayTime;
/*
 @function   pauseDecodeAndRender
 @abstract   Pause decode and render picture when app enter backgroud
 */
-(void)pauseDecodeAndRender;
/*
 @function   resumeDecodeAndRender
 @abstract   Resume decode and render picture when app will enter foreground
 */
-(void)resumeDecodeAndRender;
/*
 @function   setFirstMaxPlayTime
 @abstract   Set player mute
 */
-(void)mute;
/*
 @function   setFirstMaxPlayTime
 @abstract   Set player unmute
 */
-(void)unmute;
/*
 @function   currentPlayTime
 @abstract   Get the current play time
 */
-(float)currentPlayTime;
/*
 @function   getPlayerStatus
 @abstract   Get the current play status
 */
-(FWLivePlayerStatus)getPlayerStatus;
@end
