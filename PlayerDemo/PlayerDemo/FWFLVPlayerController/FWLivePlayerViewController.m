//
//  FWLivePlayerViewController.h
//  PlayerDemo
//
//  Created by jones on 7/4/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//

#import "FWLivePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

#define FW_MAIN_SCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define FW_MAIN_SCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height

@interface FWLivePlayerViewController ()<UITableViewDataSource,UITableViewDelegate,FWLivePlayerDelegate>{
    
    UIView *layerSizeView;
    BOOL isLandscape;
    UITableView *mediaInfoTableView;
    NSMutableArray *mediaInfoArray;
    NSMutableArray *metaInfoArray;
    NSTimer *timer;
    UIView *playerView;
    CGRect viewRect;
    UIActivityIndicatorView *loadIndictatorView;
}
@property (weak, nonatomic) IBOutlet UIView *playerBottomView;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UIButton *mediaInfo;
@property (weak, nonatomic) IBOutlet UIButton *bt_fullScreen;
@property (weak, nonatomic) IBOutlet UIButton *bt_player;


- (IBAction)play:(id)sender;
- (IBAction)playLandscapeLeft:(id)sender;

@end

@implementation FWLivePlayerViewController

-(id)init{
    self = [super init];
    if (self) {
        CGRect playerViewRect = CGRectMake(0, 0, FW_MAIN_SCREEN_WIDTH, FW_MAIN_SCREEN_HEIGHT);
        playerView = [[UIView alloc]initWithFrame:playerViewRect];
        _player = [[FWPlayer alloc]initWithView:playerView];
    }
    return self;
}

-(BOOL)prefersStatusBarHidden{
    return isLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_player playWithUrl:_loadUrl];
    [_player setViewScale:1.0f];
    isLandscape = false;
    
    self.navigationController.navigationBarHidden = true;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    self.view.backgroundColor = [UIColor blackColor];
    [_mediaInfo setTintColor:[UIColor whiteColor]];
    _player.delegate = self;
    [self.view addSubview:playerView];
    [self.view sendSubviewToBack:playerView];
    
    [self play:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlayTime) userInfo:nil repeats:true];
    [timer fire];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMediaInfo:)
                                                name:FW_PLAYER_SDK_MEDIA_INFO object:nil];
    
    loadIndictatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadIndictatorView.frame = CGRectMake((FW_MAIN_SCREEN_WIDTH-100)/2, (FW_MAIN_SCREEN_HEIGHT-100)/2, 100, 100);
    loadIndictatorView.hidesWhenStopped = true;
    [self.view addSubview:loadIndictatorView];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:false];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (IBAction)play:(id)sender {
    if ([_player getPlayerStatus] != FWLivePlayerError) {
        //  只有当Ready状态 或 已经停止状态才能继续播放。只有播放启动之后才能进入connecting后续状态
        if ([_player getPlayerStatus] == FWLivePlayerReady || [_player getPlayerStatus] == FWLivePlayerStopped) {
            [_player play];
            [_bt_player setImage:[UIImage imageNamed:@"pause_nor"] forState:UIControlStateNormal];
            //  只要不是Stopping并且不是stopped状态都可以停止
        }else if([_player getPlayerStatus]   != FWLivePlayerStopping && [_player getPlayerStatus]  != FWLivePlayerStopped){
            [_player stop];
        }
    }
}

- (IBAction)playLandscapeLeft:(id)sender {
    isLandscape = !isLandscape;
    if (isLandscape == true) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
            [self setNeedsStatusBarAppearanceUpdate];
            [[UIApplication sharedApplication]setStatusBarHidden:true];
            
            [self refushUIFrame];
            loadIndictatorView.frame = CGRectMake((FW_MAIN_SCREEN_HEIGHT-100)/2,(FW_MAIN_SCREEN_WIDTH-100)/2,  100, 100);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            [self setNeedsStatusBarAppearanceUpdate];
            [[UIApplication sharedApplication]setStatusBarHidden:false];
            [self refushUIFrame];
            loadIndictatorView.frame = CGRectMake((FW_MAIN_SCREEN_WIDTH-100)/2,(FW_MAIN_SCREEN_HEIGHT-100)/2,  100, 100);
        }];
    }
}

- (IBAction)close:(id)sender {
    if ([_player getPlayerStatus] != FWLivePlayerError) {
        //  直接退出
        if ([_player getPlayerStatus] == FWLivePlayerReady || [_player getPlayerStatus] == FWLivePlayerStopped) {
            [self.navigationController popToRootViewControllerAnimated:true];
            //  只要不是Stopping并且不是stopped状态都可以停止
        }else if([_player getPlayerStatus]   != FWLivePlayerStopping && [_player getPlayerStatus]  != FWLivePlayerStopped){
            [_player stop];
            [self.navigationController popToRootViewControllerAnimated:true];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:true];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
        _playerBottomView.hidden = !_playerBottomView.hidden;
    }];
}
- (IBAction)changeLayerSize:(id)sender {
    if (layerSizeView == nil) {
        CGFloat x = [UIScreen mainScreen].bounds.size.width-150;
        CGFloat y = [UIScreen mainScreen].bounds.size.height-80;
        if (isLandscape == true){
            x = [UIScreen mainScreen].bounds.size.height-150;
            y = [UIScreen mainScreen].bounds.size.width-80;
        }
        CGFloat w = 150;
        CGFloat h = 40;
        layerSizeView = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [self.view addSubview:layerSizeView];
        
        NSArray *bt_titleArray = @[@"100%",@"75%",@"50%"];
        for (int i = 0; i<3; i++) {
            UIButton *bt_scale = [[UIButton alloc]initWithFrame:CGRectMake(i*w/3, 0, w/3, h)];
            NSString *bt_titleStr = [bt_titleArray objectAtIndex:i];
            [bt_scale setTitle:bt_titleStr forState:UIControlStateNormal];
            bt_scale.tag = 200100+i;
            [bt_scale setTitleColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5] forState:UIControlStateNormal];
            [bt_scale addTarget:self action:@selector(playerViewScaleAction:) forControlEvents:UIControlEventTouchUpInside];
            [layerSizeView addSubview:bt_scale];
        }
        
    }else{
        [layerSizeView removeFromSuperview];
        layerSizeView = nil;
    }
}
-(void)playerViewScaleAction:(UIButton*)bt{
    float scaleNum = 1.0;
    if (bt.tag == 200100) {
        scaleNum = 1.0;
    }else if (bt.tag == 200101){
        scaleNum = 0.7;
    }else if (bt.tag == 200102){
        scaleNum = 0.5;
    }
    CGFloat w = playerView.bounds.size.width*scaleNum;
    CGFloat h = playerView.bounds.size.height*scaleNum;
    CGFloat x = playerView.bounds.origin.x+(playerView.bounds.size.width*(1-scaleNum))/2;
    CGFloat y = playerView.bounds.origin.y+(playerView.bounds.size.height*(1-scaleNum))/2;
    [_player setFrame:CGRectMake(x, y, w, h)];
}
#pragma mark -- Media Info
- (IBAction)mediaInfoAction:(id)sender {
    if (mediaInfoTableView == nil) {
        mediaInfoTableView = [[UITableView alloc]init];
        
        mediaInfoTableView.delegate = self;
        mediaInfoTableView.dataSource = self;
        if (isLandscape == true){
            mediaInfoTableView.frame = CGRectMake(0,0, 550, [UIScreen mainScreen].bounds.size.width-40);
        }else{
            mediaInfoTableView.frame = CGRectMake(0,20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
        }
        
        
        mediaInfoTableView.backgroundColor = [UIColor blackColor];
        mediaInfoTableView.alpha = 0.8;
        mediaInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:mediaInfoTableView];
    }else{
        [mediaInfoTableView removeFromSuperview];
        mediaInfoTableView = nil;
    }
}
#pragma mark - Tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 18;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mediaInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"www.fastweb.com.flvplayer.mediainfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor blackColor];
    NSString *mediaInfoItem = [mediaInfoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = mediaInfoItem;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:10.0];
    cell.textLabel.numberOfLines = 0;
    cell.userInteractionEnabled = false;
    return cell;
}
-(void)showMediaInfo:(NSNotification*)notification{
    NSMutableArray *mediaInfoNotif = notification.object;
    metaInfoArray = mediaInfoNotif;
}
-(void)updatePlayTime{
    int playTime = [_player currentPlayTime];
    NSString *playTimeFormat;
    int time_h = playTime/3600;
    int time_m = (playTime%3600)/60;
    int time_s = (playTime%3600)%60;
    NSString *time_h_str;
    NSString *time_m_str;
    NSString *time_s_str;
    if (time_h < 10) {
        time_h_str = [NSString stringWithFormat:@"0%d",time_h];
    }else{
        time_h_str = [NSString stringWithFormat:@"%d",time_h];
    }
    
    if (time_m < 10) {
        time_m_str = [NSString stringWithFormat:@"0%d",time_m];
    }else{
        time_m_str = [NSString stringWithFormat:@"%d",time_m];
    }
    
    if (time_s < 10) {
        time_s_str = [NSString stringWithFormat:@"0%d",time_s];
    }else{
        time_s_str = [NSString stringWithFormat:@"%d",time_s];
    }
    
    if (playTime>3600) {
        playTimeFormat = [NSString stringWithFormat:@"%@:%@:%@",time_h_str,time_m_str,time_s_str];
    }else {
        playTimeFormat = [NSString stringWithFormat:@"%@:%@",time_m_str,time_s_str];
    }
    self.currentTime.font = [UIFont systemFontOfSize:10.0];
    self.currentTime.text = playTimeFormat;
    [self preparePlayerInfoDataforTB];
}
-(void)preparePlayerInfoDataforTB{
    if (mediaInfoTableView != nil) {
        
        
        FWPlayerInfo *playerInfo = [self.player getPlayerInfo];
        
        NSString *difTime = [NSString stringWithFormat:@"Duration(current - begin)(ms):%ld",playerInfo.duration];
        
        NSString *loadAudioFlvTag = [NSString stringWithFormat:@"Flv Loaded: audio=%d video=%d",playerInfo.flvAudioLoaded,playerInfo.flvVideoLoaded];
        
        NSString *loadaach264 = [NSString stringWithFormat:@"Flv remained: aac=%d h264=%d",playerInfo.flvRemainedAAC,playerInfo.flvRemainedH264];
        
        NSString *h264Nal = [NSString stringWithFormat:@"NALUs: load=%d invalid=%d used=%d",playerInfo.naluLoaded,playerInfo.naluInvalid,playerInfo.naluUsed];
        
        NSString *aacFrame = [NSString stringWithFormat:@"AAC Frames: load=%d invalid=%d used=%d",playerInfo.aacFramesLoaded,playerInfo.aacFramesinvalid,playerInfo.aacFramesUsed];
        
        NSString *imageH264 = [NSString stringWithFormat:@"Pictures: dropped=%d remained=%d invalid=%d all=%d",playerInfo.picturesDropped,playerInfo.picturesRemained,playerInfo.picturesInvalid,playerInfo.picturesAll];
        
        NSString *dataRate = [NSString stringWithFormat:@"Network AVG Rate(KB/s): media=%.2f audio=%.2f video=%.2f",playerInfo.networkAVGRateforMedia,playerInfo.networkAVGRateforAudio,playerInfo.networkAVGRateforVideo];
        
        NSMutableString *realTimeRate = [NSMutableString stringWithString:@"Realtime Rate(KB/s):0"];
        NSMutableArray *realTimeNetWorkRateArray = playerInfo.realtimeRate;
        if (realTimeNetWorkRateArray.count != 0) {
            realTimeRate = [NSMutableString stringWithString:@"Realtime Rate(KB):"];
            for (NSNumber *value in realTimeNetWorkRateArray) {
                [realTimeRate appendString:[NSString stringWithFormat:@"%.0f", value.intValue/1024.f]];
                [realTimeRate appendString:@"|"];
            }
        }
        
        NSString *firstTcpPacketTimestmp = [NSString stringWithFormat:@"First TCP packet(ms): %ld", playerInfo.firstTCPPacketStmp];
        
        NSString *firstFlvTimestamp = [NSString stringWithFormat:@"First FLV timestamp(ms): audio packet=%ld video packet=%ld",playerInfo.firstAudioPacketStmp,playerInfo.firstVideoPacketStmp];
        NSString *firstPictureTimestmp = [NSString stringWithFormat:@"First picture timestamp(ms): %ld",playerInfo.firstPictureTimestamp];
        
        NSString *fps = [NSString stringWithFormat:@"FPS: %.2f",playerInfo.flvFps];
        
        NSString *networkType = [NSString stringWithFormat:@"Network Type: %@",playerInfo.networkType];
        
        NSString *stuckPercentage = [NSString stringWithFormat:@"Stuck Percent: %.2f",playerInfo.stuckPercent];
        
        
        NSString *fps_RealTime_Str = [NSString stringWithFormat:@"Realtime FPS: %.2f",playerInfo.realtimeFlvFPS];
        
        NSString *clientReconnectTimes = [NSString stringWithFormat:@"Reconnecting Remained Times:%d",playerInfo.reconnectingRemainedTimes];
        
        NSString *playerStatusStr = [NSString stringWithFormat:@"Player Status: %@",playerInfo.playerStatus];
        
        NSString *connectFailedPercentStr = [NSString stringWithFormat:@"Connected Failed Percent: %.2f",playerInfo.connectedFailedPercent];
        
        NSString *currentStuckTime = [NSString stringWithFormat:@"Stuck Time: %.2f",playerInfo.stuckTime];
        
        NSString *deviceSystemOS = [NSString stringWithFormat:@"System OS: %@",playerInfo.systemOS];
        NSString *deviceModel = [NSString stringWithFormat:@"Phone model: %@",playerInfo.phonemodel];
        NSString *mdiscontinueCount = [NSString stringWithFormat:@"Stuck times: %d",playerInfo.stucktimes];
        NSString *mdiscontinueTime = [NSString stringWithFormat:@"Stuck duration(s): %.2f",playerInfo.stuckDuration];
        
        NSString *cacheTime = [NSString stringWithFormat:@"Cache Time(s):%.2f",playerInfo.cacheTime];
        
        mediaInfoArray = [[NSMutableArray alloc]init];
        [mediaInfoArray addObject:difTime];
        [mediaInfoArray addObject:loadAudioFlvTag];
        [mediaInfoArray addObject:loadaach264];
        [mediaInfoArray addObject:h264Nal];
        [mediaInfoArray addObject:aacFrame];
        [mediaInfoArray addObject:imageH264];
        [mediaInfoArray addObject:dataRate];
        [mediaInfoArray addObject:realTimeRate];
        [mediaInfoArray addObject:firstTcpPacketTimestmp];
        [mediaInfoArray addObject:firstFlvTimestamp];
        [mediaInfoArray addObject:firstPictureTimestmp];
        [mediaInfoArray addObject:fps];
        [mediaInfoArray addObject:deviceSystemOS];
        [mediaInfoArray addObject:deviceModel];
        [mediaInfoArray addObject:networkType];
        [mediaInfoArray addObject:currentStuckTime];
        [mediaInfoArray addObject:clientReconnectTimes];
        [mediaInfoArray addObject:playerStatusStr];
        [mediaInfoArray addObject:connectFailedPercentStr];
        
        [mediaInfoArray addObject:mdiscontinueCount];
        [mediaInfoArray addObject:mdiscontinueTime];
        [mediaInfoArray addObject:cacheTime];
        [mediaInfoArray addObject:stuckPercentage];
        [mediaInfoArray addObject:fps_RealTime_Str];
        
        for (NSString *item in metaInfoArray) {
            [mediaInfoArray addObject:item];
        }
        
        [mediaInfoTableView reloadData];
    }
}

- (void)dealloc {
    [timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- Refush UI Frame
-(void)refushUIFrame{
    
    CGFloat x = [UIScreen mainScreen].bounds.size.width-150;
    CGFloat y = [UIScreen mainScreen].bounds.size.height-80;
    CGFloat w = 150;
    CGFloat h = 40;
    
    if (isLandscape == true){
        playerView.frame = CGRectMake(0, 0,FW_MAIN_SCREEN_HEIGHT,FW_MAIN_SCREEN_WIDTH);
        [_player setFrame:playerView.bounds];
        mediaInfoTableView.frame = CGRectMake(0,0, 350, [UIScreen mainScreen].bounds.size.width-40);
        x = [UIScreen mainScreen].bounds.size.height-150;
        y = [UIScreen mainScreen].bounds.size.width-80;
        layerSizeView.frame = CGRectMake(x, y, w, h);
    }else{
        playerView.frame = CGRectMake(0,0,FW_MAIN_SCREEN_WIDTH, FW_MAIN_SCREEN_HEIGHT);
        [_player setFrame:playerView.bounds];
        mediaInfoTableView.frame = CGRectMake(0,20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60);
        layerSizeView.frame = CGRectMake(x, y, w, h);
    }
}
#pragma mark --Player Delegate
-(void)playerStatusChanged:(FWLivePlayerStatus)playerStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (playerStatus < FWLivePlaying || playerStatus == FWLivePlayerRebuffering) {
            if (![loadIndictatorView isAnimating]) {
                [loadIndictatorView startAnimating];
            }
        }else{
            [loadIndictatorView stopAnimating];
        }
        if(playerStatus == FWLivePlayerStopped){
            [_bt_player setImage:[UIImage imageNamed:@"play_nor"] forState:UIControlStateNormal];
        }else if(playerStatus == FWLivePlayerConnecting){
            [_bt_player setImage:[UIImage imageNamed:@"pause_nor"] forState:UIControlStateNormal];
        }
        
        
    });
}

-(void)playerError:(NSError*)error{
    NSLog(@"error code:%ld",(long)error.code);
}
@end
