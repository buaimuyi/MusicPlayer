//
//  LyricManager.m
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/11.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import "LyricManager.h"

@interface LyricManager ()

@property (nonatomic, strong) NSMutableArray *allLyricArray;//存放所有的歌词

@end
@implementation LyricManager


#pragma mark - 单例
+(instancetype)sharedInstance{
    
    static LyricManager *lyric;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lyric = [[LyricManager alloc] init];
        
        lyric.allLyricArray = [NSMutableArray array];
    });
    
    return lyric;
}

#pragma mark - 设置歌词格式
-(void)setLyricFormat:(NSString *)lyric{
    
    [self.allLyricArray removeAllObjects];
    
    //拆分歌词
    /**
     *  eg. [00:23.000] xxx \n [04:23.333] xxx \n ...
     */
    NSArray *array = [lyric componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < array.count-1; i++) {
        
        //每行歌词 [00:23.333] xxx
        NSString *lineLyric = array[i];
        
        //根据']'继续拆分
        NSArray *lyricArray = [lineLyric componentsSeparatedByString:@"]"];
        
        //时间
        if ([lyricArray.firstObject length] < 1) {
            
            break;
        }
        NSString *timeStr = [lyricArray.firstObject substringFromIndex:1];
      
        //根据':'继续拆分时间
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        
        //总时长  单位:秒
        CGFloat totalTime = [timeArray.firstObject floatValue] * 60 + [timeArray.lastObject floatValue];
        
        //歌词
        NSString *lyricStr = [lyricArray lastObject];
        
        //初始化歌词模型
        LyricModel *lyricModel = [[LyricModel alloc] init];
        
        //歌词
        lyricModel.lyric = lyricStr;
        
        //时间
        lyricModel.time = totalTime;
        
        //存入数组
        [self.allLyricArray addObject:lyricModel];
    }
}

#pragma mark - 根据下标获取歌词
-(NSString *)getAllLyricWithIndex:(NSInteger)index{
    
    LyricModel *lyricModel = [self.allLyricArray objectAtIndex:index];
    
    return lyricModel.lyric;
}

#pragma mark - 根据时间返回下标
-(NSInteger)getIndexWithTime:(CGFloat)time{
    
    NSInteger index = 0;//注意:文件中每首歌歌词结束的时间和播放时间并不相等,如果不给index一个初始值,会造成越界访问
    
    for (int i = 0; i < _allLyricArray.count - 1; i++) {
        
        LyricModel *model = self.allLyricArray[i];
        
        if (model.time > time) {
            
            index = i - 1 > 0 ? i - 1 : 0;
            break; 
        }
    }
    return index;
}

#pragma mark - 根据下标返回时间
-(CGFloat)getTimeWithIndex:(NSInteger)index{
    
    LyricModel *model = self.allLyricArray[index];
    
    return model.time;
    
}

#pragma mark - 获取数组中元素个数
-(NSInteger)countOfAllLyricArray{
    
    return self.allLyricArray.count;
}

@end
