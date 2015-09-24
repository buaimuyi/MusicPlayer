//
//  MusicManager.m
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/9.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import "MusicManager.h"

@interface MusicManager ()

@property (nonatomic, strong) NSMutableArray *allDataArray;

@end

@implementation MusicManager

#pragma mark - 单例
+(id)sharedInstance{
    
    static MusicManager *musicManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        musicManager = [[MusicManager alloc] init];
        
    });
    
    return musicManager;
}

#pragma mark - 数据请求

-(void)getAllDataWithResult:(void (^)(NSMutableArray *))result{
    
    NSURL *musicUrl = [NSURL URLWithString:kMusicUrl];
    
    //同步请求,所以添加子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *array = [NSArray arrayWithContentsOfURL:musicUrl];
        
        for (NSDictionary *item in array) {
            
            MusicModel *musicModel = [[MusicModel alloc] init];
            
            [musicModel setValuesForKeysWithDictionary:item];
            
            [self.allDataArray addObject:musicModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            result(self.allDataArray);
            
        });
        
    });
 
}


//懒加载
-(NSMutableArray *)allDataArray{
    
    if (!_allDataArray) {
        
        self.allDataArray = [NSMutableArray array];
    }
    
    return _allDataArray;
    
}

#pragma mark - 获取数组元素个数
-(NSInteger)getDataCount{
    
    return _allDataArray.count;
}

#pragma mark - 根据下标返回model对象

-(MusicModel *)getMusicModelWithIndex:(NSInteger)index{
    
    MusicModel *model = _allDataArray[index];
    
    return model;
    
}

@end
