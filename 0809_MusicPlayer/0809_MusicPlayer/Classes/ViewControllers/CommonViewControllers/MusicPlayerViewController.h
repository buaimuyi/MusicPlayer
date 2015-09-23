//
//  MusicPlayerViewController.h
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/10.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayerHandle.h"
#import "LyricManager.h"
#import "Tool.h"

@interface MusicPlayerViewController : UIViewController

@property (assign, nonatomic) NSInteger index;

- (IBAction)backButton:(UIBarButtonItem *)sender;//点击返回歌曲列表页面

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


/**
 *  创建单例
 */

+(instancetype)sharedInstance;


@end
