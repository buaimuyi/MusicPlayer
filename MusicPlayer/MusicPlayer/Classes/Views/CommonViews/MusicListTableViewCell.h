//
//  MusicListTableViewCell.h
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/9.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

@property (strong, nonatomic) IBOutlet UILabel *songName;

@property (strong, nonatomic) IBOutlet UILabel *singerName;

@property (strong, nonatomic) MusicModel *musicModel;

@end
