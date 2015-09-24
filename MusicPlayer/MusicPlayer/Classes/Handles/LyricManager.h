//
//  LyricManager.h
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/11.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyricModel.h"

@interface LyricManager : NSObject
/**
 *  创建单例
 */
+(instancetype)sharedInstance;

/**
 *  设置歌词格式
 */
-(void)setLyricFormat:(NSString *)lyric;

/**
 *  获取歌词
 */
-(NSString *)getAllLyricWithIndex:(NSInteger)index;

/**
 *  根据时间返回下标 实现歌词滚动功能
 */
-(NSInteger)getIndexWithTime:(CGFloat)time;

/**
 *  根据下标获得时间 实现拖动歌词从指定位置播放
 */
-(CGFloat)getTimeWithIndex:(NSInteger)index;

/**
 *  获取数组中元素个数 即cell上需要显示多少行歌词
 */
-(NSInteger)countOfAllLyricArray;


@end
