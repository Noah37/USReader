//
//  USHuoShanSpeech.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/8.
//

#import "USHuoShanSpeech.h"
#import <SpeechEngineTtsToB/SpeechEngineDefines.h>
#import <SpeechEngineTtsToB/SpeechEngine.h>
#import <SpeechEngineTtsToB/SpeechResourceManager.h>
#import "USHuoShanDefines.h"

@interface USHuoShanSpeech ()<SpeechEngineDelegate>

@property(nonatomic, strong) NSString *deviceID;
// Debug Path: 用于存放一些 SDK 相关的文件，比如模型、日志等
@property (strong, nonatomic) NSString *debugPath;

// SpeechEngine
@property (strong, nonatomic) SpeechEngine *curEngine;

// Engine State
@property (assign, nonatomic) BOOL engineInited;
@property (assign, nonatomic) BOOL engineStarted;
@property (assign, nonatomic) BOOL engineErrorOccurred;

@end

@implementation USHuoShanSpeech

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSpeech];
    }
    return self;
}

+ (instancetype)sharedSpeech {
    static dispatch_once_t onceToken;
    static USHuoShanSpeech *speech;
    dispatch_once(&onceToken, ^{
        speech = [[USHuoShanSpeech alloc] init];
    });
    return speech;
}

- (void)setupSpeech {
    UIDevice *device = [UIDevice currentDevice];
    self.deviceID = [[device identifierForVendor] UUIDString];
 
    // 完成网络环境等相关依赖配置，只需要调用一次。
    BOOL status = [SpeechEngine prepareEnvironment];
    if (status) {
        [self setupResourceManager];
    }
}

- (void)setupResourceManager {
    NSLog(@"初始化模型资源管理器");
    SpeechResourceManager *speechResourceManager = [SpeechResourceManager shareInstance];
    [speechResourceManager setAppId:SDEF_APPID];
    [speechResourceManager setAppVersion:@"4.79.0"];
    [speechResourceManager setDeviceId:self.deviceID];
    [speechResourceManager setRootPath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"models"]];
    [speechResourceManager setOnlineModelEnable:YES];
    [speechResourceManager setup];
}

- (void)initHuoShanEngineWithMode:(SETtsWorkMode)mode {
    if (self.curEngine == nil) {
        self.curEngine = [[SpeechEngine alloc] init];
        if (![self.curEngine createEngineWithDelegate:self]) {
            NSLog(@"引擎创建失败.");
            return;
        }
    }
    NSLog(@"SDK 版本号: %@", [self.curEngine getVersion]);
    if (mode == SETtsWorkModeOnline || mode == SETtsWorkModeFile) {
        [self initOnlineHuoShanEngine];
    } else {
        
    }
}

- (void)initOnlineHuoShanEngine {
    NSLog(@"配置初始化参数");
    [self configInitParams];

    NSLog(@"引擎初始化");
    SEEngineErrorCode ret = [self.curEngine initEngine];
    self.engineInited = (ret == SENoError);
    if (self.engineInited) {
        NSLog(@"初始化成功");
        
    } else {
        NSLog(@"初始化失败，返回值: %d", ret);
        [self uninitEngine];
    }
}

- (void)initOfflineHuoShanEngine {
    
}

- (void)uninitEngine {
    if (self.curEngine != nil) {
        NSLog(@"引擎析构");
        [self.curEngine destroyEngine];
        self.curEngine = nil;
        NSLog(@"引擎析构完成");
    }
}

-(void)configInitParams {
    
    [self.curEngine setStringParam:@"FATAL" forKey:@"log_level"];
    [self.curEngine setStringParam:self.debugPath forKey:@"debug_path"];
    [self.curEngine setStringParam:@"77rrpjzn8qck" forKey:@"appid"];
    [self.curEngine setStringParam:@"Bearer; 14JRmxRBEHcK9lUdNHu0x2cB-Vw3IhQk" forKey:@"token"];
    [self.curEngine setStringParam:@"659a8ab4854b2d8d002dd205" forKey:@"uid"];
    [self.curEngine setStringParam:@"pre_bind" forKey:@"authenticate_type"];
    [self.curEngine setStringParam:@"taixuan_ios_ZhuiShuShenQi" forKey:@"license_name"];
    //【必需配置】离线合成鉴权相关：证书文件存放路径
    [self.curEngine setStringParam:self.debugPath forKey:SE_PARAMS_KEY_LICENSE_DIRECTORY_STRING];
    [self.curEngine setStringParam:@"wss://openspeech.bytedance.com" forKey:@"tts_address"];
    [self.curEngine setStringParam:@"/api/v1/tts/ws_binary" forKey:@"tts_uri"];
    [self.curEngine setStringParam:@"enterprise_streaming" forKey:@"tts_cluster"];
    [self.curEngine setStringParam:@"tts" forKey:@"engine_name"];
    [self.curEngine setStringParam:@"novel" forKey:@"tts_scenario"];
    [self.curEngine setStringParam:@"2048" forKey:@"tts_work_mode"];
    [self.curEngine setStringParam:@"10" forKey:@"tts_compression_rate"];
    [self.curEngine setStringParam:@"10" forKey:@"tts_rate"];
    [self.curEngine setStringParam:@"10" forKey:@"tts_speed"];
    [self.curEngine setStringParam:@"300" forKey:@"tts_silence_duration"];
    [self.curEngine setStringParam:@"1" forKey:@"tts_with_frontend"];
    [self.curEngine setStringParam:@"BV102_streaming" forKey:@"tts_voice_type_offline"];
    [self.curEngine setStringParam:@"BV102Narrator" forKey:@"tts_voice_offline"];

    
    //【必需配置】Engine Name
//    [self.curEngine setStringParam:SE_TTS_ENGINE forKey:SE_PARAMS_KEY_ENGINE_NAME_STRING];

    //【必需配置】Work Mode, 可选值如下
    // SETtsWorkModeOnline, 只进行在线合成，不需要配置离线合成相关参数；
    // SETtsWorkModeOffline, 只进行离线合成，不需要配置在线合成相关参数；
    // SETtsWorkModeBoth, 同时发起在线合成与离线合成，在线请求失败的情况下，使用离线合成数据，该模式会消耗更多系统性能；
    // SETtsWorkModeAlternate, 先发起在线合成，失败后（网络超时），启动离线合成引擎开始合成；
//    [self.curEngine setIntParam:[self getTtsWorkMode] forKey:SE_PARAMS_KEY_TTS_WORK_MODE_INT];
    
    [self.curEngine setIntParam:SETtsWorkModeOffline forKey:SE_PARAMS_KEY_TTS_WORK_MODE_INT];

//
//    //【可选配置】Debug & Log
//    [self.curEngine setStringParam:self.debugPath forKey:SE_PARAMS_KEY_DEBUG_PATH_STRING];
//    [self.curEngine setStringParam:SE_LOG_LEVEL_DEBUG forKey:SE_PARAMS_KEY_LOG_LEVEL_STRING];
//
//    //【可选配置】User ID（用以辅助定位线上用户问题）
//    [self.curEngine setStringParam:SDEF_UID forKey:SE_PARAMS_KEY_UID_STRING];
//    [self.curEngine setStringParam:self.deviceID forKey:SE_PARAMS_KEY_DEVICE_ID_STRING];
//
//    //【可选配置】是否将合成出的音频保存到设备上，为 true 时需要正确配置 PARAMS_KEY_TTS_AUDIO_PATH_STRING 才会生效
//    [self.curEngine setBoolParam:[self.settings getBool:SETTING_TTS_ENABLE_DUMP]
//                          forKey:SE_PARAMS_KEY_TTS_ENABLE_DUMP_BOOL];
//    // TTS 音频文件保存目录，必须在合成之前创建好且 APP 具有访问权限，保存的音频文件名格式为 tts_{reqid}.wav, {reqid} 是本次合成的请求 id
//    // PARAMS_KEY_TTS_ENABLE_DUMP_BOOL 配置为 true 的音频时为【必需配置】，否则为【可选配置】
//    [self.curEngine setStringParam:self.debugPath forKey:SE_PARAMS_KEY_TTS_AUDIO_PATH_STRING];
//
//    //【可选配置】合成出的音频的采样率，默认为 24000
//    [self.curEngine setIntParam:[self.settings getInt:SETTING_TTS_SAMPLE_RATE] forKey:SE_PARAMS_KEY_TTS_SAMPLE_RATE_INT];
//    //【可选配置】打断播放时使用多长时间淡出停止，单位：毫秒。默认值 0 表示不淡出
//    [self.curEngine setIntParam:[self.settings getInt:SETTING_AUDIO_FADEOUT_DURATION] forKey:SE_PARAMS_KEY_AUDIO_FADEOUT_DURATION_INT];
//
//    // ------------------------ 在线合成相关配置 -----------------------
//
//    NSString* appid = [self.settings getString:SETTING_APPID];
//    self.ttsAppId = appid.length > 0 ? appid : SDEF_APPID;
//    //【必需配置】在线合成鉴权相关：Appid
//    [self.curEngine setStringParam:self.ttsAppId forKey:SE_PARAMS_KEY_APP_ID_STRING];
//
//    NSString* token = [self.settings getString:SETTING_TOKEN];
//    NSString* ttsAppToken = token.length > 0 ? token : SDEF_TOKEN;
//    //【必需配置】在线合成鉴权相关：Token
//    [self.curEngine setStringParam:ttsAppToken forKey:SE_PARAMS_KEY_APP_TOKEN_STRING];
//
//    //【必需配置】语音合成服务域名
//    NSString *address = [self.settings getString:SETTING_ADDRESS];
//    NSString *ttsAddress = address.length > 0 ? address : SDEF_DEFAULT_ADDRESS;
//    [self.curEngine setStringParam:ttsAddress forKey:SE_PARAMS_KEY_TTS_ADDRESS_STRING];
//
//    //【必需配置】语音合成服务Uri
//    NSString *uri = [self.settings getString:SETTING_URI];
//    NSString *ttsUri = uri.length > 0 ? uri : SDEF_TTS_DEFAULT_URI;
//    [self.curEngine setStringParam:ttsUri forKey:SE_PARAMS_KEY_TTS_URI_STRING];
//
//    //【必需配置】语音合成服务所用集群
//    NSString *cluster = [self.settings getString:SETTING_CLUSTER];
//    [self.curEngine setStringParam:cluster forKey:SE_PARAMS_KEY_TTS_CLUSTER_STRING];
//
//    //【可选配置】在线合成下发的 opus-ogg 音频的压缩倍率
//    [self.curEngine setIntParam:10 forKey:SE_PARAMS_KEY_TTS_COMPRESSION_RATE_INT];
//
//    // ------------------------ 离线合成相关配置 -----------------------
//
//    if ([self getTtsWorkMode] != SETtsWorkModeOnline && [self getTtsWorkMode] != SETtsWorkModeFile) {
        NSString* resourcePath = @"";
//        if ([[self.settings getOptionsValue:SETTING_TTS_OFFLINE_RESOURCE_FORMAT] isEqual: @"SingleVoice"]) {
//            resourcePath = [[SpeechResourceManager shareInstance] getModelPath];
//        } else if ([[self.settings getOptionsValue:SETTING_TTS_OFFLINE_RESOURCE_FORMAT] isEqual: @"MultipleVoice"]) {
//            NSString *model_name = [self.settings getString:SETTING_TTS_MODEL_NAME];
            resourcePath = [[SpeechResourceManager shareInstance] getModelPath:@"aispeech_tts"];
//        }
        NSLog(@"TTS resource root path: %@", resourcePath);
        //【必需配置】离线合成所需资源存放路径
        [self.curEngine setStringParam:resourcePath forKey:SE_PARAMS_KEY_TTS_OFF_RESOURCE_PATH_STRING];
//    }
//
//    //【必需配置】离线合成鉴权相关：证书文件存放路径
//    [self.curEngine setStringParam:self.debugPath forKey:SE_PARAMS_KEY_LICENSE_DIRECTORY_STRING];
//    NSString* authenticationType = [self getAuthenticationType];
//    //【必需配置】Authenticate Type
//    [self.curEngine setStringParam:authenticationType forKey:SE_PARAMS_KEY_AUTHENTICATE_TYPE_STRING];
//    if ([authenticationType isEqualToString:SE_AUTHENTICATE_TYPE_PRE_BIND]) {
//        // 按包名授权，获取到授权的 APP 可以不限次数、不限设备数的使用离线合成
//        NSString *licenseName = [self.settings getString:SETTING_TTS_LICENSE_NAME];
//        NSString *licenseBusiId = [self.settings getString:SETTING_TTS_LICENSE_BUSI_ID];
//        // 证书名和业务 ID, 离线合成鉴权相关，使用火山提供的证书下发服务时为【必需配置】, 否则为【无需配置】
//        // 证书名，用于下载按报名授权的证书文件
//        [self.curEngine setStringParam:licenseName forKey:SE_PARAMS_KEY_LICENSE_NAME_STRING];
//        // 业务 ID, 用于下载按报名授权的证书文件
//        [self.curEngine setStringParam:licenseBusiId forKey:SE_PARAMS_KEY_LICENSE_BUSI_ID_STRING];
//    } else if ([authenticationType isEqualToString:SE_AUTHENTICATE_TYPE_LATE_BIND]) {
//        // 按装机量授权，不限制 APP 的包名和使用次数，但是限制使用离线合成的设备数量
//        //【必需配置】离线合成鉴权相关：Authenticate Address
//        [self.curEngine setStringParam:SDEF_AUTHENTICATE_ADDRESS forKey:SE_PARAMS_KEY_AUTHENTICATE_ADDRESS_STRING];
//        //【必需配置】离线合成鉴权相关：Authenticate Uri
//        [self.curEngine setStringParam:SDEF_AUTHENTICATE_URI forKey:SE_PARAMS_KEY_AUTHENTICATE_URI_STRING];
//        NSString* curBusinessKey = [self.settings getString:SETTING_BUSINESS_KEY];
//        NSString* curAuthenticateSecret = [self.settings getString:SETTING_AUTHENTICATE_SECRET];
//        //【必需配置】离线合成鉴权相关：Business Key
//        [self.curEngine setStringParam:curBusinessKey forKey:SE_PARAMS_KEY_BUSINESS_KEY_STRING];
//        //【必需配置】离线合成鉴权相关：Authenticate Secret
//        [self.curEngine setStringParam:curAuthenticateSecret forKey:SE_PARAMS_KEY_AUTHENTICATE_SECRET_STRING];
//    }
}

#pragma mark - SpeechEngineDelegate
/// Callback of speech engine.
/// @param type Message type, SEMessageType, defined in SpeechEngineDefines.h.
/// @param data Message data, should be processed according to the message type.
- (void)onMessageWithType:(SEMessageType)type andData:(NSData *)data {
    
}

@end
