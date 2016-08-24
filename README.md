#简介
快网FastMediaPlayer提供基于智能FastMedia调度系统的高效可靠的传输、转码、分发的一站式直播点播服务平台，目前支持Http＋Flv的流媒体直播。提供播放器SDK，具有低延迟、高安全、高并发、易接入、多终端、控制接口多、统计信息详细等特点;
##亮点介绍
    1 具有低延迟、低卡顿、播放流畅的特点。
    2 平台适应性：android、iOS、PC  
    3 播放场景定制功能  
	  3.1 支持首帧渲染  
      3.2 支持缓存功能
      3.3 后台中断播放  
    4 播放卡顿智能调整功能
      4.1 支持卡顿暂停
      4.2 支持最大卡顿时间设置
      4.3 支持卡顿信息统计功能
    5 网络监控
      5.1 支持超时时间设置
      5.2 支持重连次数设置
      5.3 实时监控网络状态
    6 灵活的播放视图层
      6.1 提供一站式播放控制器快速集成
      6.2 提供灵活的播放界面，可以灵活实现画中画等各种特效
    7 其它特点
      7.1 支持静音，音量百分比调节功能
      7.2 提供大量播放状态统计信息
      7.3 硬解码，降低cpu功耗和发热
##FastMediaPlayer SDK概述
	低延时直播体验，配合快网FastMedia调度系统，可以享受视频加速服务
	灵活自定义的屏幕界面。
	支持iOS8.0以上版本
	支持Http＋flv（封装aac＋h264）格式
	小于2M大小的超轻量级直播sdk；

##FWPlayer API
###Player Status
	typedef NS_ENUM(NSInteger, FWLivePlayerStatus) {
    	FWLivePlayerError = 0,// 播放异常
    	FWLivePlayerReady = 1,// 播放器准备就绪
    	FWLivePlayerConnecting = 2,// 正在与媒体服务器建立连接
    	FWLivePlayerBuffering = 3, // 正在缓冲网络媒体数据
    	FWLivePlayerFirstPictureRendered = 4,//已经完成首帧快速渲染
    	FWLivePlaying = 5,//播放器正在播放
    	FWLivePlayerRebuffering = 6,// 播放过程中缓冲网络媒体数据
    	FWLivePlayerStopping = 7,// 播放器正在停止
    	FWLivePlayerStopped = 8,// 播放器已经停止
	};

###PlayerView API 
	
    /*
		@function   initWithView
		@abstract   Initializes a player with view
		@param      player interface view
    */

    -(id)initWithView:(UIView*)view;
    
###PlayerControl API
| @function                 | @abstract           | @param    |
| ------------------------- |:-------------:| :-----:|
| -(void)play   | Begin to play the current item | -- |
| -(void)stop   | Stop playing |   -- |
| -(void)playWithUrl:(NSString*)url | Set player play address      |   play address|
| -(void)setFrame:(CGRect)frame | Set player screen size  |   player screen size |
| -(void)setViewScale:(float)scale | Set player screen zoom scale | zoom scale,0-1.0 |
| -(void)setCacheTime:(float)time | Set the media data cache time | cache time(ms) |
| -(void)enableQuickRenderedFirstPicture:(BOOL)flag | Set the first frame to quickly render |flag(Bool)|
| -(void)enablePlayingBackground:(BOOL)flag |Set the function to play in the background | flag(Bool) |
| -(void)setVolume:(float)volume | Set player volume |volume(0-1.0)|
| -(void)setTimeout:(float)time| Set timeout with server connection| time(ms) |
| -(void)setReconnectingTimes:(int)times | Set the number of times to reconnect to the server|times|
| -(void)setMaxStuckDuration:(int)times | If stuck total time than the maximum stuck time, the player will be re loaded play address | time(ms) |
|-(void)setMaxFirstPlayTime:(float)maxFirstPlayTime | If the player does not play in the first maximum time, then the player will reload the play address in any case. | times |
|-(void)pauseDecodeAndRender | Pause decode and render picture when app enter backgroud| -- |
| -(void)resumeDecodeAndRender| Resume decode and render picture when app will enter foreground | -- |
| -(void)mute | Set player mute |  -- |
| -(void)unmute | Set player mute | -- |
| -(float)currentPlayTime | Get the current play time |--|
| -(FWLivePlayerStatus)getPlayerStatus|Get the current play status|--|


# FWPlayerViewController API

###PlayerViewController API
	-(void)playWithUrl:(NSString*)url;
	-(void)setViewScale:(float)scale;
	-(void)setMediaCacheTime:(float)time;
	-(void)enableQuickRenderFirstPicture:(BOOL)flag;
	-(void)enablePlayingBackground:(BOOL)flag;
	-(void)setVolume:(float)volume;
	-(void)setTimeout:(float)time;
	-(void)setReconnectingTimes:(int)times;
	-(void)setMaxStuckDuration:(float)time;
	-(void)setStatisticsButtonHidden:(BOOL)hidden;
	-(void)setMaxFirstPlayTime:(float)maxFirstPlayTime;
	
	-(void)mute;
	-(void)unmute;

## Notification(common)

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mediaInfo:)
     name:@"FWFLVPLAYERSDKMEDIAINFO_FASTWEB" object:nil];
## Player Delegate API(common)
| @function                 | @abstract                          | @param    |
| ------------------------- |:----------------------------------:| :--------:|
| -(void)playerStatusChanged:(FWLivePlayerStatus)playerStatus   |If the player's state changes, then the method will be callback | playerStatus(NS_ENUM(NSInteger, FWLivePlayerStatus)) |
| -(void)playerError:(NSError*)error | If the player has an exception,then the method will be callback|error(see error code for detail)|


