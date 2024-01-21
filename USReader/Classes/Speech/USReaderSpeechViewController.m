//
//  USReaderSpeechViewController.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import "USReaderSpeechViewController.h"
#import "USConstants.h"
#import <Masonry/Masonry.h>
#import "USReaderSpeakersViewController.h"
#import "USReaderSpeechConfig.h"
#import "USReaderSpeech.h"
#import "USReaderAudioPlay.h"
#import <iflyMSC/IFlyMSC.h>
#import "TTSEngineManager.h"
#import "USReaderSpeechOperationView.h"
#import "USReaderAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface USReaderSpeechViewController ()<TTSEngineDataSource,TTSBaseEngineDelegate,USReaderSpeechOperationViewDelegate, USReaderAudioPlayerDataSource,USReaderAudioPlayerDelegate>

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UILabel *bookLabel;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *originButton;
@property (nonatomic, strong) USReaderSpeechOperationView *operationView;


@property (nonatomic, strong) USReaderRecordModel *recordModel;

@property (nonatomic, strong) USReaderRecordModel *currentRecordModel;

@end

@implementation USReaderSpeechViewController

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel {
    self = [super init];
    if (self) {
        self.recordModel = recordModel;
    }
    return self;
}

- (void)setCurrentRecordModel:(USReaderRecordModel *)recordModel {
    _currentRecordModel = recordModel;
    [self reloadData];
    [self startSpeak:recordModel.contentAttributedString.string];
}

/// 获取第一个章节，包含封面图等
- (USReaderChapterModel *)getFirstChapter {
    return [USReaderChapterModel model:self.recordModel.bookID chapterId:[NSNumber numberWithInt:self.recordModel.firstChapter.idString.intValue] isUpdateFont:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakCompleted:) name:USReaderSpeechCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakBegin) name:USReaderSpeechBeginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakCancel) name:USReaderSpeechSpeakCancelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakPause) name:USReaderSpeechSpeakPauseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakResume) name:USReaderSpeechSpeakResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioInterruptionHandler:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [USReaderAudioPlayer sharedPlayer].dataSource = self;
    [USReaderAudioPlayer sharedPlayer].delegate = self;
    
    [self setCurrentRecordModel:self.recordModel];
    
    [self createRemoteCommandCenter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)setupSubviews {
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.inset(16);
        make.top.inset(60);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.chapterLabel];
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.inset(16);
        make.top.equalTo(self.closeButton.mas_bottom).offset(20);
        make.trailing.inset(16);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.bookLabel];
    [self.bookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.inset(16);
        make.top.equalTo(self.chapterLabel.mas_bottom).offset(5);
        make.trailing.inset(16);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(300);
        make.centerX.equalTo(self.avatarView.superview);
        make.top.equalTo(self.bookLabel.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.inset(16);
        make.top.equalTo(self.avatarView.mas_bottom).offset(20);
        make.height.mas_greaterThanOrEqualTo(60);
        make.height.mas_lessThanOrEqualTo(120);
    }];
    
    [self.contentBgView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.inset(10);
    }];
    
    [self.view addSubview:self.operationView];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.operationView.superview);
    }];
}

- (void)startSpeak:(NSString *)sentence {
    [[USReaderAudioPlayer sharedPlayer] stop];
    [[USReaderAudioPlayer sharedPlayer] playWithRecord:self.currentRecordModel];
}


// 更新锁屏界面信息
- (void)refreshLockScreenInfo {
   
   // 1.获取锁屏中心
   MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
   // 初始化一个存放音乐信息的字典
   NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
   
   // 2、设置歌曲名
   [playingInfoDict setObject:self.recordModel.chapterModel.name
                       forKey:MPMediaItemPropertyTitle];
   [playingInfoDict setObject:self.recordModel.bookID
                       forKey:MPMediaItemPropertyAlbumTitle];
   
   
   // 3、设置封面的图片
   UIImage *image = [self.recordModel firstChapter].avatar;
   if (image) {
       MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
       [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
   }
   
   // 4、设置歌曲的时长和已经消耗的时间
    CMTime durationTime = { 1, 1, kCMTimeFlags_Valid, 1};
    CMTime elapsedTime = { 0, 0, kCMTimeFlags_Valid, 0};
   NSNumber *playbackDuration = @(CMTimeGetSeconds(durationTime));
   NSNumber *elapsedPlaybackTime = @(CMTimeGetSeconds(elapsedTime));
   
   if (!playbackDuration || !elapsedPlaybackTime) {
       return;
   }
   [playingInfoDict setObject:playbackDuration
                       forKey:MPMediaItemPropertyPlaybackDuration];
   [playingInfoDict setObject:elapsedPlaybackTime
                       forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
   [playingInfoDict setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
   
   //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
   playingInfoCenter.nowPlayingInfo = playingInfoDict;
}


// 添加远程控制
- (void)createRemoteCommandCenter {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    MPRemoteCommand *pauseCommand = [commandCenter pauseCommand];
    [pauseCommand setEnabled:YES];
    [pauseCommand addTarget:self action:@selector(remotePauseEvent)];
    
    MPRemoteCommand *playCommand = [commandCenter playCommand];
    [playCommand setEnabled:YES];
    [playCommand addTarget:self action:@selector(remotePlayEvent)];
    
    MPRemoteCommand *nextCommand = [commandCenter nextTrackCommand];
    [nextCommand setEnabled:YES];
    [nextCommand addTarget:self action:@selector(remoteNextEvent)];
    
    MPRemoteCommand *previousCommand = [commandCenter previousTrackCommand];
    [previousCommand setEnabled:YES];
    [previousCommand addTarget:self action:@selector(remotePreviousEvent)];
    
    if (@available(iOS 9.1, *)) {
        MPRemoteCommand *changePlaybackPositionCommand = [commandCenter changePlaybackPositionCommand];
        [changePlaybackPositionCommand setEnabled:YES];
        [changePlaybackPositionCommand addTarget:self action:@selector(remoteChangePlaybackPosition:)];
    }
}

- (void)removeCommandCenterTargets
{
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [[commandCenter playCommand] removeTarget:self];
    [[commandCenter pauseCommand] removeTarget:self];
    [[commandCenter nextTrackCommand] removeTarget:self];
    [[commandCenter previousTrackCommand] removeTarget:self];
    
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand removeTarget:self];
    }
}

- (MPRemoteCommandHandlerStatus)remotePlayEvent {
    
    [[USReaderAudioPlayer sharedPlayer] resume];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remotePauseEvent {
    
    [[USReaderAudioPlayer sharedPlayer] pause];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remoteNextEvent {
    [self USReaderSpeechOperationViewClickNext:nil];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remotePreviousEvent {
    
    [self USReaderSpeechOperationViewClickPrevious:nil];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remoteChangePlaybackPosition:(MPRemoteCommandEvent *)event {
    
//    MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
//    [self seekToTime:playbackPositionEvent.positionTime];
    return MPRemoteCommandHandlerStatusSuccess;
}

-(void)appWillTerminate:(NSNotification*)note {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:nil];
}

- (void)audioInterruptionHandler:(NSNotification*)notification {
    AVAudioSessionInterruptionType interruptionType = (AVAudioSessionInterruptionType)[[notification.userInfo objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    AVAudioSessionInterruptionOptions intertuptionOptions = [[notification.userInfo objectForKey:AVAudioSessionInterruptionOptionKey] unsignedIntValue];
    NSLog(@"Receive audio interruption notification, type: %lu, options: %lu.", (unsigned long)interruptionType, (unsigned long)intertuptionOptions);
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"Audio session interruption began");
        @synchronized (self) {
            [[USReaderAudioPlayer sharedPlayer] pause];
        }
    } else if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
        @synchronized (self) {
            NSLog(@"Audio session interruption ended");
            if (intertuptionOptions == AVAudioSessionInterruptionOptionShouldResume) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                AVAudioSessionCategoryOptions cur_options = session.categoryOptions;
                // AudioQueueStart() will return AVAudioSessionErrorCodeCannotInterruptOthers if options didn't contains AVAudioSessionCategoryOptionMixWithOthers
                if (!(cur_options & AVAudioSessionCategoryOptionMixWithOthers)) {
                    AVAudioSessionCategoryOptions readyOptions = AVAudioSessionCategoryOptionMixWithOthers | cur_options;
                    [session setCategory:AVAudioSessionCategoryPlayback withOptions:readyOptions error:nil];
                }
                [[USReaderAudioPlayer sharedPlayer] resume];
                
                cur_options = session.categoryOptions;
                // Remove AVAudioSessionCategoryOptionMixWithOthers, or the playback will not be interrupted any more
                if (cur_options & AVAudioSessionCategoryOptionMixWithOthers) {
                    [session setCategory:AVAudioSessionCategoryPlayback withOptions:((~AVAudioSessionCategoryOptionMixWithOthers) & cur_options) error:nil];
                }
            }
        }
    }
}

#pragma mark - USReaderSpeechOperationViewDelegate
- (void)USReaderSpeechOperationViewClickStart:(USReaderSpeechOperationView *)operationView {
    [[USReaderAudioPlayer sharedPlayer] resume];
}

- (void)USReaderSpeechOperationViewClickPause:(USReaderSpeechOperationView *)operationView {
    [[USReaderAudioPlayer sharedPlayer] pause];
}

- (void)USReaderSpeechOperationViewClickNext:(USReaderSpeechOperationView *)operationView {
    USReaderRecordModel *recordModel = self.nextRecordHandler(self.currentRecordModel);
    _currentRecordModel = recordModel;
    [self reloadData];
    [self startSpeak:nil];
}

- (void)USReaderSpeechOperationViewClickPrevious:(USReaderSpeechOperationView *)operationView {
    USReaderRecordModel *recordModel = self.previousRecordHandler(self.currentRecordModel);
    _currentRecordModel = recordModel;
    [self reloadData];
    [self startSpeak:nil];
}

- (void)USReaderSpeechOperationViewClickSpeakers:(USReaderSpeechOperationView *)operationView {
    [self speakersAction];
}

- (void)USReaderSpeechOperationView:(USReaderSpeechOperationView *)operationView progressWillChange:(CGFloat)progress {
    [[USReaderAudioPlayer sharedPlayer] pause];
}

- (void)USReaderSpeechOperationView:(USReaderSpeechOperationView *)operationView progressDidChange:(CGFloat)progress {
    [[USReaderAudioPlayer sharedPlayer] playAtTime:progress];
}

#pragma mark - USReaderAudioPlayerDataSource
- (USReaderRecordModel *)nextRecord {
    USReaderRecordModel *recordModel = self.nextRecordHandler(self.currentRecordModel);
    _currentRecordModel = recordModel;
    [self reloadData];
    return recordModel;
}

- (NSString *)currentSentence {
    return self.currentRecordModel.pageModel.showContent.string;
}

- (NSString *)nextSentence {
    USReaderRecordModel *recordModel = self.nextRecordHandler(self.currentRecordModel);
    _currentRecordModel = recordModel;
    [self reloadData];
    return recordModel.pageModel.showContent.string;
}

- (NSString *)previousSentence {
    USReaderRecordModel *recordModel = self.previousRecordHandler(self.currentRecordModel);
    _currentRecordModel = recordModel;
    [self reloadData];
    return recordModel.pageModel.showContent.string;
}

#pragma mark - USReaderAudioPlayerDelegate
- (void)USReaderAudioPlayer:(USReaderAudioPlayer *)player playTime:(NSTimeInterval)playTime {
    [self timeChangeAction];
}

- (void)TTSBaseEngine:(TTSBaseEngine *)engine readText:(NSAttributedString *)text {
    self.contentLabel.attributedText = text;
}

- (void)TTSBaseEngineDidStart:(TTSBaseEngine *)engine {
    self.operationView.pauseButton.selected = YES;
}

- (void)TTSBaseEngineDidPause:(TTSBaseEngine *)engine {
    self.operationView.pauseButton.selected = NO;
}

- (void)TTSBaseEngineDidResume:(TTSBaseEngine *)engine {
    self.operationView.pauseButton.selected = YES;
}

- (void)TTSBaseEngineDidStop:(TTSBaseEngine *)engine {
    self.operationView.pauseButton.selected = NO;
}

- (TTSEngineType)engineType {
    return [USReaderSpeechConfig sharedConfig].currentSpeaker.realEngineType;
}

#pragma mark - action
- (void)destroy {
    [self removeCommandCenterTargets];
}

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)originAction {
    
}

- (void)speakersAction {
    USReaderSpeakersViewController *speakersVC = [[USReaderSpeakersViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    speakersVC.speakerChanged = ^(USReaderSpeaker *speaker){
        [USReaderSpeechConfig sharedConfig].currentSpeaker = speaker;
        [weakSelf reloadData];
        [weakSelf startSpeak:nil];
    };
    [self presentViewController:speakersVC animated:YES completion:nil];
}

- (void)timeChangeAction {
    [self.operationView setDuration:[USReaderAudioPlayer sharedPlayer].totalTime currentTime:[USReaderAudioPlayer sharedPlayer].playedTime];
    [self reloadData];
}

#pragma mark - private
- (void)reloadData {
    [self.operationView reloadData];
    _chapterLabel.text = self.currentRecordModel.chapterModel.name;
    _bookLabel.text = self.currentRecordModel.bookID;
    [self refreshLockScreenInfo];
}

- (void)speakBegin {
    [self reloadData];
}

- (void)speakCompleted:(NSNotification *)noti {
    IFlySpeechError *error = noti.object;
    if (error && error.errorCode > 0) {
        NSLog(@"error:%@", error.errorDesc.description);
        return;
    }
    [self reloadData];
    if (self.playNextHandler) {
        self.playNextHandler(self.recordModel);
    }
}

- (void)speakCancel {
    [self reloadData];

}

- (void)speakPause {
    [self reloadData];

}

- (void)speakResume {
    [self reloadData];

}

#pragma mark - getter
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:USAssetImage(@"arrow_down") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)originButton {
    if (!_originButton) {
        _originButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_originButton setTitle:@"原文" forState:UIControlStateNormal];
        [_originButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_originButton addTarget:self action:@selector(originAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originButton;
}

- (UILabel *)chapterLabel {
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] init];
        _chapterLabel.textAlignment = NSTextAlignmentLeft;
        _chapterLabel.textColor = [UIColor whiteColor];
        _chapterLabel.font = [UIFont systemFontOfSize:18];
        _chapterLabel.text = self.recordModel.chapterModel.name;
    }
    return _chapterLabel;
}

- (UILabel *)bookLabel {
    if (!_bookLabel) {
        _bookLabel = [[UILabel alloc] init];
        _bookLabel.textAlignment = NSTextAlignmentLeft;
        _bookLabel.textColor = [UIColor whiteColor];
        _bookLabel.font = [UIFont systemFontOfSize:13];
        _bookLabel.text = self.recordModel.bookID;
    }
    return _bookLabel;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        _contentBgView.layer.cornerRadius = 5;
        _contentBgView.layer.masksToBounds = YES;
    }
    return _contentBgView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = self.recordModel.chapterModel.content;
    }
    return _contentLabel;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.backgroundColor = [UIColor whiteColor];
        _avatarView.image = [self getFirstChapter].avatar;
    }
    return _avatarView;
}

- (USReaderSpeechOperationView *)operationView {
    if (!_operationView) {
        _operationView = [[USReaderSpeechOperationView alloc] init];
        _operationView.delegate = self;
    }
    return _operationView;
}

@end
