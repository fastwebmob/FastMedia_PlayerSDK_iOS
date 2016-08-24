//
//  AppDelegate.m
//  PlayerDemo
//
//  Created by jones on 7/29/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <FWMediaSDK/FWPlayer.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    [Bugly startWithAppId:@"900044598"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:FW_PLAYER_SDK_ENTER_BACKGROUND object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:FW_PLAYER_SDK_ENTER_FOREGROUND object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
