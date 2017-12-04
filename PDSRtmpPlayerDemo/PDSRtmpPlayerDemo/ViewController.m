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

@property(nonatomic, strong) IJKFFMoviePlayerController *playerVC;
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
    [self rtmpPlay:urlPath];
    
    
    //測試影片播放時 可以 正常縮放
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat
                     animations:^{
                         self.baseView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                     }
                     completion:nil];
    
    //要測試換網址 stop 重新 開始會怎樣
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.playerVC stop];
        [self.playerVC.view removeFromSuperview];
        
        NSString *urlPath = @"rtmp://v1.one-tv.com/live/mpegts.stream";
        [self rtmpPlay:urlPath];
    });
}
    
- (void)rtmpPlay:(NSString *)urlPath {
    NSURL *url = [NSURL URLWithString:urlPath];
    self.playerVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    self.playerVC.view.frame = self.baseView.bounds;
    [self.baseView addSubview:self.playerVC.view];
    self.playerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerVC prepareToPlay];
        [self.playerVC play];
    });
}

- (void)loadHtml {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension: @"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

@end
