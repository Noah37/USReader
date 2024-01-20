//
//  USReaderSpeechConfig.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import <Foundation/Foundation.h>
#import "USReaderSpeaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderSpeechConfig : NSObject

/// 默认50
@property (nonatomic, assign) CGFloat speed;
/// 默认50
@property (nonatomic, assign) CGFloat volume;
/// 默认50
@property (nonatomic, assign, readonly) CGFloat pitch;
/// 默认16000
@property (nonatomic, assign, readonly) CGFloat sampleRate;
/// xiaoyu
@property (nonatomic, copy) NSString *vcnName;
/// the engine type of Text-to-Speech:"auto","local","cloud"
@property (nonatomic, copy) NSString *engineType;
/// 51200
@property (nonatomic, copy, readonly) NSString *voiceID;

@property (nonatomic, copy, readonly) NSString *fileName;

@property (nonatomic, copy, readonly) NSString *ttsResPath;

@property (nonatomic, copy, readonly) NSString *unicode;

@property (nonatomic, copy, readonly) NSString *commonPath;

/// 发音人下载目录
@property (nonatomic, copy, readonly) NSString *filePath;
/// 发音人
@property (nonatomic, copy, readonly) NSString *speakersPath;

@property (nonatomic, copy, readonly) NSString *xfyjAppId;

@property (nonatomic, copy, readonly) NSString *xfyjCloudAppId;

@property (nonatomic, copy, readonly) NSString *xfyjLocalAppId;

@property (nonatomic, copy, readonly) NSString *testText;

/// 所有离线发音人
@property (nonatomic, copy, readonly) NSArray <USReaderSpeaker *>*speakerModels;
/// 所有在线发音人
@property (nonatomic, copy, readonly) NSArray <USReaderSpeaker *>*cloudSpeakerModels;

/// 火山引擎在线与离线发音人
@property (nonatomic, copy, readonly) NSArray <USReaderSpeaker *>*hsCloudSpeakerModels;
@property (nonatomic, copy, readonly) NSArray <USReaderSpeaker *>*hsOfflineSpeakerModels;

@property (nonatomic, copy, readonly) NSArray <USReaderSpeaker *>*cloudSpeakers;
@property (nonatomic, copy, readonly) NSArray <USReaderSpeaker *>*offlineSpeakers;

/// 当前选中的发音人
@property (nonatomic, strong) USReaderSpeaker *currentSpeaker;


+ (instancetype)sharedConfig;

- (NSArray <USReaderSpeaker *>*)cloudSpeakers;
- (NSArray <USReaderSpeaker *>*)offlineSpeakers;

@end

NS_ASSUME_NONNULL_END
