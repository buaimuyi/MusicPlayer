//
//  MusicListTableViewCell.m
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/9.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell

/**
 *  重写MusicModel的set方法
 */

- (void)setMusicModel:(MusicModel *)musicModel{
    
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]placeholderImage:nil];
    
    self.songName.text = musicModel.name;
    
    self.singerName.text = musicModel.singer;
    
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
