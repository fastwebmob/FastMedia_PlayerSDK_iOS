//
//  FWPlayerInfo.h
//  PlayerSDK
//
//  Created by fastweb on 8/31/16.
//  Copyright © 2016 jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWPlayerInfo : NSObject
@property(nonatomic,assign)long duration;
@property(nonatomic,assign)int flvAudioLoaded;
@property(nonatomic,assign)int flvVideoLoaded;
@property(nonatomic,assign)int flvRemainedAAC;
@property(nonatomic,assign)int flvRemainedH264;
@property(nonatomic,assign)int naluLoaded;
@property(nonatomic,assign)int naluInvalid;
@property(nonatomic,assign)int naluUsed;
@property(nonatomic,assign)int aacFramesLoaded;
@property(nonatomic,assign)int aacFramesinvalid;
@property(nonatomic,assign)int aacFramesUsed;
@property(nonatomic,assign)int picturesDropped;
@property(nonatomic,assign)int picturesRemained;
@property(nonatomic,assign)int picturesInvalid;
@property(nonatomic,assign)int picturesAll;
@property(nonatomic,assign)float networkAVGRateforMedia;
@property(nonatomic,assign)float networkAVGRateforAudio;
@property(nonatomic,assign)float networkAVGRateforVideo;
@property(nonatomic,strong)NSMutableArray *realtimeRate;
@property(nonatomic,assign)long firstTCPPacketStmp;
@property(nonatomic,assign)long firstAudioPacketStmp;
@property(nonatomic,assign)long firstVideoPacketStmp;
@property(nonatomic,assign)long firstPictureTimestamp;
@property(nonatomic,assign)float flvFps;
@property(nonatomic,strong)NSString *networkType;
@property(nonatomic,assign)float stuckPercent;
@property(nonatomic,assign)float realtimeFlvFPS;
@property(nonatomic,assign)int reconnectingRemainedTimes;
@property(nonatomic,strong)NSString *playerStatus;
@property(nonatomic,assign)float connectedFailedPercent;
@property(nonatomic,assign)float stuckTime;
@property(nonatomic,strong)NSString *systemOS;
@property(nonatomic,strong)NSString *phonemodel;
@property(nonatomic,assign)int stucktimes;
@property(nonatomic,assign)float stuckDuration;
@property(nonatomic,assign)float cacheTime;

@end
