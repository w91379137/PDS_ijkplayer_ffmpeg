//
//  ViewController.m
//  PDSRtmpPlayerDemo
//
//  Created by w91379137 on 2017/9/27.
//  Copyright © 2017年 w91379137. All rights reserved.
//

#import "ViewController.h"
#import "../ijkplayer-ios/ios/IJKMediaPlayer/IJKMediaFramework/IJKMediaFramework.h"
//#import "../ijkplayer-ios/ios/IJKMediaPlayer/IJKMediaPlayer/IJKFFMoviePlayerController.h"

@interface ViewController ()

@property(nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlPath = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    NSURL *url = [NSURL URLWithString:urlPath];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    self.player.view.frame = self.view.bounds;
    [self.view addSubview:self.player.view];
    
    [self.player prepareToPlay];
    [self.player play];
}

@end
