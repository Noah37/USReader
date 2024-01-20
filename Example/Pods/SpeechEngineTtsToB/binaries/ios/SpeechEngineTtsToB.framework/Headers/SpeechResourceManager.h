//
//  SpeechResourceManager.h
//  SpeechEngine
//
//  Created by chengzihao.ds on 2021/4/26.
//

#ifndef SpeechResourceManager_h
#define SpeechResourceManager_h

#pragma mark - SEResourceStatus
/// SpeechResourceManager process status.
typedef enum SEResourceStatus {
    /// success
    kSERSuccess = 0,
    /// model download failed
    kSERDownloadFailed = -1,
    /// model unzip failed
    kSERUnzipFailed = -2,
    /// create file or directory failed
    kSERCreateFileFailed = -3,
    /// fetch model info failed
    kSERFetchModelInfoFailed = -4,
} SEResourceStatus;


#pragma mark - Speech Model Name
extern NSString* SE_AED_MODEL;
extern NSString* SE_TTS_MODEL;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SpeechResourceManager
@interface SpeechResourceManager : NSObject

/// 获取语音资源管理器对象，语音资源管理器是单例类
/// @return SpeechResourceManager instance.
+ (instancetype)shareInstance;

/// 设置可以唯一区别某台设备的 device id.
/// 须在 `setup` 之前调用
/// @param deviceId
- (void)setDeviceId:(NSString*)deviceId;

/// 设置从火山申请得到的 appid
/// 须在 `setup` 之前调用
/// @param appId
- (void)setAppId:(NSString*)appId;

/// 设置 APP 版本号，方便我们定位模型下载的问题
/// 须在 `setup` 之前调用
/// @param appVersion 建议设置为真实可用的版本号
- (void)setAppVersion:(NSString*)appVersion;

/// 设置语音资源管理器的根目录，模型下载后会解压到这个路径
/// 须在 `setup` 之前调用
/// @param rootPath 预先创建的目录路径
- (void)setRootPath:(NSString*)rootPath;

/// 是否使用线上资源
/// 可选调用，默认值为 YES
/// 须在 `setup` 之前调用
/// @param useOnlineModel: 无特殊需求设置为 YES
- (void)setOnlineModelEnable:(BOOL)useOnlineModel;

/// 设置 speech sdk 的引擎名称，如 TTS_ENGINE
/// 须在 `checkModelExist`, `checkModelVersion`, `fetchModel` 之前调用
/// @param engineName: 引擎名称，应和 SE_PARAMS_KEY_ENGINE_NAME_STRING 的配置值相同
- (void)setSpeechEngineName:(NSString*)engineName;

/// 初始化语音资源管理器
- (void)setup;


/// ----------- TTS 多音色模型或其他引擎类型使用下面的接口 -----------

/// 检查模型名对应的语音资源是否已经下载
/// @param modelName: 模型名，用来区分不同的资源类型
/// @return BOOL: 是否已经下载
- (BOOL)checkModelExist:(NSString*)modelName;

/// 检查模型名对应的语音资源是否有更新，冷启动生效
/// @param modelName: 模型名，用来区分不同的资源类型
/// @param completion: 更新检查监听回调
///                    @param status: {@link SEResourceStatus}.
///                    @param needUpdate: 是否需要更新模型
///                    @param data: extra message, 检查失败时为错误信息
- (void)checkModelVersion:(NSString*)modelName completion:(void (^)(SEResourceStatus status, BOOL needUpdate, NSData* data))completion;

/// 根据模型名拉取对应的语音资源
/// @param modelName: 模型名，用来区分不同的资源类型
/// @param completion: 资源下载监听回调
///                    @param status: {@link SEResourceStatus}.
///                    @param data: extra message, 下载失败时为错误信息
- (void)fetchModelByName:(NSString*)modelName completion:(void (^)(SEResourceStatus status, NSData* data))completion;

/// 获取模型名对应的资源路径
/// @param modelName: 模型名
/// @return NSString* 资源路径
- (NSString*)getModelPath:(NSString*)modelName;


/// -------------------------- TTS 单音色模型使用下面的接口  ---------------------------

/// 设置想要使用的 TTS 音色
/// 须在 `checkModelExist`, `checkModelVersion`, `fetchModel` 之前调用
/// @param voiceType: 如 ["BV001_streaming", "BV002_streaming"]
- (void)setTtsVoiceType:(NSArray*)voiceType;

/// 设置想要使用的 TTS 语种
/// 须在 `checkModelExist`, `checkModelVersion`, `fetchModel` 之前调用
/// @param language: 如 ["ZH_CN"]
- (void)setTtsLanguage:(NSArray*)language;

/// 检查语音资源是否已经下载，具体资源取决于 setSpeechEngineName, setTtsVoiceType, setTtsLanguage 方法传入的值
/// @return BOOL: 是否已经下载
- (BOOL)checkModelExist;

/// 检查语音资源是否有更新，具体资源取决于 setSpeechEngineName, setTtsVoiceType, setTtsLanguage 方法传入的值，冷启动生效
/// @param completion: async callback.
///                    @param status: {@link SEResourceStatus}.
///                    @param needUpdate: 是否需要更新
///                    @param data: extra message, 检查更新失败时为错误信息
- (void)checkModelVersion:(void (^)(SEResourceStatus status, BOOL needUpdate, NSData* data))completion;

/// 拉取 TTS 音色模型，具体模型名取决于 setSpeechEngineName, setTtsVoiceType, setTtsLanguage 方法传入的值
/// @param completion: 资源下载监听回调
///                    @param status: {@link SEResourceStatus}.
///                    @param data: extra message, 下载失败时为错误信息
- (void)fetchModel:(void (^)(SEResourceStatus status, NSData* data))completion;

/// 获取通过 fetchModel 方法下载到的模型的路径
/// @return NSString*: 资源路径，JSON 格式
- (NSString*)getModelPath;

/// 解压指定模型，解压操作在调用者线程中执行
/// @param modelName 模型名:
/// 通过 fetchModelByName 下载的资源，模型名与 fetchModelByName 的 modelName 参数相同；
/// 通过 fetchModel 下载的资源，传音色或者语种的名称.
/// @return BOOL: 解压是否成功
- (BOOL)extractModel:(NSString*)modelName;

@end

NS_ASSUME_NONNULL_END

#endif /* SpeechResourceManager_h */
