//
//  TTSIFlyCloudEngine.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "TTSIFlyCloudEngine.h"
#import "USReaderSpeechConfig.h"
#import <iflyMSC/IFlyMSC.h>

@implementation TTSIFlyCloudEngine

- (void)changeToCloud {
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

- (void)start {
    [self changeToCloud];
    [super start];
}

@end
