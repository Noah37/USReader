//
//  TTSBaseEngine.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import <Foundation/Foundation.h>

@class TTSBaseEngine;
@protocol TTSBaseEngineDataSource <NSObject>

- (NSString *_Nullable)currentSentence;
- (NSString *_Nullable)nextSentence;
- (NSString *_Nullable)previousSentence;

@end

@protocol TTSBaseEngineDelegate <NSObject>

/// 回调当前正在阅读的文本
- (void)TTSBaseEngine:(TTSBaseEngine *_Nullable)engine readText:(NSAttributedString *_Nullable)text;
/// 回调当前状态
- (void)TTSBaseEngineDidStart:(TTSBaseEngine *_Nullable)engine;
/// 回调当前状态
- (void)TTSBaseEngineDidStop:(TTSBaseEngine *_Nullable)engine;
/// 回调当前状态
- (void)TTSBaseEngineDidPause:(TTSBaseEngine *_Nullable)engine;
/// 回调当前状态
- (void)TTSBaseEngineDidResume:(TTSBaseEngine *_Nullable)engine;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTSBaseEngine : NSObject

@property (nonatomic, assign) BOOL isEngineInited;
@property (assign, nonatomic) BOOL engineStarted;
@property (assign, nonatomic) BOOL engineErrorOccurred;
@property (nonatomic, assign) BOOL isPausePalyer;

@property (nonatomic, copy, readonly) NSString *sentence;

@property (nonatomic, weak) id <TTSBaseEngineDataSource>dataSource;

@property (nonatomic, weak) id <TTSBaseEngineDelegate>delegate;

- (void)start;
- (void)stop;
- (void)resume;
- (void)pause;

- (void)changeToLocal;
- (void)changeToCloud;

- (void)volumeChange:(NSInteger)volume;

- (void)speedChange:(NSInteger)speed;

@end

NS_ASSUME_NONNULL_END
