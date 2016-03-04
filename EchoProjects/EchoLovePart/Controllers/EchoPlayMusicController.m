//
//  EchoPlayMusicController.m
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "EchoPlayMusicController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Sound.h"
#import "Comment.h"
#import "Channel.h"
#import "EchoPlayMusicRootModel.h"

#import "PMPlayCell.h"
#import "PMOperationCell.h"
#import "PMChannelCell.h"
#import "PMMusicLyricCell.h"
#import "PMCommentCell.h"

static NSString *playCellReuseID = @"PlayCellID";
static NSString *commentCellReuseID = @"CommentCellID";
static NSString *operationCellReuseID = @"OperationCellID";
static NSString *lyricCellReuseID = @"MusicLyricCellID";
static NSString *channelCellReuseID = @"ChannelCellID";

@interface EchoPlayMusicController ()<PlayHelperDelegate,
                                      PMPlayCellDelegate,
                                      PMOperationCellDelegate,
                                      NSURLSessionDataDelegate,
                                      UITableViewDataSource,
                                      UITableViewDelegate>

{
    Sound *_currentSound ;
    NSInteger _currentIndex ;
    double    _playTimerOffset ;
    double    _timeChangeFlag ;
    double    _currentTime ;
}

#pragma mark --- 下载的属性<暂时没做下载>
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) BOOL isPuase;


#pragma mark - 声明私有属性 , 评论数据
@property (nonatomic, strong) NSMutableArray *currentCommentArray;
@property (nonatomic, strong) EchoPlayMusicRootModel *rootModel ;

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) UIImage     *showingImage ;

@end

@implementation EchoPlayMusicController

#pragma mark --- 单例方法
+ (instancetype)shareEchoPlayViewController
{
    static EchoPlayMusicController *playVC = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playVC = [[EchoPlayMusicController alloc] init];
    });
    return playVC ;
}

#pragma mark --- viewController lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.index == -1) {
        return ;
    }
    
    _currentIndex = self.index ;
    [self prepareForPlaying];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Echo回声";
    _currentIndex = -1 ;
    self.currentCommentArray = [NSMutableArray array] ;
    //播放器代理
    [PlayHelper sharePlayHelper].delegate = self;
    
    //初始化session对象
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]] ;
    //处理暂停下载
    self.isPuase = NO ;
    
    //开始接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //监听后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    
}

#pragma mark --- NSNotification method <音频中断后停止播放音乐>
- (void)onAudioSessionEvent:(id)sender
{
    NSLog(@"%s--- %@",__func__,sender) ;
    
    //音频中断后停止播放音乐
    [self pauseMusic];
}

#pragma mark --- 播放音乐前期准备工作 <会被调用多次>
//播放音乐
- (void)prepareForPlaying
{
    _currentTime = 0.0 ;
    
    if (self.isLocal == YES) {
        [self loadingLocalMusic];
        return ;
    }
    
    //加载sound Info and playMusic
    [self loadingSound];
    
    //加载评论
    [self loadingCommentData];
    
    [self initTableView];
}
/**
 *  加载本地音乐
 */
- (void)loadingLocalMusic
{
    //传来的只有下标，记得处理上一曲下一曲
    //持久化音乐文件
    //    [self initParameterOffset];
    
    _currentSound  = [DataManager shareDataManager].localURLArray[_currentIndex] ;
    
    //显示信息
    [self showSongInfo];
    
    //初始化参数
    [self initParameters];
    
    //显示评论信息
    [self showCommentsInfo];
    
    //播放音乐
    [[PlayHelper sharePlayHelper] playInternetMusicWithURL:_currentSound.source];
    
    //重置锁屏的信息
    [self configNowPlayingInfoCenter];
    
    NSIndexPath *playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    PMPlayCell *playCell = [self.tableView cellForRowAtIndexPath:playIndexPath] ;
    if (playCell.playButton.hidden == NO &&
        [PlayHelper sharePlayHelper].isPlay == YES) {
        playCell.playButton.hidden = YES ;
    }
}
/**
 *  显示信息
 */
- (void)showSongInfo
{
    _rootModel = [[EchoPlayMusicRootModel alloc] init];
    //播放信息
    _rootModel.avator = _currentSound.user.avatar ;
    _rootModel.userName = _currentSound.user.name ;
    _rootModel.focusCount = _currentSound.user.followed_count ;
    _rootModel.bigImage = _currentSound.pic_640 ;
    _rootModel.soundName = _currentSound.name ;
    
    //频道信息
    _rootModel.channelImage = _currentSound.channel.pic_640 ;
    _rootModel.channelName = _currentSound.channel.name ;
    _rootModel.channelDesc = _currentSound.channel.info ;
    
    //歌词信息
    _rootModel.soundSubTitle = _currentSound.name ;
    _rootModel.lyric = _currentSound.info ;
    
    __weak EchoPlayMusicController *weakself = self ;
    if (self.isLocal == YES) {
        self.showingImage = [UIImage imageWithContentsOfFile:_currentSound.pic_640] ;
        [self configNowPlayingInfoCenter];
    }else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
        
        [manager downloadImageWithURL:[NSURL URLWithString:_currentSound.pic_640] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image && !error) {
                weakself.showingImage = image ;
                [weakself configNowPlayingInfoCenter];
            }
        }];
    }
    
    [self.tableView reloadData];
}

/**
 *  显示评论信息
 */
- (void)showCommentsInfo
{
    NSIndexPath *commentIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[commentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  初始化参数
 */
- (void)initParameters
{
    _timeChangeFlag = 0 ;
    
    NSIndexPath *playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    PMPlayCell *playCell = [self.tableView cellForRowAtIndexPath:playIndexPath] ;
    playCell.payTimeLabel.text = @"00:00";
    playCell.progressConstraint.constant = 0.f ;
}
#pragma mark --- 网络请求数据
/**
 *  请求评论的数据
 */
- (void)loadingCommentData
{
    NSString *soundID = [[DataManager shareDataManager].allData[_currentIndex] ID] ;
    NSString *urlWithComments = [Comments_URL stringByAppendingFormat:@"%@",soundID];
    __weak EchoPlayMusicController *weakself = self ;
    AFHTTPRequestOperationManager *manager_2 = [AFHTTPRequestOperationManager manager];
    [manager_2 GET:urlWithComments parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *array =[[responseObject valueForKey:@"result"] valueForKey:@"data"];
        
        NSArray *comments = [Comment objectArrayWithKeyValuesArray:array] ;
        [weakself.currentCommentArray addObjectsFromArray:comments];
        weakself.rootModel.comments  = comments ;
        
        [weakself.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/**
 *  加载在线音乐 , 并播放
 */
- (void)loadingSound
{
    NSIndexPath *playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    __block PMPlayCell *playCell = [self.tableView cellForRowAtIndexPath:playIndexPath] ;
    NSString *soundId = [[DataManager shareDataManager].allData[_currentIndex] ID];
    NSString *url = [Sound_URL stringByAppendingFormat:@"%@",soundId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        Sound *sound = [Sound objectWithKeyValues:[responseObject valueForKey:@"result"]] ;

        User *user = [User objectWithKeyValues:[[responseObject valueForKey:@"result"] valueForKey:@"user"]];
        sound.user = user;

        Channel *channel = [Channel objectWithKeyValues:[[responseObject valueForKey:@"result"] valueForKey:@"channel"]];
        sound.channel = channel;
        _currentSound = sound;
        
        //锁屏信息
        [self configNowPlayingInfoCenter];
        
        //显示信息
        [self showSongInfo];
        //初始化参数
        [self initParameters];
        //播放音乐
        [[PlayHelper sharePlayHelper] playInternetMusicWithURL:_currentSound.source];
        if (playCell.playButton.hidden == NO && [PlayHelper sharePlayHelper].isPlay) {
            playCell.playButton.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

////       -------------tableView------------         ////
#pragma mark --- 初始化tableView
- (void)initTableView
{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsZero) ;
        }];
        [_tableView registerNib:[PMPlayCell nib] forCellReuseIdentifier:playCellReuseID];
        [_tableView registerClass:[PMOperationCell class] forCellReuseIdentifier:operationCellReuseID];
        [_tableView registerNib:[PMChannelCell nib] forCellReuseIdentifier:channelCellReuseID];
        [_tableView registerNib:[PMMusicLyricCell nib] forCellReuseIdentifier:lyricCellReuseID];
        [_tableView registerNib:[PMCommentCell nib] forCellReuseIdentifier:commentCellReuseID];
    }
}

#pragma mark --- tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_rootModel != nil) {
        if (_rootModel.comments.count > 0) {
            return 5 ;
        }else{
            return 4 ;
        }
    }
    return 0 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 45.f ;
    if (indexPath.row == 0) {
        height = kFullWidth + 60.f ;
    }else if (indexPath.row == 1){
        height = 50.f ;
    }else if (indexPath.row == 2){
        height = 125.f ;
    }else if (indexPath.row == 3){
        CGFloat textHeight = [[DataManager shareDataManager] calculateTextHeightWith:_rootModel.lyric andFont:[UIFont systemFontOfSize:12.f] andMaxWidth:kFullWidth-20.f] ;
        height = 80.f + textHeight ;// 80.f + textHeight
    }else if (indexPath.row == 4){
        if (_rootModel.comments > 0) {
            height = _rootModel.comments.count * 60.f + 35.f ;
        }else{
            height = 0.f ;
        }
    }
    return height ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    
    if (indexPath.row == 0) {       //播放音乐的cell
        
        PMPlayCell *playCell = [tableView dequeueReusableCellWithIdentifier:playCellReuseID forIndexPath:indexPath] ;
        playCell.delegate = self ;
        
        [playCell.avatorImage sd_setImageWithURL:[NSURL URLWithString:_rootModel.avator]] ;
        playCell.nameLabel.text = _rootModel.userName ;
        playCell.focusLabel.text = [NSString stringWithFormat:@"被关注%@",_rootModel.focusCount] ;
        [playCell.cuctomImage sd_setImageWithURL:[NSURL URLWithString:_rootModel.bigImage]] ;
        playCell.soundNameLabel.text = _rootModel.soundName ;
        
        cell = playCell ;
        
    }else if (indexPath.row == 1){  //操作cell<评论 , 点赞 , 下载 , 分享>
        
        PMOperationCell *operationCell = [tableView dequeueReusableCellWithIdentifier:operationCellReuseID forIndexPath:indexPath];
        operationCell.delegate = self ;
        cell = operationCell ;
    
    }else if (indexPath.row == 2){  //频道
        
        PMChannelCell *channelCell = [tableView dequeueReusableCellWithIdentifier:channelCellReuseID forIndexPath:indexPath] ;
        [channelCell.customImage sd_setImageWithURL:[NSURL URLWithString:_rootModel.channelImage]];
        channelCell.channelNameLabel.text = _rootModel.channelName ;
        channelCell.channelInfoLabel.text = _rootModel.channelDesc ;
        
        cell = channelCell ;
        
    }else if (indexPath.row == 3){  //歌词cell
        
        PMMusicLyricCell *lyricCell = [tableView dequeueReusableCellWithIdentifier:lyricCellReuseID forIndexPath:indexPath] ;
        NSAttributedString *firstAttr = [[NSAttributedString alloc] initWithString:@"由" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        NSAttributedString *middleAttr = [[NSAttributedString alloc] initWithString:_rootModel.userName attributes:@{NSForegroundColorAttributeName:EchoColor(74, 255, 68)}];
        NSAttributedString *lastAttr = [[NSAttributedString alloc] initWithString:@"上传" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        NSMutableAttributedString *mulAttr = [[NSMutableAttributedString alloc] init];
        [mulAttr appendAttributedString:firstAttr];
        [mulAttr appendAttributedString:middleAttr];
        [mulAttr appendAttributedString:lastAttr];
        lyricCell.authorLabel.attributedText = mulAttr ;
        lyricCell.titleLabel.text = _rootModel.soundSubTitle ;
        lyricCell.lyricLabel.text = _rootModel.lyric ;
        
        cell = lyricCell ;
        
    }else if (indexPath.row == 4){  //评论cell
        
        PMCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellReuseID forIndexPath:indexPath] ;
        commentCell.dataArray = _rootModel.comments ;
        cell = commentCell ;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
////       -------------tableView------------         ////
#pragma mark --- cell 代理事件函数
/**
 *  暂停音乐
 */
-(void)tapImageToPauseMusic
{
    NSLog(@"%s",__FUNCTION__);
    [self pauseMusic];
}
/**
 *  关注该作者
 */
- (void)focusButtonClicked:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
}
/**
 *  播放音乐
 */
- (void)playButtonClicked:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
    [self playMusic];
}
- (void)operationAtIndex:(NSInteger)index
{
    NSLog(@"%s",__FUNCTION__);
    switch (index) {
        case 0://评论
        {
        
        }
            break;
        case 1://点赞
        {
            
        }
            break;
        case 2://下载
        {
            
        }
            break;
        case 3://分享
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 秒数转 时 分
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}

#pragma mark --- public method

/**
 *  上一曲
 */
- (void)previousMusic
{
    _currentIndex -- ;
    
    if (self.isLocal == NO) {
        if (_currentIndex < 0) {
            _currentIndex = [DataManager shareDataManager].allData.count - 1 ;
        }
    }else {
        if (_currentIndex < 0) {
            _currentIndex = [DataManager shareDataManager].localURLArray.count - 1 ;
        }
    }
    
    [self prepareForPlaying];
}
/**
 *  下一曲
 */
- (void)nextMusic
{
    _currentIndex ++ ;
    
    if (self.isLocal == NO) {
        if (_currentIndex >= [DataManager shareDataManager].allData.count) {
            _currentIndex = 0 ;
        }
    }else{
        if (_currentIndex >= [DataManager shareDataManager].localURLArray.count) {
            _currentIndex = 0 ;
        }
    }
    
    [self prepareForPlaying];
}
/**
 *  每隔1秒刷新进度条以及播放时间
 *
 *  @param time 当前播放进度时间
 */
-(void)playingWithTime:(NSTimeInterval)time
{
    _currentTime = time ;
    [self changeProgress];
    
    if (time == _timeChangeFlag) {
        return ;
    }
    
    NSIndexPath *playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    PMPlayCell *playCell = (PMPlayCell *)[self.tableView cellForRowAtIndexPath:playIndexPath] ;
    
    playCell.payTimeLabel.text = [self timeFormatted:(int)time];
    
    double totalTime = [_currentSound.length doubleValue];
    double X_offset = _currentTime / totalTime * kFullWidth ;
    playCell.progressConstraint.constant = X_offset ;
    
//    [self.tableView reloadData];
}
/**
 *  播放结束后停止了播放下一曲
 */
-(void)didStop
{
    [self nextMusic];
}
/**
 *  播放音乐
 */
-(void)playMusic
{
    [[PlayHelper sharePlayHelper] play];
    NSIndexPath *playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    PMPlayCell *playCell = [self.tableView cellForRowAtIndexPath:playIndexPath] ;
    playCell.playButton.hidden = YES ;
}
/**
 *  暂停音乐
 */
-(void)pauseMusic
{
    [[PlayHelper sharePlayHelper] pause];
    
    NSIndexPath *playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    PMPlayCell *playCell = [self.tableView cellForRowAtIndexPath:playIndexPath] ;
    playCell.playButton.hidden = NO ;
}
/**
 *  获取锁屏后显示的信息
 */
- (void)configNowPlayingInfoCenter
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        //需要一个字典存放要显示的信息
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary] ;
        
        //歌曲名称
        [infoDic setObject:_currentSound.name forKey:MPMediaItemPropertyTitle];
        
        //演唱者
        [infoDic setObject:_currentSound.user.name forKey:MPMediaItemPropertyArtist];
        
        //专辑名
        [infoDic setObject:_currentSound.channel.name forKey:MPMediaItemPropertyAlbumTitle];
        
        //专辑缩略图
        if (self.showingImage != nil) {
            MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:self.showingImage];
            [infoDic setObject:artWork forKey:MPMediaItemPropertyArtwork];
        }
        
        //音乐剩余时长
        NSNumber *soundTime = @([_currentSound.length doubleValue]) ;
        [infoDic setObject:soundTime forKey:MPMediaItemPropertyPlaybackDuration];
        
        //音乐当前播放时间 在计时器中修改
        NSNumber *nowPlayTime = @(_currentTime);
        [infoDic setObject:nowPlayTime forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:infoDic];
    }
}

/**
 *  计时器修改播放进度
 */
- (void)changeProgress
{
    //当前播放时间
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    
    [dict setObject:[NSNumber numberWithDouble:_currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经过时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

@end
