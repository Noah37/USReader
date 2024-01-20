//
//  TTSEngineManager.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/9.
//

#import <Foundation/Foundation.h>
#import "TTSBaseEngine.h"
#import "USReaderSpeaker.h"

@protocol TTSEngineDataSource <TTSBaseEngineDataSource>

- (TTSEngineType)engineType;

@end

NS_ASSUME_NONNULL_BEGIN

/// 处理多个engine同时存在
@interface TTSEngineManager : NSObject

+ (instancetype)sharedManager;

- (void)startWithDataSource:(id<TTSEngineDataSource>)dataSource delegate:(id<TTSBaseEngineDelegate>)delegate;
- (void)stop;
- (void)pause;
- (void)resume;
@end

NS_ASSUME_NONNULL_END
