//
//  MusicManager.h
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/9.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicListHeader.h"

@interface MusicManager : NSObject

/**
 *  单例创建
 */
+ (id)sharedInstance;


/**
 *  解析歌曲数据
 */
- (void)getAllDataWithResult:(void(^)(NSMutableArray *))result;

/**
 *  获取数组元素个数
 */

- (NSInteger)getDataCount;

/**
 *  根据数组下标返回一个model
 */

- (MusicModel *)getMusicModelWithIndex:(NSInteger)index;


@end
