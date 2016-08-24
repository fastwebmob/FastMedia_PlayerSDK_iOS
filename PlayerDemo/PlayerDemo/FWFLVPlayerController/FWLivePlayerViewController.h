//
//  FWLivePlayerViewController.h
//  PlayerDemo
//
//  Created by jones on 7/4/16.
//  Copyright © 2016 www.fastweb.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FWMediaSDK/FWPlayer.h>
@interface FWLivePlayerViewController : UIViewController
@property(nonatomic,strong)NSString *loadUrl;
@property(nonatomic,strong)FWPlayer *player;
@end
