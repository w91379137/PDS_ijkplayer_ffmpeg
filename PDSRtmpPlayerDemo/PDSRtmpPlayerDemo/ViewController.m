//
//  ViewController.m
//  PDSRtmpPlayerDemo
//
//  Created by w91379137 on 2017/9/27.
//  Copyright © 2017年 w91379137. All rights reserved.
//

#import "ViewController.h"
#import "../ijkplayer-ios/ios/IJKMediaPlayer/IJKMediaFramework/IJKMediaFramework.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@property(nonatomic, strong) IJKFFMoviePlayerController *player;
@property(nonatomic, strong) IBOutlet UIView *baseView;
@property(nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame: self.view.frame configuration:webViewConfig];
    
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadVideo];
    [self loadHtml];
}

- (void)loadVideo {
    //NSString *urlPath = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
    
    //http://blog.csdn.net/chinabinlang/article/details/45092297
    NSString *urlPath = @"rtmp://live.hkstv.hk.lxdns.com/live/hks"; //香港卫视
    //NSString *urlPath = @"rtmp://v1.one-tv.com/live/mpegts.stream"; //亚太第一卫视
    
    NSURL *url = [NSURL URLWithString:urlPath];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    self.player.view.frame = self.baseView.bounds;
    [self.baseView addSubview:self.player.view];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player prepareToPlay];
        [self.player play];
    });
}

-(void)loadHtml {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension: @"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

@end
