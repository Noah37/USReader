//
//  TTSIFlyEngine.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "TTSIFlyEngine.h"
#import <iflyMSC/IFlyMSC.h>

@interface TTSIFlyEngine ()<IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer *iflySpeechSynthesizer;

@end

@implementation TTSIFlyEngine

- (void)start:(NSString *)sentence {
    [self.iflySpeechSynthesizer startSpeaking:sentence];
}

#pragma mark - public
- (void)start {
    NSString *currentSentence = [self.dataSource currentSentence];
    [self start:currentSentence];
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

#pragma mark - IFlySpeechSynthesizerDelegate

/*!
 *  结束回调<br>
 *  当整个合成结束之后会回调此函数
 *
 *  @param error 错误码
 */
- (void) onCompleted:(IFlySpeechError*) error {
    if (error.errorCode > 0) {
        NSLog(@"播放失败：%d, msg:%@", error.errorCode, error.errorDesc);
        return;
    }
    NSString *nextSentence = [self.dataSource nextSentence];
    if (nextSentence.length > 0) {
        [self start:nextSentence];
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStart:)]) {
            [self.delegate TTSBaseEngineDidStart:self];
        }
    } else {
        [self stop];
        if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStop:)]) {
            [self.delegate TTSBaseEngineDidStop:self];
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechCompletedNotification object:error];
}

/*!
 *  开始合成回调
 */
- (void) onSpeakBegin {
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechBeginNotification object:nil];
}

/*!
 *  缓冲进度回调
 *
 *  @param progress 缓冲进度，0-100
 *  @param msg      附件信息，此版本为nil
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg {
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechBufferProgressNotification object:nil];
}

/*!
 *  播放进度回调
 *
 *  @param progress 当前播放进度，0-100
 *  @param beginPos 当前播放文本的起始位置（按照字节计算），对于汉字(2字节)需／2处理
 *  @param endPos 当前播放文本的结束位置（按照字节计算），对于汉字(2字节)需／2处理
 */
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakProgressNotification object:nil];
}

/*!
 *  暂停播放回调
 */
- (void) onSpeakPaused {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidPause:)]) {
        [self.delegate TTSBaseEngineDidPause:self];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakPauseNotification object:nil];
}

/*!
 *  恢复播放回调<br>
 *  注意：此回调方法SDK内部不执行，播放恢复全部在onSpeakBegin中执行
 */
- (void) onSpeakResumed {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidResume:)]) {
        [self.delegate TTSBaseEngineDidResume:self];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakResumeNotification object:nil];
}

/*!
 *  正在取消回调<br>
 *  注意：此回调方法SDK内部不执行
 */
- (void) onSpeakCancel {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStop:)]) {
        [self.delegate TTSBaseEngineDidStop:self];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:USReaderSpeechSpeakCancelNotification object:nil];
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
    if (!_iflySpeechSynthesizer) {
        IFlySpeechSynthesizer *speech = [IFlySpeechSynthesizer sharedInstance];
        speech.delegate = self;
        _iflySpeechSynthesizer = speech;
    }
    return _iflySpeechSynthesizer;
}

@end
