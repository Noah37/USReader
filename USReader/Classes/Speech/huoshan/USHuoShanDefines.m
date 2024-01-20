//
//  USHuoShanDefines.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "USHuoShanDefines.h"

// User Info
NSString * const SDEF_UID = @"659a8ab4854b2d8d002dd205";

// Online & Resource Authentication
NSString * const SDEF_APPID = @"77rrpjzn8qck";
NSString * const SDEF_TOKEN = @"Bearer; 14JRmxRBEHcK9lUdNHu0x2cB-Vw3IhQk";

// Offline Authentication
NSString * const SDEF_LICENSE_NAME = @"taixuan_ios_ZhuiShuShenQi";
NSString * const SDEF_LICENSE_BUSI_ID = @"501091";

// Address
NSString * const SDEF_DEFAULT_ADDRESS = @"wss://openspeech.bytedance.com";
NSString * const SDEF_DEFAULT_HTTP_ADDRESS = @"https://openspeech.bytedance.com";

// TTS
NSString * const SDEF_TTS_DEFAULT_URI = @"/api/v1/tts/ws_binary";
NSString * const SDEF_TTS_DEFAULT_CLUSTER = @"enterprise_streaming";
NSString * const SDEF_TTS_DEFAULT_ONLINE_VOICE = @"BV102Narrator";
NSString * const SDEF_TTS_DEFAULT_ONLINE_VOICE_TYPE = @"BV102_streaming";
NSString * const SDEF_TTS_DEFAULT_OFFLINE_VOICE = @"BV102Narrator";
NSString * const SDEF_TTS_DEFAULT_OFFLINE_VOICE_TYPE = @"BV102_streaming";
NSString * const SDEF_TTS_DEFAULT_ONLINE_LANGUAGE = @"zh-cn";
NSString * const SDEF_TTS_DEFAULT_OFFLINE_LANGUAGE = @"zh-cn";
const NSArray* SDEF_TTS_DEFAULT_DOWNLOAD_OFFLINE_VOICES() { return @[]; }

// ASR
NSString * const SDEF_ASR_DEFAULT_CLUSTER = @"YOUR ASR CLUSTER";
NSString * const SDEF_ASR_DEFAULT_URI = @"/api/v2/asr";

// VoiceClone
NSString * const SDEF_VOICECLONE_DEFAULT_UIDS = @"uid_1;uid_2";
int SDEF_VOICECLONE_DEFAULT_TASK_ID = -1;

// VoiceConv
NSString * const SDEF_VOICECONV_DEFAULT_URI = @"/api/v1/voice_conv/ws";

@implementation USHuoShanDefines

@end
