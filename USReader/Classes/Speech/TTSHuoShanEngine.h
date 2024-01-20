//
//  TTSHuoShanEngine.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "TTSBaseEngine.h"
#import <SpeechEngineTtsToB/SpeechEngineTtsToB-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTSHuoShanEngine : TTSBaseEngine<SpeechEngineDelegate>

// SpeechEngine
@property (strong, nonatomic, readonly) SpeechEngine *curEngine;

@end

NS_ASSUME_NONNULL_END
