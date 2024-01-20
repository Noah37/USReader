//
//  TTSIFlyOfflineEngine.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "TTSIFlyOfflineEngine.h"
#import "USReaderSpeechConfig.h"
#import <iflyMSC/IFlyMSC.h>

@interface TTSIFlyOfflineEngine ()

@end

@implementation TTSIFlyOfflineEngine

- (void)changeToLocal {
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

- (void)start {
    [self changeToLocal];
    [super start];
}

@end
