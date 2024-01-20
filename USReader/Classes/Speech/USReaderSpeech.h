//
//  USReaderSpeech.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechCompletedNotification;
FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechBeginNotification;
FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechBufferProgressNotification;
FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechSpeakProgressNotification;
FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechSpeakCancelNotification;
FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechSpeakPauseNotification;
FOUNDATION_EXPORT NSString * _Nonnull const USReaderSpeechSpeakResumeNotification;

NS_ASSUME_NONNULL_BEGIN

@class USReaderSpeaker;
@interface USReaderSpeech : NSObject

+ (instancetype)sharedSpeech;

- (void)startSpeak:(NSString *)sentence;
- (void)start:(NSString *)sentence;
- (void)startLocal:(NSString *)sentence;
- (void)stop;
- (void)resume;
- (void)pause;

/// 保存音频文件
- (void)saveUri;
/// 是否正在语音
- (BOOL)isSpeaking;
/// 保存音频文件
- (void)saveUriWithText:(NSString *)text path:(NSString *)path;

/// 播放本地保存的音频文件
- (void)playUri;

/// 设置发音人
- (void)setSpeaker:(USReaderSpeaker *)speaker;

/// 设置发音人
- (void)setVcn:(NSString *)name;

/// 语音合成引擎变更为离线
- (void)engineLocal;

/// 语音合成引擎变更为云端
- (void)engineCloud;

/// 音量范围 0-100
- (void)volumeChange:(NSInteger)volume;
- (void)speedChange:(NSInteger)speed;

@end

NS_ASSUME_NONNULL_END
