//
//  MusicPlayerHandle.m
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/10.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import "MusicPlayerHandle.h"

@interface MusicPlayerHandle ()
{
    BOOL isPlaying;
}
@property (nonatomic, strong) NSTimer *timer;
@end
//全局变量
static AVPlayer *avPlayer;
@implementation MusicPlayerHandle

-(instancetype)init{
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicEnding) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    return self;
}

#pragma mark - 单例

+(instancetype)sharedInstance{
    
    static MusicPlayerHandle *musicPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        musicPlayer = [[MusicPlayerHandle alloc] init];
        
        avPlayer = [[AVPlayer alloc] init];
        
    });
    
    return musicPlayer;
}

#pragma mark - 创建音乐播放器

-(void)setAVPlayerWithUrl:(NSString *)url{
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    
    [avPlayer replaceCurrentItemWithPlayerItem:item];
    
    //开始播放
    [self playMusic];
}

#pragma mark - 播放状态
-(BOOL)playingOrPause{
    
    if (isPlaying) {
        
        [self pauseMusic];
        
        return NO;
        
    }else{
        
        [self playMusic];
        
        return YES;
    }
}

#pragma mark - 播放歌曲
-(void)playMusic{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(musicPlaying) userInfo:nil repeats:YES];
    
    isPlaying = YES;
    
    [avPlayer play];
    
}

//私有方法
#pragma mark - 播放时执行
-(void)musicPlaying{
    
    CGFloat time = avPlayer.currentTime.value / avPlayer.currentTime.timescale;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playWithProgress:)]) {
        
        [self.delegate playWithProgress:time];
    }
}

#pragma mark - 播放结束时执行
-(void)musicEnding{
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(playDidToEnd)]) {
            
        [self.delegate playDidToEnd];
    }
}

#pragma mark - 暂停
-(void)pauseMusic{
    
    isPlaying = NO;
    
    [avPlayer pause];
    
    //计时器停止工作
    [self.timer invalidate];
    
    self.timer = nil;
}

#pragma mark - 指定播放时间
-(void)seekTimeToPlay:(CGFloat)time{
    
    //先暂停
//    [self pauseMusic];
    //从指定时间开始播放
    [avPlayer seekToTime:CMTimeMakeWithSeconds(time, avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished){
            //开始播放
            [self playMusic];
        }
    }];
}

#pragma mark - 音量调节
-(void)changeVolumeWithValue:(UISlider *)sender{
    
    avPlayer.volume = sender.value;
}

@end
