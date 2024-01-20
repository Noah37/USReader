//
//  TTSIFlyEngine.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import <Foundation/Foundation.h>
#import "TTSBaseEngine.h"

NS_ASSUME_NONNULL_BEGIN

@class IFlySpeechSynthesizer;
@interface TTSIFlyEngine : TTSBaseEngine

@property (nonatomic, strong, readonly) IFlySpeechSynthesizer *iflySpeechSynthesizer;

@end

NS_ASSUME_NONNULL_END
