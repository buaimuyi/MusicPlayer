//
//  MusicModel.h
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/9.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (copy, nonatomic) NSString *name;//歌名
@property (copy, nonatomic) NSString *picUrl;//图片
@property (copy, nonatomic) NSString *singer;//歌手名
@property (copy, nonatomic) NSString *duration;//时长
@property (copy, nonatomic) NSString *mp3Url;//歌曲地址
@property (copy, nonatomic) NSString *lyric;//歌词

@end
