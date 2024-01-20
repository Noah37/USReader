//
//  USReaderAudioPlayer.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/13.
//

#import "USReaderAudioPlayer.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <iflyMSC/IFlyMSC.h>
#import "TTSEngineManager.h"
#import "USReaderSpeechConfig.h"
#import "USConstants.h"
#import "USReaderRecordModel.h"

@interface USReaderAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic, strong) USReaderTime *playedTime;

@property (nonatomic, strong) USReaderTime *totalTime;

@property (nonatomic, assign) BOOL isAudio;

@property (nonatomic, strong) USReaderRecordModel *record;

@property (nonatomic, strong) NSTimer *audioTimer;

@end

@implementation USReaderAudioPlayer

+ (instancetype)sharedPlayer {
    static dispatch_once_t onceToken;
    static USReaderAudioPlayer *player;
    dispatch_once(&onceToken, ^{
        player = [[USReaderAudioPlayer alloc] init];
    });
    return player;
}

- (void)playWithUrl:(NSURL *)url {
    _isAudio = url ? YES:NO;
    if (url) {
        self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
        [self.audioTimer fire];
        //初始化音频类 并且添加播放文件
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _avAudioPlayer.delegate = self;
          
        //开始进行播放
        [_avAudioPlayer play];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStart:)]) {
                [self.delegate TTSBaseEngineDidStart:nil];
            }
        });
        
    } else {
        [[TTSEngineManager sharedManager] startWithDataSource:self.dataSource delegate:self.delegate];
    }
}

- (void)playWithRecord:(USReaderRecordModel *)record {
    _record = record;
    NSURL *url = record.chapterUrl;
    [self playWithUrl:url];
}

- (BOOL)playAtTime:(NSTimeInterval)time {
    if (self.isAudio) {
        self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
        [self.audioTimer fire];
        self.avAudioPlayer.currentTime = time;
        [self.avAudioPlayer prepareToPlay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStart:)]) {
                [self.delegate TTSBaseEngineDidStart:nil];
            }
        });
        
        return [self.avAudioPlayer play];
    }
    return NO;
}

- (void)stop {
    [self.audioTimer invalidate];
    self.audioTimer = nil;
    [self.avAudioPlayer stop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStop:)]) {
            [self.delegate TTSBaseEngineDidStop:nil];
        }
    });
    
    [[TTSEngineManager sharedManager] stop];
}

- (void)pause {
    [self.audioTimer invalidate];
    self.audioTimer = nil;
    [self.avAudioPlayer pause];
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidPause:)]) {
        [self.delegate TTSBaseEngineDidPause:nil];
    }
    [[TTSEngineManager sharedManager] pause];
}

- (void)resume {
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
    [self.audioTimer fire];
    [self.avAudioPlayer prepareToPlay];
    [self.avAudioPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidResume:)]) {
            [self.delegate TTSBaseEngineDidResume:nil];
        }
    });
    
    [[TTSEngineManager sharedManager] resume];
}

- (void)timeChangeAction {
    if (self.isAudio) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(USReaderAudioPlayer:playTime:)]) {
                [self.delegate USReaderAudioPlayer:self playTime:self.avAudioPlayer.currentTime];
            }
        });
        
    }
}

- (USReaderTime *)totalTime {
    if (self.isAudio) {
        return [USReaderTime timeWithInt:self.avAudioPlayer.duration];
    }
    return nil;
}

- (USReaderTime *)playedTime {
    if (self.isAudio) {
        return [USReaderTime timeWithInt:self.avAudioPlayer.currentTime];
    }
    return nil;
}

#pragma mark - AVAudioPlayerDelegate
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _record = [self.dataSource nextRecord];
    [self playWithRecord:_record];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

@end
