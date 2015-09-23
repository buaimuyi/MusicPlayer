//
//  MusicPlayerViewController.m
//  0809_MusicPlayer
//
//  Created by CCY on 15/8/10.
//  Copyright (c) 2015年 CCY. All rights reserved.
//

#import "MusicPlayerViewController.h"

@interface MusicPlayerViewController ()<UITableViewDataSource,UITableViewDelegate,MusicPlayerDelegate>

{
    NSInteger _currentIndex;//记录当前歌曲模型下标
}
@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

@property (strong, nonatomic) IBOutlet UILabel *currentTime;

@property (strong, nonatomic) IBOutlet UILabel *remainingTime;

@property (strong, nonatomic) IBOutlet UISlider *songProgress;


- (IBAction)lastSong:(UIButton *)sender;

- (IBAction)pausePlaying:(UIButton *)sender;

- (IBAction)nextSong:(UIButton *)sender;

- (IBAction)songProgress:(UISlider *)sender;

- (IBAction)volumeSlider:(UISlider *)sender;

- (IBAction)playWay:(UIButton *)sender;


@end

@implementation MusicPlayerViewController

+(instancetype)sharedInstance{
    
    static MusicPlayerViewController *musicPlayer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        musicPlayer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"musicPlayer"];
    });
    
    return musicPlayer;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    _currentIndex = 2333;// ?
    
    [MusicPlayerHandle sharedInstance].delegate = self;
    
    //设置imageView;
    [self setImageView];
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lyricCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    [super viewWillAppear:YES];
    
    if (_currentIndex == self.index) {
        
        return;
    }else{
        _currentIndex = self.index;
        
        [self updateUI];
    }
}

#pragma mark- 更新UI

- (void)updateUI{
    
    [[MusicPlayerHandle sharedInstance]setAVPlayerWithUrl:self.model.mp3Url];
    
    //设置Navigation Bar Title
    for (UINavigationItem *item in self.navigationBar.items) {
        
        item.title = self.model.name;
    }
    
    //设置图片
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl] placeholderImage:nil];

    //歌词页面背景图片
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.picUrl]];
//        
//    UIImage *image = [UIImage imageWithData:data];
//        
//    image =[Tool blurryImage:image withBlurLevel:0.2];
//        
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        
//    self.tableView.backgroundView = imageView;
    
    //slider
    CGFloat totalTime = [self.model.duration floatValue] / 1000;
    self.songProgress.maximumValue = totalTime;
    
    //显示歌词
    [[LyricManager sharedInstance] setLyricFormat:self.model.lyric];
    
    [self.tableView reloadData];
}

#pragma mark - 设置imageView

-(void)setImageView{
    
    //设置圆角
    [self.songImageView layoutIfNeeded];
    self.songImageView.layer.cornerRadius = CGRectGetWidth(self.songImageView.frame) / 2;
    self.songImageView.layer.masksToBounds = YES;
    
    //设置起始角度
    self.songImageView.transform = CGAffineTransformMakeRotation(0);
}

#pragma mark - 返回歌曲列表界面

- (IBAction)backButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 上一曲

- (IBAction)lastSong:(UIButton *)sender {
    
    //先暂停播放
    [[MusicPlayerHandle sharedInstance]pauseMusic];
    
    if (count == 1) {
        
        _currentIndex = arc4random()%[[MusicManager sharedInstance]getDataCount];
        
        if (_currentIndex < 0) {
            
            _currentIndex = [[MusicManager sharedInstance]getDataCount] - 1;
        }
        
        [self updateUI];
        
    }else{
        
        _currentIndex--;
        
        if (_currentIndex < 0) {
            
            _currentIndex = [[MusicManager sharedInstance]getDataCount] - 1;
        }
        
        [self updateUI];
    }

}

#pragma mark - 暂停/播放

- (IBAction)pausePlaying:(UIButton *)sender {
    
    BOOL isPlaying = [[MusicPlayerHandle sharedInstance]playingOrPause];
    
    if (isPlaying) {
        
        [sender setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    }else{
        
        [sender setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 下一曲

- (IBAction)nextSong:(UIButton *)sender {
    
    [[MusicPlayerHandle sharedInstance]pauseMusic];
    
    if (count == 1) {
        
        _currentIndex = arc4random()%[[MusicManager sharedInstance]getDataCount];
        
        if (_currentIndex > [[MusicManager sharedInstance]getDataCount] - 1) {
            
            _currentIndex = 0;
        }
        
        [self updateUI];
        
    }else{
        
        _currentIndex++;
        
        if (_currentIndex > [[MusicManager sharedInstance]getDataCount] - 1) {
            
            _currentIndex = 0;
        }
        
        [self updateUI];
    }
}

#pragma mark - 歌曲播放进度

- (IBAction)songProgress:(UISlider *)sender {
    
    [[MusicPlayerHandle sharedInstance]pauseMusic];
    
    CGFloat duration = [[self.model duration]floatValue] / 1000;
    
    if (sender.value >= duration) {
        
        [[MusicPlayerHandle sharedInstance] pauseMusic];
        
        return;
    
    }else {
        
        [[MusicPlayerHandle sharedInstance] seekTimeToPlay:sender.value];
    }
}

#pragma mark - 音量调节

- (IBAction)volumeSlider:(UISlider *)sender {
    
    [[MusicPlayerHandle sharedInstance]changeVolumeWithValue:sender];

}

#pragma mark - 播放模式

static int count = 1;
- (IBAction)playWay:(UIButton *)sender {
    
    if (count == 1) {
        
        [sender setImage:[UIImage imageNamed:@"顺序播放"] forState:UIControlStateNormal];
        count++;
    }else if (count == 2){
        
        [sender setImage:[UIImage imageNamed:@"随机播放"] forState:UIControlStateNormal];
        count = 1;
    }
  
}

#pragma mark - 获取model

-(MusicModel *)model{
    
    MusicModel *musicModel = [[MusicManager sharedInstance] getMusicModelWithIndex:_currentIndex];
    
    return musicModel;
}

#pragma mark - 播放时执行的方法(协议中的方法)

-(void)playWithProgress:(CGFloat)progress{
    
    //图片旋转
    self.songImageView.transform = CGAffineTransformRotate(self.songImageView.transform, M_1_PI/90);
    
    //播放进度
    self.songProgress.value = progress;
    
    //当前播放时间
    self.currentTime.text = [self changeTimeFormat:progress];
    
    //剩余时间
    CGFloat totalTime = [self.model.duration floatValue] / 1000;
    self.remainingTime.text = [self changeTimeFormat:totalTime - progress];
    
    //歌词滚动
    NSInteger index = [[LyricManager sharedInstance] getIndexWithTime:progress];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  
}

#pragma mark - 时间格式转换

-(NSString *)changeTimeFormat:(CGFloat)time{
    
    //分钟
    int minute = time / 60;
    //秒钟
    int second = (int)time % 60;//注意类型
    
    NSString *times = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    
    return times;
}

#pragma mark - 播放结束时执行的方法

-(void)playDidToEnd{

    if (count == 1) {
        
        _currentIndex = arc4random()%[[MusicManager sharedInstance]getDataCount];
        
        if (_currentIndex > [[MusicManager sharedInstance]getDataCount] - 1) {
            
            _currentIndex = 0;
        }
        
        [self updateUI];
        
    }else {
        
        _currentIndex++;
        
        if (_currentIndex > [[MusicManager sharedInstance]getDataCount] - 1) {
            
            _currentIndex = 0;
        }
        
        [self updateUI];
    }
}

#pragma mark - 设置tableView中的方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[LyricManager sharedInstance]countOfAllLyricArray];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lyricCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    //去除选中某个cell时的背景
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectedView;
    
    //歌词居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //显示
    cell.textLabel.text = [[LyricManager sharedInstance] getAllLyricWithIndex:indexPath.row];
    
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:(arc4random() % 256 / 256.0) green:(arc4random() % 256 / 256.0) blue:(arc4random() % 256 / 256.0) alpha:1.0];
    
    //取消横线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

//从指定歌词处开始播放
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat time = [[LyricManager sharedInstance]getTimeWithIndex:indexPath.row];
    
    [[MusicPlayerHandle sharedInstance]seekTimeToPlay:time];
}

@end
