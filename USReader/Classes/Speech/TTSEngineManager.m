//
//  TTSEngineManager.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/9.
//

#import "TTSEngineManager.h"
#import "TTSIFlyOfflineEngine.h"
#import "TTSIFlyCloudEngine.h"
#import "TTSHuoShanCloudEngine.h"

@interface TTSEngineManager ()<TTSBaseEngineDataSource,TTSBaseEngineDelegate>

@property (nonatomic, strong) TTSIFlyCloudEngine *iflyCloudEngine;
@property (nonatomic, strong) TTSIFlyOfflineEngine *iflyOfflineEngine;
@property (nonatomic, strong) TTSHuoShanCloudEngine *hsCloudEngine;

@property (nonatomic, weak) id <TTSEngineDataSource>dataSource;
@property (nonatomic, weak) id <TTSBaseEngineDelegate>delegate;

@end

@implementation TTSEngineManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static TTSEngineManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[TTSEngineManager alloc] init];
    });
    return manager;
}

- (void)startWithDataSource:(id<TTSEngineDataSource>)dataSource delegate:(id<TTSBaseEngineDelegate>)delegate {
    /// 如果存在MP3文件，直接播放
    _dataSource = dataSource;
    _delegate = delegate;
    [self stop];
    switch (dataSource.engineType) {
        case TTSEngineTypeHSCloud:
            [self.hsCloudEngine start];
            break;
        case TTSEngineTypeIflyCloud:
            [self.iflyCloudEngine start];
            break;
        case TTSEngineTypeIflyOffline:
            [self.iflyOfflineEngine start];
            break;
        default:
            break;
    }
}

- (void)stop {
    [self.hsCloudEngine stop];
    [self.iflyCloudEngine stop];
    [self.iflyOfflineEngine stop];

    switch (self.dataSource.engineType) {
        case TTSEngineTypeHSCloud:
            break;
        case TTSEngineTypeIflyCloud:
            break;
        case TTSEngineTypeIflyOffline:
            break;
        default:
            break;
    }
}

- (void)pause {
    [self.hsCloudEngine pause];
    [self.iflyCloudEngine pause];
    [self.iflyOfflineEngine pause];
    switch (self.dataSource.engineType) {
        case TTSEngineTypeHSCloud:
            break;
        case TTSEngineTypeIflyCloud:
            break;
        case TTSEngineTypeIflyOffline:
            break;
        default:
            break;
    }
}

- (void)resume {
    [self.hsCloudEngine resume];
    [self.iflyCloudEngine resume];
    [self.iflyOfflineEngine resume];
    switch (self.dataSource.engineType) {
        case TTSEngineTypeHSCloud:
            break;
        case TTSEngineTypeIflyCloud:
            break;
        case TTSEngineTypeIflyOffline:
            break;
        default:
            break;
    }
}

- (NSString *_Nullable)currentSentence {
    return [self.dataSource currentSentence];
}

- (NSString *_Nullable)nextSentence {
    return [self.dataSource nextSentence];

}

- (NSString *_Nullable)previousSentence {
    return [self.dataSource previousSentence];
}

- (void)TTSBaseEngine:(TTSBaseEngine *)engine readText:(NSAttributedString *)text {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngine:readText:)]) {
        [self.delegate TTSBaseEngine:self.hsCloudEngine readText:text];
    }
}

- (void)TTSBaseEngineDidStop:(TTSBaseEngine *)engine {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStop:)]) {
        [self.delegate TTSBaseEngineDidStop:self.hsCloudEngine];
    }
}

- (void)TTSBaseEngineDidStart:(TTSBaseEngine *)engine {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidStart:)]) {
        [self.delegate TTSBaseEngineDidStart:self.hsCloudEngine];
    }
}

- (void)TTSBaseEngineDidPause:(TTSBaseEngine *)engine {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidPause:)]) {
        [self.delegate TTSBaseEngineDidPause:self.hsCloudEngine];
    }
}

- (void)TTSBaseEngineDidResume:(TTSBaseEngine *)engine {
    if ([self.delegate respondsToSelector:@selector(TTSBaseEngineDidResume:)]) {
        [self.delegate TTSBaseEngineDidResume:self.hsCloudEngine];
    }
}

- (TTSIFlyCloudEngine *)iflyCloudEngine {
    if (!_iflyCloudEngine) {
        _iflyCloudEngine = [[TTSIFlyCloudEngine alloc] init];
        _iflyCloudEngine.dataSource = self;
        _iflyCloudEngine.delegate = self;

    }
    return _iflyCloudEngine;
}

- (TTSIFlyOfflineEngine *)iflyOfflineEngine {
    if (!_iflyOfflineEngine) {
        _iflyOfflineEngine = [[TTSIFlyOfflineEngine alloc] init];
        _iflyOfflineEngine.dataSource = self;
        _iflyOfflineEngine.delegate = self;
    }
    return _iflyOfflineEngine;
}

- (TTSHuoShanCloudEngine *)hsCloudEngine {
    if (!_hsCloudEngine) {
        _hsCloudEngine = [[TTSHuoShanCloudEngine alloc] init];
        _hsCloudEngine.dataSource = self;
        _hsCloudEngine.delegate = self;
    }
    return _hsCloudEngine;
}

@end
