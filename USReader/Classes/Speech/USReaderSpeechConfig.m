//
//  USReaderSpeechConfig.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import "USReaderSpeechConfig.h"
#import "USConstants.h"
#import <YYModel/YYModel.h>
#import "USReaderSpeaker.h"
#import <SpeechEngineTtsToB/SpeechEngine.h>
#import <SpeechEngineTtsToB/SpeechResourceManager.h>
#import "USHuoShanDefines.h"

@interface USReaderSpeechConfig ()

/// 默认50
@property (nonatomic, assign) CGFloat pitch;
/// 默认16000
@property (nonatomic, assign) CGFloat sampleRate;
/// 51200
@property (nonatomic, copy) NSString *voiceID;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *ttsResPath;

@property (nonatomic, copy) NSString *unicode;

/// 发音人下载目录
@property (nonatomic, copy) NSString *filePath;
/// 发音人
@property (nonatomic, copy) NSString *speakersPath;
@property (nonatomic, copy) NSString *commonPath;
@property (nonatomic, copy) NSString *xfyjAppId;
@property (nonatomic, copy) NSString *xfyjCloudAppId;
@property (nonatomic, copy) NSString *xfyjLocalAppId;

@property (nonatomic, copy) NSString *testText;


/// 所有离线发音人
@property (nonatomic, copy) NSArray <USReaderSpeaker *>*speakerModels;
/// 所有在线发音人
@property (nonatomic, copy) NSArray <USReaderSpeaker *>*cloudSpeakerModels;
/// 火山引擎在线与离线发音人
@property (nonatomic, copy) NSArray <USReaderSpeaker *>*hsCloudSpeakerModels;
@property (nonatomic, copy) NSArray <USReaderSpeaker *>*hsOfflineSpeakerModels;

@property (nonatomic, copy) NSArray <USReaderSpeaker *>*cloudSpeakers;
@property (nonatomic, copy) NSArray <USReaderSpeaker *>*offlineSpeakers;

@property (nonatomic, copy) NSString *deviceID;

@end

@implementation USReaderSpeechConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.speed = 50;
        self.volume = 50;
        self.pitch = 50;
        self.sampleRate = 16000;
        self.vcnName = @"xiaoxi";
        self.engineType = EngineTypeCloud;
        self.voiceID = @"51210";
        self.fileName = @"tts.pcm";
        self.ttsResPath = @"tts_res_path";
        self.unicode = @"unicode";
        self.xfyjAppId = @"591a4d99";
        self.xfyjCloudAppId = @"5ba0b197";
        self.xfyjLocalAppId = @"5445f87d";
        self.testText = @"科大讯飞作为中国最大的智能语音技术提供商，在智能语音技术领域有着长期的研究积累、并在中文语音合成、语音识别、口语评测等多项技术上拥有国际领先的成果。科大讯飞是我国唯一以语音技术为产业化方向的“国家863计划成果产业化基地”、“国家规划布局内重点软件企业”、“国家火炬计划重点高新技术企业”、“国家高技术产业化示范工程”，并被信息产业部确定为中文语音交互技术标准工作组组长单位，牵头制定中文语音技术标准。2003年，科大讯飞获迄今中国语音产业唯一的“国家科技进步奖（二等）”，2005年获中国信息产业自主创新最高荣誉“信息产业重大技术发明奖”。2006年至2009年，连续四届英文语音合成国际大赛（Blizzard Challenge）荣获第一名。2008年获国际说话人识别评测大赛（美国国家标准技术研究院—NIST 2008）桂冠，2009年获得国际语种识别评测大赛（NIST 2009）高难度混淆方言测试指标冠军、通用测试指标亚军。";
        self.commonPath = [[USConstants resourceBundle] pathForResource:@"TTSResource/common.jet" ofType:nil];
        self.filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"speakerres/3589709422/"];
        self.speakersPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"speakerres/3589709422/xiaoyan.jet"];
        self.speakersPath  = [[USConstants resourceBundle] pathForResource:@"TTSResource/xiaoxi.jet" ofType:nil];
        [self loadSpeakers];
        [self loadCloudSpeakers];
        [self loadHSSpeakers];
        self.currentSpeaker = self.hsCloudSpeakerModels.firstObject;
        UIDevice *device = [UIDevice currentDevice];
        self.deviceID = [[device identifierForVendor] UUIDString];
        // 完成网络环境等相关依赖配置，只需要调用一次。
        BOOL status = [SpeechEngine prepareEnvironment];
        if (status) {
            [self setupResourceManager];
        }
    }
    return self;
}

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    static USReaderSpeechConfig *config;
    dispatch_once(&onceToken, ^{
        config = [[USReaderSpeechConfig alloc] init];
    });
    return config;
}

- (NSArray <USReaderSpeaker *>*)cloudSpeakers {
    if (!_cloudSpeakers) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.hsCloudSpeakerModels];
        [array addObjectsFromArray:self.cloudSpeakerModels];
        return array;
    }
    return _cloudSpeakers;
}

- (NSArray <USReaderSpeaker *>*)offlineSpeakers {
    if (!_offlineSpeakers) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.hsOfflineSpeakerModels];
        [array addObjectsFromArray:self.speakerModels];
        return array;
    }
    return _offlineSpeakers;
}

- (void)setCurrentSpeaker:(USReaderSpeaker *)currentSpeaker {
    _currentSpeaker = currentSpeaker;
    self.vcnName = currentSpeaker.name;
    self.voiceID = [NSString stringWithFormat:@"%ld", currentSpeaker.speakerId];
}

- (void)loadSpeakers {
    NSString *allSpeakersPlist = [[NSBundle bundleForClass:[self class]] pathForResource:@"all_speakers" ofType:@"plist"];
    NSDictionary *allSpeakersDict = [[NSDictionary alloc] initWithContentsOfFile:allSpeakersPlist];
    NSArray *speakers = allSpeakersDict[@"speakers"];
    NSArray <USReaderSpeaker *>*speakerModels = [NSArray yy_modelArrayWithClass:[USReaderSpeaker class] json:speakers];
    self.speakerModels = speakerModels;
}

- (void)loadCloudSpeakers {
    NSArray <NSDictionary *>* cloudSpeakers = [self iflyCloudSpeakers];
    NSMutableArray *cloudSpeakerModels = [NSMutableArray array];
    for (NSDictionary *speakerInfo in cloudSpeakers) {
        USReaderSpeaker *speaker = [[USReaderSpeaker alloc] init];
        speaker.name = speakerInfo[@"vcn"];
        speaker.nickname = speakerInfo[@"name"];
        speaker.accent = @"普通话";
        speaker.engineType = EngineTypeCloud;
        [cloudSpeakerModels addObject:speaker];
    }
    self.cloudSpeakerModels = cloudSpeakerModels;
}

- (void)loadHSSpeakers {
    
    NSString *allSpeakersPlist = [[USConstants resourceBundle] pathForResource:@"hs_cloud" ofType:@"json"];
    //获取文件内容
    NSString *jsonStr  = [NSString stringWithContentsOfFile:allSpeakersPlist encoding:NSUTF8StringEncoding error:nil];
    //将文件内容转成数据
    NSData *jaonData   = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    //将数据转成数组
    NSDictionary *allSpeakersDict= [NSJSONSerialization JSONObjectWithData:jaonData options:NSJSONReadingMutableContainers error:nil];
        
    NSArray *speakers = allSpeakersDict[@"data"];
    NSArray <USReaderSpeaker *>*speakerModels = [NSArray yy_modelArrayWithClass:[USReaderSpeaker class] json:speakers];
    NSMutableArray *cloudSpeakers = [NSMutableArray array];
    NSMutableArray *offlineSpeakers = [NSMutableArray array];
    for (USReaderSpeaker *speaker in speakerModels) {
        if ([speaker.mode isEqualToString:@"online"]) {
            [cloudSpeakers addObject:speaker];
        } else {
            [offlineSpeakers addObject:speaker];
        }
    }
    self.hsCloudSpeakerModels = cloudSpeakers;
    self.hsOfflineSpeakerModels = offlineSpeakers;
}

- (NSArray <NSDictionary *>*)iflyCloudSpeakers {
    return @[
        @{@"name":@"小燕", @"vcn":@"xiaoyan"},
        @{@"name":@"小宇", @"vcn":@"xiaoyu"},
        @{@"name":@"凯瑟琳", @"vcn":@"catherine"},
        @{@"name":@"亨利", @"vcn":@"henry"},
        @{@"name":@"玛丽", @"vcn":@"vimary"},
        @{@"name":@"小研", @"vcn":@"vixy"},
        @{@"name":@"小琪", @"vcn":@"vixq"},
        @{@"name":@"小峰", @"vcn":@"vixf"},
        @{@"name":@"小梅", @"vcn":@"vixl"},
        @{@"name":@"小莉", @"vcn":@"vixq"},
        @{@"name":@"小蓉", @"vcn":@"vixr"},
        @{@"name":@"小芸", @"vcn":@"vixyun"},
        @{@"name":@"小坤", @"vcn":@"vixk"},
        @{@"name":@"小强", @"vcn":@"vixqa"},
        @{@"name":@"小莹", @"vcn":@"vixyin"},
        @{@"name":@"小新", @"vcn":@"vixx"},
        @{@"name":@"楠楠", @"vcn":@"vinn"},
        @{@"name":@"老孙", @"vcn":@"vils"},
    ];
}

- (void) setupResourceManager {
    NSLog(@"初始化模型资源管理器");
    SpeechResourceManager *speechResourceManager = [SpeechResourceManager shareInstance];
    [speechResourceManager setAppId:SDEF_APPID];
    [speechResourceManager setAppVersion:@"4.79.0"];
    [speechResourceManager setDeviceId:self.deviceID];
    [speechResourceManager setRootPath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"models"]];
    [speechResourceManager setOnlineModelEnable:YES];
    [speechResourceManager setup];
}

@end
