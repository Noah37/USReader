//
//  USReaderSpeech.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import "USReaderSpeech.h"
#import <iflyMSC/IFlyMSC.h>
#import <iflyMSC/IFlySpeechError.h>
#import "PcmPlayer.h"
#import "USReaderSpeechConfig.h"
#import "USReaderSpeaker.h"
#import "TTSHuoShanEngine.h"

NSString * const USReaderSpeechCompletedNotification = @"USReaderSpeechCompletedNotification";
NSString * const USReaderSpeechBeginNotification    = @"USReaderSpeechBeginNotification";
NSString * const USReaderSpeechBufferProgressNotification = @"USReaderSpeechBufferProgressNotification";
NSString * const USReaderSpeechSpeakProgressNotification = @"USReaderSpeechSpeakProgressNotification";
NSString * const USReaderSpeechSpeakCancelNotification    = @"USReaderSpeechSpeakCancelNotification";
NSString * const USReaderSpeechSpeakPauseNotification = @"USReaderSpeechSpeakPauseNotification";
NSString * const USReaderSpeechSpeakResumeNotification = @"USReaderSpeechSpeakResumeNotification";

@interface USReaderSpeech ()<IFlySpeechSynthesizerDelegate,TTSBaseEngineDataSource>

@property (nonatomic, strong) IFlySpeechSynthesizer *iflySpeechSynthesizer;

@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, strong) NSString *speakText;

@property (nonatomic, strong) TTSHuoShanEngine *engine;

@end

@implementation USReaderSpeech

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSpeech];
        self.engine = [[TTSHuoShanEngine alloc] init];
        self.engine.dataSource = self;
    }
    return self;
}

- (NSString *_Nullable)currentSentence {
    return self.speakText;
}

- (NSString *_Nullable)nextSentence {
    return self.speakText;
}

- (NSString *_Nullable)previousSentence {
    return self.speakText;
}

+ (instancetype)sharedSpeech {
    static dispatch_once_t onceToken;
    static USReaderSpeech *speech;
    dispatch_once(&onceToken, ^{
        speech = [[USReaderSpeech alloc] init];
    });
    return speech;
}

- (void)setupSpeech {
    USReaderSpeechConfig *config = [USReaderSpeechConfig sharedConfig];
    
    NSString *initString = [NSString stringWithFormat:@"appid=%@", config.xfyjCloudAppId];
    [IFlySpeechUtility createUtility:initString];
    
    [self.iflySpeechSynthesizer setParameter:config.engineType forKey:IFlySpeechConstant.ENGINE_TYPE];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.speed] forKey:IFlySpeechConstant.SPEED];
    [self.iflySpeechSynthesizer setParameter:config.fileName forKey:IFlySpeechConstant.TTS_AUDIO_PATH];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.volume] forKey:IFlySpeechConstant.VOLUME];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.pitch] forKey:IFlySpeechConstant.PITCH];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.sampleRate] forKey:IFlySpeechConstant.SAMPLE_RATE];
    [self.iflySpeechSynthesizer setParameter:config.vcnName forKey:IFlySpeechConstant.VOICE_NAME];
    [self.iflySpeechSynthesizer setParameter:config.unicode forKey:IFlySpeechConstant.TEXT_ENCODING];
    
}

- (void)setupLocalSpeech {
    //设置协议委托对象
    //设置语音合成的启动参数
    USReaderSpeechConfig *config = [USReaderSpeechConfig sharedConfig];
//    NSString *initString = [NSString stringWithFormat:@"appid=%@", config.xfyjLocalAppId];
//    [IFlySpeechUtility createUtility:initString];
//    [[IFlySpeechUtility getUtility] setParameter:@"tts" forKey:IFlyResourceUtil.ENGINE_START];
    [self.iflySpeechSynthesizer setParameter:config.engineType forKey:IFlySpeechConstant.ENGINE_TYPE];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%@;%@", config.commonPath, config.speakersPath] forKey:config.ttsResPath];
    [self.iflySpeechSynthesizer setParameter:config.xfyjAppId forKey:@"caller.appid"];
    [self.iflySpeechSynthesizer setParameter:@"" forKey:@"ent"];
    [self.iflySpeechSynthesizer setParameter:@"http://yuji.xf-yun.com/msp.do" forKey:@"server_url"];
    //设置本地引擎类型
    [self.iflySpeechSynthesizer setParameter:config.voiceID forKey:IFlySpeechConstant.VOICE_ID];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.speed] forKey:IFlySpeechConstant.SPEED];
    [self.iflySpeechSynthesizer setParameter:config.fileName forKey:IFlySpeechConstant.TTS_AUDIO_PATH];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.volume] forKey:IFlySpeechConstant.VOLUME];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.pitch] forKey:IFlySpeechConstant.PITCH];
    [self.iflySpeechSynthesizer setParameter:[NSString stringWithFormat:@"%f", config.sampleRate] forKey:IFlySpeechConstant.SAMPLE_RATE];
    // 设置发音人
    [self.iflySpeechSynthesizer setParameter:config.vcnName forKey:IFlySpeechConstant.VOICE_NAME];
    [self.iflySpeechSynthesizer setParameter:config.unicode forKey:IFlySpeechConstant.TEXT_ENCODING];
    [self.iflySpeechSynthesizer setParameter:@"0" forKey:@"next_text_len"];
    [self.iflySpeechSynthesizer setParameter:@"" forKey:@"next_text"];
    
}

#pragma mark - public
- (void)start:(NSString *)sentence {
    BOOL isSpeaking = self.iflySpeechSynthesizer.isSpeaking;
    if (isSpeaking) {
        [self.iflySpeechSynthesizer stopSpeaking];
    }
    if (sentence.length > 0) {
        self.speakText = sentence;
    } else {
        self.speakText = [USReaderSpeechConfig sharedConfig].testText;
    }
    [self.iflySpeechSynthesizer startSpeaking:self.speakText];
}

- (void)startSpeak:(NSString *)sentence {
    if ([USReaderSpeechConfig sharedConfig].currentSpeaker.engineType == EngineTypeCloud) {
        [self setupSpeech];
        [self start:sentence];
    } else {
        [self startLocal:sentence];
    }
}

- (void)startLocal:(NSString *)sentence {
    self.speakText = sentence;
    [self.engine start];
//    [self setupLocalSpeech];
//    [self start:sentence];
}

- (void)stop {
    [self.iflySpeechSynthesizer stopSpeaking];
}

/// 恢复朗读
- (void)resume {
    [self.iflySpeechSynthesizer resumeSpeaking];
}

/// 暂停朗读
- (void)pause {
    [self.iflySpeechSynthesizer pauseSpeaking];
}

- (void)saveUriWithText:(NSString *)text path:(NSString *)path {
    self.iflySpeechSynthesizer.delegate = self;
    [self.iflySpeechSynthesizer synthesize:text toUri:path];
}

/// 保存音频文件
- (void)saveUri {
    NSString *savePath = [self uriPath];
    self.iflySpeechSynthesizer.delegate = self;
    [self.iflySpeechSynthesizer synthesize:self.speakText toUri:savePath];
}

/// 是否正在语音
- (BOOL)isSpeaking {
    return self.iflySpeechSynthesizer.isSpeaking;
}

/// 播放本地保存的音频文件
- (void)playUri {
    NSString *savePath = [self uriPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = [[PcmPlayer alloc] initWithFilePath:savePath sampleRate:[USReaderSpeechConfig sharedConfig].sampleRate];
        [self.audioPlayer play];
    }
}

/// 返回当前保存音频文件的路径
- (NSString *)uriPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:[USReaderSpeechConfig sharedConfig].fileName];
}

- (void)engineChange:(EngineType)engineType {
    if (engineType == EngineTypeCloud) {
        [self engineCloud];
    } else {
        [self engineLocal];
    }
}

/// 设置发音人
- (void)setSpeaker:(USReaderSpeaker *)speaker {
    if (self.iflySpeechSynthesizer.isSpeaking) {
        [self stop];
    }
    [USReaderSpeechConfig sharedConfig].currentSpeaker = speaker;
    [self startSpeak:self.speakText];
}

/// 设置发音人
- (void)setVcn:(NSString *)name {
    [USReaderSpeechConfig sharedConfig].vcnName = name;
}

/// 语音合成引擎变更为离线
- (void)engineLocal {
    [USReaderSpeechConfig sharedConfig].engineType = EngineTypeLocal;
    [self setupLocalSpeech];
}

/// 语音合成引擎变更为云端
- (void)engineCloud {
    [USReaderSpeechConfig sharedConfig].engineType = EngineTypeCloud;
    [self setupSpeech];

}

/// 音量范围 0-100
- (void)volumeChange:(NSInteger)volume {
    if (volume >= 0 && volume <= 100) {
        [USReaderSpeechConfig sharedConfig].volume = volume;
        [self setupSpeech];
    }
}

- (void)speedChange:(NSInteger)speed {
    if (speed >= 0 && speed <= 100) {
        [USReaderSpeechConfig sharedConfig].speed = speed;
        [self setupSpeech];
    }
}

#pragma mark - IFlySpeechSynthesizerDelegate

/*!
 *  结束回调<br>
 *  当整个合成结束之后会回调此函数
 *
 *  @param error 错误码
 */
- (void) onCompleted:(IFlySpeechError*) error {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechCompletedNotification object:error];
}

/*!
 *  开始合成回调
 */
- (void) onSpeakBegin {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechBeginNotification object:nil];
}

/*!
 *  缓冲进度回调
 *
 *  @param progress 缓冲进度，0-100
 *  @param msg      附件信息，此版本为nil
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechBufferProgressNotification object:nil];
}

/*!
 *  播放进度回调
 *
 *  @param progress 当前播放进度，0-100
 *  @param beginPos 当前播放文本的起始位置（按照字节计算），对于汉字(2字节)需／2处理
 *  @param endPos 当前播放文本的结束位置（按照字节计算），对于汉字(2字节)需／2处理
 */
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakProgressNotification object:nil];
}

/*!
 *  暂停播放回调
 */
- (void) onSpeakPaused {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakPauseNotification object:nil];
}

/*!
 *  恢复播放回调<br>
 *  注意：此回调方法SDK内部不执行，播放恢复全部在onSpeakBegin中执行
 */
- (void) onSpeakResumed {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakResumeNotification object:nil];
}

/*!
 *  正在取消回调<br>
 *  注意：此回调方法SDK内部不执行
 */
- (void) onSpeakCancel {
    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakCancelNotification object:nil];
}

/*!
 *  扩展事件回调<br>
 *  根据事件类型返回额外的数据
 *
 *  @param eventType 事件类型，具体参见IFlySpeechEventType枚举。目前只支持EVENT_TTS_BUFFER也就是实时返回合成音频。
 *  @param arg0      arg0
 *  @param arg1      arg1
 *  @param eventData 事件数据
 */
- (void) onEvent:(int)eventType arg0:(int)arg0 arg1:(int)arg1 data:(NSData *)eventData {
    
}

#pragma mark - getter
- (IFlySpeechSynthesizer *)iflySpeechSynthesizer {
    IFlySpeechSynthesizer *speech = [IFlySpeechSynthesizer sharedInstance];
    speech.delegate = self;
    return speech;
}

#pragma mark - audio


@end
