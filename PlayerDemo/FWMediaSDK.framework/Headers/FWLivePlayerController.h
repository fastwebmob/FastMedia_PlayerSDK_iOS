//
//  FWFLVPlayerController.h
//  FastMediaPlayerSDK

//  Created by jones on 6/3/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWPlayer.h"
@interface FWLivePlayerController : UIViewController

@property(nonatomic,weak)id<FWLivePlayerDelegate> delegate;
/*
 @function   playWithUrl
 @abstract   Set player play address
 @param      play address
 */
-(void)playWithUrl:(NSString*)url;
/*
 @function   setViewScale
 @abstract   Set player screen zoom scale
 @param      zoom scale,0-1.0
 */
-(void)setViewScale:(float)scale;
/*
 @function   setMediaCacheTime
 @abstract   Set the media data cache time
 @param      cache time(ms)
 */
-(void)setMediaCacheTime:(float)time;
/*
 @function   enableQuickRenderedFirstPicture
 @abstract   Set the first frame to quickly render
 @param      flag(Bool)
 */
-(void)enableQuickRenderFirstPicture:(BOOL)flag;
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
 @function   setStatisticsButtonHidden
 @abstract   Hide statistics button
 */
-(void)setStatisticsButtonHidden:(BOOL)hidden;
/*
 @function   setMaxFirstPlayTime
 @abstract   If the player does not play in the first maximum time, then the player will reload the play address in any case.
 @param      times
 */
-(void)setMaxFirstPlayTime:(float)maxFirstPlayTime;
/*
 @function   setFirstMaxPlayTime
 @abstract   Set player unmute
 */
-(void)mute;
/*
 @function   currentPlayTime
 @abstract   Get the current play time
 */
-(void)unmute;

@end
