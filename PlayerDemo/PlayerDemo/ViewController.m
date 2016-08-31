//
//  ViewController.m
//  PlayerDemo
//
//  Created by jones on 7/29/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//

#import "ViewController.h"
#import <FWMediaSDK/FWLivePlayerController.h>
#import "FWLivePlayerViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *urlArray;
    NSMutableArray *urlDetailArray;
    FWLivePlayerController *playerViewController;
    FWLivePlayerViewController *playerTestViewController;
    BOOL playerModel;
}
@property (weak, nonatomic) IBOutlet UITableView *urlTableView;
@property (weak, nonatomic) IBOutlet UITextField *scaleView;
@property (weak, nonatomic) IBOutlet UITextField *cacheTime;
@property (weak, nonatomic) IBOutlet UITextField *volume;
@property (weak, nonatomic) IBOutlet UITextField *serverTimeOut;
@property (weak, nonatomic) IBOutlet UITextField *stuckMaxTime;
@property (weak, nonatomic) IBOutlet UITextField *serverReconnect;
@property (weak, nonatomic) IBOutlet UISwitch *holdFirstImage;
@property (weak, nonatomic) IBOutlet UITextField *loadUrl;
@property (weak, nonatomic) IBOutlet UISwitch *mute;
@property (weak, nonatomic) IBOutlet UISwitch *playBackground;
@property (weak, nonatomic) IBOutlet UITextField *firstPlayTime;

- (IBAction)changePlayerModel:(id)sender;
- (IBAction)playWithUrl:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"urlInfoTest.plist" ofType:nil];
    NSArray *urlItemArray = [NSArray arrayWithContentsOfFile:path];
    
    urlArray = [[NSMutableArray alloc]init];
    urlDetailArray = [[NSMutableArray alloc]init];
    
    for (NSArray *urlItem in urlItemArray) {
        [urlArray addObject:[urlItem objectAtIndex:0]];
        [urlDetailArray addObject:[urlItem objectAtIndex:1]];
    }
    
    self.navigationItem.title = @"FastMedia PlayerSDK Demo";
    _urlTableView.delegate = self;
    _urlTableView.dataSource = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = false;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma make -tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize nameSize = [self sizeWithText:[urlArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:8.0] maxSize:CGSizeMake(tableView.frame.size.width, MAXFLOAT)];
    if (nameSize.height+25 < 44) {
        return 44;
    }else
        return nameSize.height+25;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return urlArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strCell = @"www.fastweb.com.fastmedia.urlCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
    }
    cell.textLabel.text = [urlDetailArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = urlArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:8.0];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:127.0 / 255.0 blue:79.0 / 255.0 alpha:1.0];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (playerModel) {
        playerTestViewController = [[FWLivePlayerViewController alloc]init];
        playerTestViewController.loadUrl = urlArray[indexPath.row];
        [self submitSetPropertyAction:playerTestViewController];
        [self.navigationController pushViewController:playerTestViewController animated:true];
    }else{
        playerViewController = [[FWLivePlayerController alloc]init];
        [playerViewController playWithUrl:urlArray[indexPath.row]];
        [self submitSetPropertyAction:playerViewController];
        [self.navigationController pushViewController:playerViewController animated:true];
    }
    
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (void)submitSetPropertyAction:(id)sender {
    
    //  缩放比
    NSString *scaleViewStr = [_scaleView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float scaleView = scaleViewStr.floatValue;
    
    //  cacheTime
    NSString *cacheTimeStr = [_cacheTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float cacheTime = cacheTimeStr.floatValue/1000.0;
    
    //  volume
    NSString *volumeStr = [_volume.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float volume = volumeStr.floatValue;
    
    //  serverTimeOut
    NSString *serverTimeOutStr = [_serverTimeOut.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float serverTimeOut = serverTimeOutStr.floatValue/1000.0;
    
    //  stuckMaxTime
    NSString *stuckMaxTimeStr = [_stuckMaxTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float stuckMaxTime = stuckMaxTimeStr.floatValue/1000.0;
    
    //  serverReconnect
    NSString *serverReconnectStr = [_serverReconnect.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float serverReconnect = serverReconnectStr.floatValue;
    
    //  Hold first image
    BOOL isHold = [_holdFirstImage isOn];
    
    //  mute
    BOOL muteflag = [_mute isOn];
    
    //  play background
    BOOL playBackground = [_playBackground isOn];
    
    //  first play time
    NSString *firstPlayTimeStr = [_firstPlayTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    float firstPlayTime = firstPlayTimeStr.floatValue/1000.0;
    
    [_scaleView resignFirstResponder];
    [_cacheTime resignFirstResponder];
    [_volume resignFirstResponder];
    [_serverTimeOut resignFirstResponder];
    [_stuckMaxTime resignFirstResponder];
    [_serverReconnect resignFirstResponder];
    [_loadUrl resignFirstResponder];
    [_firstPlayTime resignFirstResponder];
    
    if ([sender isMemberOfClass:[FWLivePlayerController class]]) {
        [playerViewController setViewScale:scaleView];
        [playerViewController setMediaCacheTime:cacheTime];
        
        [playerViewController setTimeout:serverTimeOut];
        [playerViewController setMaxStuckDuration:stuckMaxTime];
        [playerViewController setReconnectingTimes:serverReconnect];
        [playerViewController enableQuickRenderFirstPicture:isHold];
        if (muteflag) {
            [playerViewController mute];
        }else{
            [playerViewController setVolume:volume];
        }
        [playerViewController enablePlayingBackground:playBackground];
        [playerViewController setMaxFirstPlayTime:firstPlayTime];
    }else if ([sender isMemberOfClass:[FWLivePlayerViewController class]]){
        FWLivePlayerViewController *livePlayerDemoVC = (FWLivePlayerViewController*)sender;
        [livePlayerDemoVC.player setViewScale:scaleView];
        [livePlayerDemoVC.player setCacheTime:cacheTime];
        [livePlayerDemoVC.player setVolume:volume];
        [livePlayerDemoVC.player setTimeout:serverTimeOut];
        [livePlayerDemoVC.player setMaxStuckDuration:stuckMaxTime];
        [livePlayerDemoVC.player setReconnectingTimes:serverReconnect];
        [livePlayerDemoVC.player enableQuickRenderedFirstPicture:isHold];
        [livePlayerDemoVC.player setMaxFirstPlayTime:firstPlayTime];
        if (muteflag) {
            [livePlayerDemoVC.player mute];
        }else{
            [playerViewController setVolume:volume];
        }
        [livePlayerDemoVC.player enablePlayingBackground:playBackground];
    }else  if (sender == nil) {
        if (playerModel) {
            playerTestViewController = [[FWLivePlayerViewController alloc]init];
            playerTestViewController.loadUrl = [_loadUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.navigationController pushViewController:playerTestViewController animated:true];
        }else{
            playerViewController = [[FWLivePlayerController alloc]init];
            [playerViewController playWithUrl:[_loadUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [self.navigationController pushViewController:playerViewController animated:true];
        }
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_scaleView resignFirstResponder];
    [_cacheTime resignFirstResponder];
    [_volume resignFirstResponder];
    [_serverTimeOut resignFirstResponder];
    [_stuckMaxTime resignFirstResponder];
    [_serverReconnect resignFirstResponder];
    [_loadUrl resignFirstResponder];
    [_firstPlayTime resignFirstResponder];
}
- (IBAction)changePlayerModel:(id)sender {
    UISwitch *mswitch = (UISwitch*)sender;
    playerModel = [mswitch isOn];
}

- (IBAction)playWithUrl:(id)sender {
    NSString *loadUrl = [self.loadUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (playerModel) {
        playerTestViewController = [[FWLivePlayerViewController alloc]init];
        playerTestViewController.loadUrl = loadUrl;
        [self submitSetPropertyAction:playerTestViewController];
        [self.navigationController pushViewController:playerTestViewController animated:true];
    }else{
        playerViewController = [[FWLivePlayerController alloc]init];
        [playerViewController playWithUrl:loadUrl];
        [self submitSetPropertyAction:playerViewController];
        [self.navigationController pushViewController:playerViewController animated:true];
    }
}
@end
