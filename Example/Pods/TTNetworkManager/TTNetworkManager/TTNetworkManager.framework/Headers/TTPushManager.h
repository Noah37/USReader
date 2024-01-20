
#import <Foundation/Foundation.h>
#import "TTPushMessageBaseObject.h"

@interface TTPushConfig : NSObject

@property (nonatomic, assign) int32_t appId;

@property (nonatomic, assign) int32_t fpid;

@property (nonatomic, assign) int64_t deviceId;

@property (nonatomic, assign) int32_t appVersion;

@property (nonatomic, assign) int64_t installId;


@property (nonatomic, assign) int64_t webId;

@property (nonatomic, assign) int32_t platform;

@property (nonatomic, assign) int32_t network;

@property(nonatomic, assign) BOOL enableAppStateReport;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *customParams;

@property (nonatomic, copy) NSArray<NSString *> *urls;
@end

@class TTPushMessageReceiver;


extern NSString * const kTTPushManagerUnknownPushMessage;
extern NSString * const kTTPushManagerUnknownPushMessageUserInfoKey;


extern NSString * const kTTPushManagerOnReceivingMessage;
extern NSString * const kTTPushManagerOnReceivingMessageUserInfoKey;


extern NSString * const kTTPushManagerOnReceivingWSChannelMessage;
extern NSString * const kTTPushManagerOnReceivingWSChannelMessageUserInfoKey;


extern NSString * const kTTPushManagerOnFeedbackLog;
extern NSString * const kTTPushManagerOnFeedbackLogUserInfoKey;


extern NSString * const kTTPushManagerConnectionError;
extern NSString * const kTTPushManagerConnectionErrorUserInfoKeyURL;
extern NSString * const kTTPushManagerConnectionErrorUserInfoKeyConnectionState;
extern NSString * const kTTPushManagerConnectionErrorUserInfoKeySpecificError;


extern NSString * const kTTPushManagerConnectionStateChanged;
extern NSString * const kTTPushManagerConnectionStateChangedInfoKeyConnectionState;
extern NSString * const kTTPushManagerConnectionStateChangedInfoKeyURL;


extern NSString * const kTTPushManagerOnTrafficChanged;
extern NSString * const kTTPushManagerOnTrafficChangedUserInfoKeyURL;
extern NSString * const kTTPushManagerOnTrafficChangedUserInfoKeySentBytes;
extern NSString * const kTTPushManagerOnTrafficChangedUserInfoKeyReceivedBytes;

typedef NS_ENUM(NSUInteger, TTPushManagerNetworkState) {
    TTPushManagerNetworkState_ReachableUnKnown,
    TTPushManagerNetworkState_NotReachable,
    TTPushManagerNetworkState_ReachableViaWiFi,
    TTPushManagerNetworkState_ReachableViaWWAN,
};

typedef NS_ENUM(NSUInteger, TTPushManagerConnectionState) {
    TTPushManagerConnectionState_ConnectUnknown,
    TTPushManagerConnectionState_Connecting,
    TTPushManagerConnectionState_ConnectFailed,
    TTPushManagerConnectionState_ConnectClosed,
    TTPushManagerConnectionState_Connected,
    TTPushManagerConnectionState_Disconnecting,
};

typedef NS_ENUM(NSUInteger, TTPushManagerMessageType) {
    TTPushManagerMessageType_Unknown,
    TTPushManagerMessageType_Text,
    TTPushManagerMessageType_Binary,
};

typedef NS_ENUM(NSUInteger, TTPushManagerConnectionMode) {
    TTPushManagerConnectionMode_Frontier,
    TTPushManagerConnectionMode_WSChannel,
};

@protocol WsDelegate;

@interface TTPushManager : NSObject

@property (nonatomic, weak) id <WsDelegate> delegate;


+ (instancetype)sharedManager;

+ (instancetype)anotherSharedManager;


- (instancetype)init:(BOOL)shared ConnectionMode:(TTPushManagerConnectionMode) mode;

- (void)configConnection:(TTPushConfig *)config;

- (void)asyncStartConnection;

- (void)asyncStopConnection;

- (BOOL)asyncSendPushMessage:(/*nonnull*/ PushMessageBaseObject *)message;


- (BOOL)asyncSendBinaryMessage:(/*nonnull*/ NSData *)message;


- (BOOL)asyncSendTextMessage:(/*nonnull*/ NSString *)message;


- (void)asyncSendPing;


- (BOOL)isConnected;


- (void)onNetworkStateChanged:(TTPushManagerNetworkState)networkState;


- (void)startConnection:(/*nonnull*/ NSArray *)urls
                  appId:(/*nonnull*/ int32_t)appId
                   fpid:(/*nonnull*/ int32_t)fpid
                 appKey:(/*nonnull*/ NSString *)appKey
               deviceId:(/*nonnull*/ int64_t)deviceId
             appVersion:(/*nonnull*/ int32_t)appVersion
             sdkVersion:(/*nonnull*/ int32_t)sdkVersion
              installId:(/*nullable*/ int64_t)installId
              sessionId:(/*nullable*/ NSString *)sessionId
                  webId:(/*nullable*/ int64_t)webId
               platform:(/*nullable*/ int32_t)platform
                network:(/*nullable*/ int32_t)network DEPRECATED_ATTRIBUTE;

- (void)startConnection:(/*nonnull*/ NSArray *)urls
                  appId:(/*nonnull*/ int32_t)appId
               deviceId:(/*nonnull*/ int64_t)deviceId
             appVersion:(/*nonnull*/ int32_t)appVersion
             sdkVersion:(/*nonnull*/ int32_t)sdkVersion
              installId:(/*nullable*/ int64_t)installId
              sessionId:(/*nullable*/ NSString *)sessionId
                  webId:(/*nullable*/ int64_t)webId
               platform:(/*nullable*/ int32_t)platform
                network:(/*nullable*/ int32_t)network DEPRECATED_ATTRIBUTE;

- (void)startConnection:(/*nonnull*/ NSArray *)urls
                  appId:(/*nonnull*/ int32_t)appId
                   fpid:(/*nonnull*/ int32_t)fpid
                 appKey:(/*nonnull*/ NSString *)appKey
               deviceId:(/*nonnull*/ int64_t)deviceId
             appVersion:(/*nonnull*/ int32_t)appVersion
             sdkVersion:(/*nonnull*/ int32_t)sdkVersion
              installId:(/*nullable*/ int64_t)installId
              sessionId:(/*nullable*/ NSString *)sessionId
                  webId:(/*nullable*/ int64_t)webId
               platform:(/*nullable*/ int32_t)platform
                network:(/*nullable*/ int32_t)network
           customParams:(/*nullable*/ NSDictionary<NSString *, NSString *> *)customParams DEPRECATED_ATTRIBUTE;

- (void)stopConnection DEPRECATED_ATTRIBUTE;

- (void)enableDebugLog:(BOOL)enabled;

- (void)setCustomizedMessageReceiver:(TTPushMessageReceiver *)messageReceiver;

- (void)setBroadcastingMessage:(BOOL)value;

@end

@protocol WsDelegate <NSObject>

@optional

- (void)onPushMessageReceived:(TTPushManager*)pushManager message:(id)message type:(TTPushManagerMessageType)type;

- (void)onFrontierMessageReceived:(TTPushManager*)pushManager message:(PushMessageBaseObject *)message;

- (void)onFeedbackLog:(TTPushManager*)pushManager feedbacklog:(NSString *)log;

- (void)onConnectionErrorWithState:(TTPushManager*)pushManager connectionState:(TTPushManagerConnectionState)state url:(NSString *)url error:(NSString *)error;

- (void)onConnectionStateChanged:(TTPushManager*)pushManager connectionState:(TTPushManagerConnectionState)state url:(NSString *)url;


@end
