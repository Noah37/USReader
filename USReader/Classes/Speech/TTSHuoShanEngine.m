//
//  TTSHuoShanEngine.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "TTSHuoShanEngine.h"
#import "USHuoShanDefines.h"
#import "USReaderSpeechConfig.h"

@interface TTSHuoShanEngine ()

// SpeechEngine
@property (strong, nonatomic) SpeechEngine *curEngine;
@property(nonatomic, strong) NSString *deviceID;
// Debug Path: 用于存放一些 SDK 相关的文件，比如模型、日志等
@property (strong, nonatomic) NSString *debugPath;

@property (assign, nonatomic) BOOL ttsSynthesisFromPlayer;
@property (assign, nonatomic) int ttsSynthesisIndex;
@property (assign, nonatomic) int ttsPlayingIndex;
@property (assign, nonatomic) double ttsPlayingProgress;
@property (strong, nonatomic) NSMutableArray* ttsSynthesisText;
@property (strong, nonatomic) NSMutableDictionary* ttsSynthesisMap;

@end

@implementation TTSHuoShanEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化和小说模式有关的字段
        self.ttsSynthesisFromPlayer = FALSE;
        self.ttsSynthesisIndex = 0;
        self.ttsPlayingIndex = -1;
        self.ttsPlayingProgress = 0.0;
        self.ttsSynthesisText = [[NSMutableArray alloc] init];
        self.ttsSynthesisMap = [[NSMutableDictionary alloc]init];
        self.debugPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        [self initEngine];

    }
    return self;
}

- (void)initEngine {
    if (self.curEngine == nil) {
        self.curEngine = [[SpeechEngine alloc] init];
        if (![self.curEngine createEngineWithDelegate:self]) {
            NSLog(@"引擎创建失败.");
            return;
        }
    }
    NSLog(@"SDK 版本号: %@", [self.curEngine getVersion]);
    NSLog(@"配置初始化参数");
    [self configInitParams];

    NSLog(@"引擎初始化");
    SEEngineErrorCode ret = [self.curEngine initEngine];
    self.isEngineInited = (ret == SENoError);
    if (self.isEngineInited) {
        NSLog(@"初始化成功");
        
    } else {
        NSLog(@"初始化失败，返回值: %d", ret);
        [self deinitEngine];
    }
}

- (void)deinitEngine {
    if (self.curEngine != nil) {
        NSLog(@"引擎析构");
        [self.curEngine destroyEngine];
        self.curEngine = nil;
        self.isEngineInited = NO;
        NSLog(@"引擎析构完成");
    }
}

- (void)configInitParams {
    // ===========在线合成
    //【必需配置】Engine Name
    [self.curEngine setStringParam:SE_TTS_ENGINE forKey:SE_PARAMS_KEY_ENGINE_NAME_STRING];
    //【必需配置】Work Mode, 可选值如下
    // SETtsWorkModeOnline, 只进行在线合成，不需要配置离线合成相关参数；
    // SETtsWorkModeOffline, 只进行离线合成，不需要配置在线合成相关参数；
    // SETtsWorkModeBoth, 同时发起在线合成与离线合成，在线请求失败的情况下，使用离线合成数据，该模式会消耗更多系统性能；
    // SETtsWorkModeAlternate, 先发起在线合成，失败后（网络超时），启动离线合成引擎开始合成；
    [self.curEngine setIntParam:SETtsWorkModeOnline forKey:SE_PARAMS_KEY_TTS_WORK_MODE_INT];
    
    //【可选配置】Debug & Log
    [self.curEngine setStringParam:self.debugPath forKey:SE_PARAMS_KEY_DEBUG_PATH_STRING];
    [self.curEngine setStringParam:SE_LOG_LEVEL_DEBUG forKey:SE_PARAMS_KEY_LOG_LEVEL_STRING];

    //【可选配置】User ID（用以辅助定位线上用户问题）
    [self.curEngine setStringParam:SDEF_UID forKey:SE_PARAMS_KEY_UID_STRING];
    [self.curEngine setStringParam:self.deviceID forKey:SE_PARAMS_KEY_DEVICE_ID_STRING];
    
    // ------------------------ 在线合成相关配置 -----------------------
    
    //【必需配置】在线合成鉴权相关：Appid
    [self.curEngine setStringParam:SDEF_APPID forKey:SE_PARAMS_KEY_APP_ID_STRING];

    //【必需配置】在线合成鉴权相关：Token
    [self.curEngine setStringParam:SDEF_TOKEN forKey:SE_PARAMS_KEY_APP_TOKEN_STRING];

    //【必需配置】语音合成服务域名
    [self.curEngine setStringParam:SDEF_DEFAULT_ADDRESS forKey:SE_PARAMS_KEY_TTS_ADDRESS_STRING];

    //【必需配置】语音合成服务Uri
    [self.curEngine setStringParam:SDEF_TTS_DEFAULT_URI forKey:SE_PARAMS_KEY_TTS_URI_STRING];

    //【必需配置】语音合成服务所用集群
    [self.curEngine setStringParam:SDEF_TTS_DEFAULT_CLUSTER forKey:SE_PARAMS_KEY_TTS_CLUSTER_STRING];

    //【可选配置】在线合成下发的 opus-ogg 音频的压缩倍率
    [self.curEngine setIntParam:10 forKey:SE_PARAMS_KEY_TTS_COMPRESSION_RATE_INT];
}

- (void)startEngine {
    NSLog(@"Start engine, current status: %d", self.engineStarted);
    if (!self.isEngineInited) {
        self.engineErrorOccurred = FALSE;

        // Directive：启动引擎前调用SYNC_STOP指令，保证前一次请求结束。
        NSLog(@"关闭引擎（同步）");
        NSLog(@"Directive: SEDirectiveSyncStopEngine");
        SEEngineErrorCode ret = [self.curEngine sendDirective:SEDirectiveSyncStopEngine];
        if (ret != SENoError) {
            NSLog(@"Send directive syncstop failed: %d", ret);
        } else {
            [self configStartTtsParams];

            NSLog(@"启动引擎.");
            NSLog(@"Directive: SEDirectiveStartEngine");
            SEEngineErrorCode ret = [self.curEngine sendDirective:SEDirectiveStartEngine];
            if (SENoError != ret) {
                NSLog(@"send directive start failed, %d", ret);
            }
        }
    } else {
        [self configStartTtsParams];

        NSLog(@"启动引擎.");
        NSLog(@"Directive: SEDirectiveStartEngine");
        SEEngineErrorCode ret = [self.curEngine sendDirective:SEDirectiveStartEngine];
        if (SENoError != ret) {
            NSLog(@"send directive start failed, %d", ret);
        }
    }
}

-(void)configStartTtsParams {
    //【必需配置】TTS 使用场景
    [self.curEngine setStringParam:SE_TTS_SCENARIO_TYPE_NOVEL forKey:SE_PARAMS_KEY_TTS_SCENARIO_STRING];

    // 准备待合成的小说文本
    if(![self prepareNovelText]) {
        char fake_error_info[] = "{err_code:3006, err_msg:\"Invalid input text.\"}";
        [self speechEngineError:[NSData dataWithBytes:fake_error_info length:sizeof(fake_error_info)]];
        return;
    }

    //【可选配置】是否使用 SDK 内置播放器播放合成出的音频，默认为 true
    [self.curEngine setBoolParam:YES
                          forKey:SE_PARAMS_KEY_TTS_ENABLE_PLAYER_BOOL];
    //【可选配置】是否令 SDK 通过回调返回合成的音频数据，默认不返回。
    // 开启后，SDK 会流式返回音频，收到 SETtsAudioData 回调表示当次合成所有的音频已经全部返回
    [self.curEngine setIntParam:SETtsDataCallbackModeAll forKey:SE_PARAMS_KEY_TTS_DATA_CALLBACK_MODE_INT];
}

-(void)configNextTtsParams {
    //【必需配置】TTS 使用场景
    [self.curEngine setStringParam:SE_TTS_SCENARIO_TYPE_NOVEL forKey:SE_PARAMS_KEY_TTS_SCENARIO_STRING];

    // 准备待合成的小说文本
    if(![self prepareNextNovelText]) {
        char fake_error_info[] = "{err_code:3006, err_msg:\"Invalid input text.\"}";
        [self speechEngineError:[NSData dataWithBytes:fake_error_info length:sizeof(fake_error_info)]];
        return;
    }

    //【可选配置】是否使用 SDK 内置播放器播放合成出的音频，默认为 true
    [self.curEngine setBoolParam:YES
                          forKey:SE_PARAMS_KEY_TTS_ENABLE_PLAYER_BOOL];
    //【可选配置】是否令 SDK 通过回调返回合成的音频数据，默认不返回。
    // 开启后，SDK 会流式返回音频，收到 SETtsAudioData 回调表示当次合成所有的音频已经全部返回
    [self.curEngine setIntParam:SETtsDataCallbackModeAll forKey:SE_PARAMS_KEY_TTS_DATA_CALLBACK_MODE_INT];
}

- (void)speechEngineError:(NSData *)data {
    self.engineErrorOccurred = TRUE;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *errorText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", errorText);
        
        BOOL needStop = NO;
        id json_obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([json_obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *error_info = json_obj;
            NSInteger code = [[error_info objectForKey:@"err_code"] intValue];
            switch (code) {
                case SETTSLimitQps:
                case SETTSLimitCount:
                case SETTSServerBusy:
                case SETTSLongText:
                case SETTSInvalidText:
                case SETTSSynthesisTimeout:
                case SETTSSynthesisError:
                case SETTSSynthesisWaitingTimeout:
                case SETTSErrorUnknown:
                    NSLog(@"When meeting this kind of error, continue to synthesize.");
                    [self synthesisNextSentence];
                    break;
                default:
                    needStop = YES;
                    break;
            }
        } else {
            needStop = YES;
        }
        if (needStop) {
            [self.curEngine sendDirective:SEDirectiveStopEngine];
        }
    });
}

-(void)resetTtsContext {
    self.ttsSynthesisIndex = 0;
    self.ttsPlayingIndex = -1;
    self.ttsSynthesisFromPlayer = FALSE;
    [self.ttsSynthesisText removeAllObjects];
    [self.ttsSynthesisMap removeAllObjects];
}

-(BOOL)prepareNovelText {
    [self resetTtsContext];
    NSString *text = [self.dataSource currentSentence];
    if (text.length > 0) {
        // 使用下面几个标点符号来分句，会让通过 MESSAGE_TYPE_TTS_PLAYBACK_PROGRESS 返回的播放进度更加准确
        NSArray* temp = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";!?。！？；…"]];
        for (int j = 0; j < temp.count; ++j) {
            [self addSentence:temp[j]];
        }
    }
    NSLog(@"Synthesis text item num: %ld.", [self.ttsSynthesisText count]);
    return [self.ttsSynthesisText count] > 0;
}

-(BOOL)prepareNextNovelText {
    [self resetTtsSynthesisText];
    NSString *text = [self.dataSource nextSentence];
    if (text.length > 0) {
        // 使用下面几个标点符号来分句，会让通过 MESSAGE_TYPE_TTS_PLAYBACK_PROGRESS 返回的播放进度更加准确
        NSArray* temp = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";!?。！？；…"]];
        for (int j = 0; j < temp.count; ++j) {
            [self addSentence:temp[j]];
        }
    }
    NSLog(@"Synthesis text item num: %ld.", [self.ttsSynthesisText count]);
    return [self.ttsSynthesisText count] > 0;
}

-(void)addSentence:(NSString*) text {
    NSCharacterSet* blankChar = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSString* tmp = [text stringByTrimmingCharactersInSet:blankChar];
    if (tmp.length > 0) {
        [self.ttsSynthesisText addObject:tmp];
    }
}

- (void)synthesisNextSentence {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.ttsSynthesisIndex == [self.ttsSynthesisText count] - 1) {
            // 说明播放完成了，开始合成下一章
            [self configNextTtsParams];
        }
        self.ttsSynthesisIndex = (self.ttsSynthesisIndex + 1) % [self.ttsSynthesisText count];
    
        if (!self.ttsSynthesisFromPlayer) {
            [self triggerSynthesis];
        }
    });
}

- (void)resetTtsSynthesisText {
    int indexSpace = self.ttsSynthesisIndex - self.ttsPlayingIndex;
    NSInteger index = 0;
    while (index < self.ttsPlayingIndex) {
        [self.ttsSynthesisText removeObjectAtIndex:0];
        index++;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in self.ttsSynthesisMap) {
        NSInteger value = [self.ttsSynthesisMap[key] integerValue];
        if (value >= self.ttsPlayingIndex) {
            value = value - self.ttsPlayingIndex;
        }
        dict[key] = @(value);
    }
    self.ttsSynthesisMap = dict;
    self.ttsPlayingIndex = 0;
    self.ttsSynthesisIndex = indexSpace;
}

-(void)triggerSynthesis {
    [self configSynthesisParams];
    // DIRECTIVE_SYNTHESIS 是连续合成必需的一个指令，在成功调用 DIRECTIVE_START_ENGINE 之后，每次合成新的文本需要再调用 DIRECTIVE_SYNTHESIS 指令
    // DIRECTIVE_SYNTHESIS 需要在当前没有正在合成的文本时才可以成功调用，否则就会报错 -901，可以在收到 MESSAGE_TYPE_TTS_SYNTHESIS_END 之后调用
    // 当使用 SDK 内置的播放器时，为了避免缓存过多的音频导致内存占用过高，SDK 内部限制缓存的音频数量不超过 5 次合成的结果，
    // 如果 DIRECTIVE_SYNTHESIS 后返回 -902, 就需要在下一次收到 MESSAGE_TYPE_TTS_FINISH_PLAYING 再去调用 MESSAGE_TYPE_TTS_FINISH_PLAYING
    NSLog(@"触发合成");
    NSLog(@"Directive: DIRECTIVE_SYNTHESIS");
    SEEngineErrorCode ret = [self.curEngine sendDirective:SEDirectiveSynthesis];
    if (ret != SENoError) {
        NSLog(@"Synthesis faile: %d", ret);
        if (ret == SESynthesisPlayerIsBusy) {
            self.ttsSynthesisFromPlayer = TRUE;
        }
    } else {
        NSLog(@"合成成功：%d", ret);
    }
}

- (void)configSynthesisParams {
    NSString* text = self.ttsSynthesisText[self.ttsSynthesisIndex];
    NSLog(@"Synthesis: %d, text: %@", self.ttsSynthesisIndex, text);
    //【必需配置】需合成的文本，不可超过 80 字
    [self.curEngine setStringParam:text forKey:SE_PARAMS_KEY_TTS_TEXT_STRING];
    //【可选配置】需合成的文本的类型，支持直接传文本(TTS_TEXT_TYPE_PLAIN)和传 SSML 形式(TTS_TEXT_TYPE_SSML)的文本
    [self.curEngine setStringParam:@"TTS_TEXT_TYPE_PLAIN" forKey:SE_PARAMS_KEY_TTS_TEXT_TYPE_STRING];
    //【可选配置】用于控制 TTS 音频的语速，支持的配置范围参考火山官网 语音技术/语音合成/离在线语音合成SDK/参数说明 文档
    [self.curEngine setIntParam:10 forKey:SE_PARAMS_KEY_TTS_SPEED_INT];
    //【可选配置】用于控制 TTS 音频的音量，支持的配置范围参考火山官网 语音技术/语音合成/离在线语音合成SDK/参数说明 文档
    [self.curEngine setIntParam:10 forKey:SE_PARAMS_KEY_TTS_VOLUME_INT];
    //【可选配置】用于控制 TTS 音频的音高，支持的配置范围参考火山官网 语音技术/语音合成/离在线语音合成SDK/参数说明 文档
    [self.curEngine setIntParam:10 forKey:SE_PARAMS_KEY_TTS_PITCH_INT];
    //【可选配置】是否在文本的每句结尾处添加静音段，单位：毫秒，默认为 0ms
    [self.curEngine setIntParam:0 forKey:SE_PARAMS_KEY_TTS_SILENCE_DURATION_INT];

    // ------------------------ 在线合成相关配置 -----------------------
    //【必需配置】在线合成使用的发音人代号
    NSString *voice = [USReaderSpeechConfig sharedConfig].currentSpeaker.voice?:SDEF_TTS_DEFAULT_ONLINE_VOICE;
    NSString *key = [USReaderSpeechConfig sharedConfig].currentSpeaker.key?:SDEF_TTS_DEFAULT_ONLINE_VOICE_TYPE;
    [self.curEngine setStringParam:voice forKey:SE_PARAMS_KEY_TTS_VOICE_ONLINE_STRING];
    //【必需配置】在线合成使用的音色代号
    [self.curEngine setStringParam:key forKey:SE_PARAMS_KEY_TTS_VOICE_TYPE_ONLINE_STRING];
    //【可选配置】是否打开在线合成的服务端缓存，默认关闭
    [self.curEngine setBoolParam:NO forKey:SE_PARAMS_KEY_TTS_ENABLE_CACHE_BOOL];
    //【可选配置】指定在线合成的语种，默认为空，即不指定
    [self.curEngine setStringParam:@"" forKey:SE_PARAMS_KEY_TTS_LANGUAGE_ONLINE_STRING];
    //【可选配置】是否启用在线合成的情感预测功能
    [self.curEngine setBoolParam:YES forKey:SE_PARAMS_KEY_TTS_WITH_INTENT_BOOL];
    //【可选配置】指定在线合成的情感，例如 happy, sad 等
    [self.curEngine setStringParam:@"" forKey:SE_PARAMS_KEY_TTS_EMOTION_STRING];
    //【可选配置】需要返回详细的播放进度时应配置为 1, 否则配置为 0 或不配置
    [self.curEngine setIntParam:1 forKey:SE_PARAMS_KEY_TTS_WITH_FRONTEND_INT];
    //【可选配置】需要返回字粒度的播放进度时应配置为 simple, 同时要求 PARAMS_KEY_TTS_WITH_FRONTEND_INT 也配置为 1; 默认为空
    [self.curEngine setStringParam:@"sample" forKey:SE_PARAMS_KEY_TTS_FRONTEND_TYPE_STRING];
    //【可选配置】使用复刻音色
    [self.curEngine setBoolParam:YES forKey:SE_PARAMS_KEY_TTS_USE_VOICECLONE_BOOL];
    //【可选配置】在开启前述使用复刻音色的开关后，制定复刻音色所用的后端集群
    [self.curEngine setStringParam:@"" forKey:SE_PARAMS_KEY_TTS_BACKEND_CLUSTER_STRING];
}

#pragma mark - SpeechEngineDelegate
/// Callback of speech engine.
/// @param type Message type, SEMessageType, defined in SpeechEngineDefines.h.
/// @param data Message data, should be processed according to the message type.
- (void)onMessageWithType:(SEMessageType)type andData:(NSData *)data {
    NSLog(@"Message Type: %d.", type);
    switch (type) {
        case SEEngineStart:
            NSLog(@"Callback: 引擎启动成功: data: %@", data);
//            [self speechEngineStarted];
            break;
        case SEEngineStop:
            NSLog(@"Callback: 引擎关闭: data: %@", data);
//            [self speechEngineStopped];
            break;
        case SEEngineError:
            NSLog(@"Callback: 错误信息: %@", data);
            [self speechEngineError:data];
            break;
        case SETtsSynthesisBegin:
            NSLog(@"Callback: 合成开始: %@", data);
            [self speechStartSynthesis:data];
            break;
        case SETtsSynthesisEnd:
            NSLog(@"Callback: 合成结束: %@", data);
            [self speechFinishSynthesis:data];
            break;
        case SETtsStartPlaying:
            NSLog(@"Callback: 播放开始: %@", data);
            [self speechStartPlaying:data];
            break;
        case SETtsPlaybackProgress:
            NSLog(@"Callback: 播放进度");
            [self updatePlayingProgress:data];
            break;
        case SETtsFinishPlaying:
            NSLog(@"Callback: 播放结束: %@", data);
            [self speechFinishPlaying:data];
            break;
        case SETtsAudioData:
            NSLog(@"Callback: 音频数据，长度 %lu 字节", (unsigned long)data.length);
//            [self speechTtsAudioData:data];
            break;
        default:
            break;
    }
}

- (void)speechStartPlaying:(NSData *)data {
    NSString* playingId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"TTS start playing: %@", playingId);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStart:)]) {
            [self.delegate TTSBaseEngineDidStart:self];
        }
    });
}

- (void)speechFinishPlaying :(NSData *)data {
    NSString* playingId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"TTS finish playing: %@", playingId);
    [self.ttsSynthesisMap removeObjectForKey:playingId];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ttsPlayingProgress = 1.0;
        [self updateTtsResultText:playingId];
    });
    if (self.ttsSynthesisFromPlayer) {
        [self triggerSynthesis];
        self.ttsSynthesisFromPlayer = FALSE;
    } else if (self.ttsSynthesisMap.allKeys.count == 0) {
        // 说明播放完成了，开始合成下一章
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configNextTtsParams];
            [self synthesisNextSentence];
        });
    }
}

- (void)speechStartSynthesis:(NSData *)data {
    if (self.ttsSynthesisIndex < [self.ttsSynthesisText count]) {
        NSString* req_id = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.ttsSynthesisMap setValue:[NSNumber numberWithInt:self.ttsSynthesisIndex] forKey:req_id];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateTtsResultText:@""];
    });
}

- (void)speechFinishSynthesis:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self synthesisNextSentence];
    });
}

- (void)updatePlayingProgress :(NSData *)data {
    if (data != nil) {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        if(error) {
            NSLog(@"Parse data as json error!");
            return ;
        }
        if([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *results = object;
            float percentage = [[results valueForKey:@"progress"] floatValue];
            NSString *reqid = [results valueForKey:@"reqid"];
            NSLog(@"playing id: %@, progress in percent: %.2f", reqid, percentage);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ttsPlayingProgress = percentage;
                [self updateTtsResultText:reqid];
            });
        }
    }
}

// 根据 SDK 返回的播放进度高亮正在播放的文本，用红色表示
// 根据 SDK 返回的合成开始和合成结束回调高亮正在合成的文本，用蓝色表示
-(void)updateTtsResultText:(NSString*) playingId {
    NSNumber* val = [self.ttsSynthesisMap objectForKey:playingId];
    if (val != nil) {
        self.ttsPlayingIndex = [val intValue];
    }
    
    int beginIndex = MAX(self.ttsPlayingIndex, 0);
    int maxSentencesDisplayed = MIN((int)[self.ttsSynthesisText count], 4);
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithString:@""];
    for (int cnt = 0; cnt < maxSentencesDisplayed; ++cnt) {
        int index = (beginIndex + cnt) % [self.ttsSynthesisText count];
        NSString* current_sentence = self.ttsSynthesisText[index];
        NSInteger playedPosition = 0;
        if (index == self.ttsPlayingIndex) {
            playedPosition = MIN(ceil((double)(self.ttsPlayingProgress) * (double)([current_sentence length])), [current_sentence length]);
            NSLog(@"played position: %ld", (long)playedPosition);
            NSString* playedString = [current_sentence substringToIndex:playedPosition];
            NSAttributedString* playedSpan = [[NSAttributedString alloc] initWithString:playedString attributes:[NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName]];
            [resultStr appendAttributedString:playedSpan];
        }
        NSString* remainString = [current_sentence substringFromIndex:playedPosition];
        NSAttributedString* span = [[NSAttributedString alloc] initWithString:remainString attributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [resultStr appendAttributedString:span];
    }
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngine:readText:)]) {
        [self.delegate TTSBaseEngine:self readText:resultStr];
    }
}

#pragma mark - public
- (void)start {
    [self initEngine];
    [self startEngine];
    [self triggerSynthesis];
}

- (void)stop {
    NSLog(@"停止播放");
    [self.curEngine sendDirective:SEDirectiveStopEngine];
    [self deinitEngine];
    [self resetTtsContext];
}

- (void)pause {
    NSLog(@"暂停播放");
    NSLog(@"Directive: SEDirectivePausePlayer");
    SEEngineErrorCode ret = [self.curEngine sendDirective:SEDirectivePausePlayer];
    if (ret == SENoError) {
        NSLog(@"可以回调");
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidPause:)]) {
            [self.delegate TTSBaseEngineDidPause:self];
        }
    }
    NSLog(@"Pause playback status: %d", ret);
}

- (void)resume {
    NSLog(@"继续播放");
    NSLog(@"Directive: SEDirectiveResumePlayer");
    SEEngineErrorCode ret = [self.curEngine sendDirective:SEDirectiveResumePlayer];
    if (ret == SENoError) {
        NSLog(@"可以回调");
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidResume:)]) {
            [self.delegate TTSBaseEngineDidResume:self];
        }
    }
    NSLog(@"Resume playback status: %d", ret);
}

@end
