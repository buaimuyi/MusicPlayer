//
//  MusicPlayerHandle.h
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/10.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusicPlayerDelegate <NSObject>
/**
 *  播放时执行此方法
 *
 *  @param progress 播放时间(进度)
 */
-(void)playWithProgress:(CGFloat)progress;

/**
 *  播放结束时执行
 */
-(void)playDidToEnd;

@end

@interface MusicPlayerHandle : NSObject

@property (nonatomic ,assign) id<MusicPlayerDelegate> delegate;

/**
 *  创建单例
 */
+(instancetype)sharedInstance;

/**
 *  根据URL设置音乐播放器
 *
 *  @param url 歌曲地址
 */
-(void)setAVPlayerWithUrl:(NSString *)url;

/**
 *  播放歌曲
 */
-(void)playMusic;

/**
 *  暂停播放
 */
-(void)pauseMusic;

/**
 *  从制定时间开始播放
 */
-(void)seekTimeToPlay:(CGFloat)time;

/**
 *  播放状态
 */
-(BOOL)playingOrPause;

/**
 *  音量调节
 */
-(void)changeVolumeWithValue:(UISlider *)sender;
@end
