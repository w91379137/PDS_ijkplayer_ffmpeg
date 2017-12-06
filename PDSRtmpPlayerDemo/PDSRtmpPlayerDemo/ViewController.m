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
@property(nonatomic, strong) IBOutlet UIButton *flowControlButton;

@property(nonatomic, strong) NSArray *videoURLArray;
@property(nonatomic) int videoIndex;

@property(nonatomic) int status;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //http://blog.csdn.net/chinabinlang/article/details/45092297
    self.videoURLArray = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",
                           @"rtmp://v1.one-tv.com/live/mpegts.stream"];
}
    
- (void)rtmpPlay:(NSString *)urlPath {
    NSURL *url = [NSURL URLWithString:urlPath];
    self.playerVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    self.playerVC.view.frame = self.baseView.bounds;
    [self.baseView addSubview:self.playerVC.view];
    self.playerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
    
    [self.playerVC prepareToPlay];
    [self.playerVC play];
}

- (IBAction)tapButton:(UIButton *)sender {
    
    NSString *title = @"";
    switch (self.status) {
        case 0: {
            title = @"載入網頁";
            
            WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
            self.webView = [[WKWebView alloc] initWithFrame: self.view.frame configuration:webViewConfig];
            
            self.webView.opaque = NO;
            self.webView.backgroundColor = [UIColor clearColor];
            self.webView.scrollView.backgroundColor = [UIColor clearColor];
            
            [self.view insertSubview:self.webView belowSubview:self.flowControlButton];
            self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension: @"html"];
            NSURLRequest *request = [NSURLRequest requestWithURL: url];
            [self.webView loadRequest: request];
        }
            break;
        case 1: {
            title = @"is enable player";
        }
            break;
        case 2: {
            title = @"get video URL";
        }
            break;
        case 3: {
            title = @"player frame";
            //測試影片播放時 可以 正常縮放
            //UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.baseView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                             }
                             completion:nil];
        }
            break;
        case 4: {
            title = @"play";
            [self.playerVC stop];
            [self.playerVC.view removeFromSuperview];
            [self rtmpPlay:self.videoURLArray[self.videoIndex]];
        }
            break;
        case 5: {
            title = @"stop";
            [self.playerVC pause];
        }
            break;
        case 6: {
            title = @"player orientation";
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.baseView.transform = CGAffineTransformMakeScale(1, 1);
                             }
                             completion:nil];
        }
            break;
        case 7: {
            title = @"event call back";
        }
            break;
            
        default:
            title = @"重新";
            [self.webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            self.videoIndex += 1;
            self.videoIndex %= self.videoURLArray.count;
            self.status = -1;
            break;
    }
    
    [self.flowControlButton setTitle:title forState:UIControlStateNormal];
    self.status += 1;
    //NSLog(@"%d", self.status);
}

@end

/*
 WebPlayerProtocol
 1. is enable player
 2. get video URL
 3. player frame
 4. play
 5. stop
 6. player orientation
 7. event call back
 */
