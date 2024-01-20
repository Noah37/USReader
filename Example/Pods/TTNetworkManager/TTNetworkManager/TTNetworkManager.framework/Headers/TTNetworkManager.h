
#import <Foundation/Foundation.h>
#import "TTNetworkDefine.h"
#import "TTDnsResult.h"
#import "TTHTTPRequestSerializerProtocol.h"
#import "TTHTTPResponseSerializerProtocol.h"
#import "TTHttpTask.h"
#import "TTNetworkQualityEstimator.h"


extern NSString * const kTTNetColdStartFinishNotification;
extern NSString * const kTTNetNetDetectResultNotification;
extern NSString * const kTTNetConnectionTypeNotification;
extern NSString * const kTTNetServerConfigChangeNotification;
extern NSString * const kTTNetServerConfigChangeDataKey;
extern NSString * const kTTNetStoreIdcChangeNotification;
extern NSString * const kTTNetNeedDropClientRequest;


typedef NSDictionary<NSString *, NSString *> *(^TTNetworkManagerCommonParamsBlock)(void);
typedef NSURL *(^TTURLTransformBlock)(NSURL *url);

typedef NS_ENUM(NSInteger, TTNetworkManagerImplType) {
    TTNetworkManagerImplTypeAFNetworking = 0,
    TTNetworkManagerImplTypeLibChromium = 1,
};

typedef NSURL *(^TTURLHashBlock)(NSURL *url, NSDictionary *formData);

typedef NS_ENUM(NSInteger, TTNetEffectiveConnectionType) {
  // Effective connection type reported when the network is fake network.
  EFFECTIVE_CONNECTION_TYPE_FAKE_NETWORK = -1,

  // Effective connection type reported when the network quality is unknown.
  EFFECTIVE_CONNECTION_TYPE_UNKNOWN = 0,

  // Effective connection type reported when the Internet is unreachable, either
  // because the device does not have a connection or because the
  // connection is too slow to be usable.
  EFFECTIVE_CONNECTION_TYPE_OFFLINE,

  // Effective connection type reported when the network has the quality of a
  // poor 2G connection.
  EFFECTIVE_CONNECTION_TYPE_SLOW_2G,

  // Effective connection type reported when the network has the quality of a
  // faster 2G connection.
  EFFECTIVE_CONNECTION_TYPE_2G,

  // Effective connection type reported when the network has the quality of a 3G
  // connection.
  EFFECTIVE_CONNECTION_TYPE_3G,

  //For bytedance network quality estimation
  // doc/doccnpEekZvelthGFc7IqylvvEa
  // Effective connection type reported when the network has the quality of a 4G
  // connection.
  //EFFECTIVE_CONNECTION_TYPE_4G,

  // Effective connection type reported when the network has the quality of a SLOW_4G
  // connection.
  EFFECTIVE_CONNECTION_TYPE_SLOW_4G,

  // Effective connection type reported when the network has the quality of a MODERATE_4G
  // connection.
  EFFECTIVE_CONNECTION_TYPE_MODERATE_4G,

  // Effective connection type reported when the network has the quality of a GOOD_4G
  // connection.
  EFFECTIVE_CONNECTION_TYPE_GOOD_4G,

  // Effective connection type reported when the network has the quality of a EXCELLENT_4G
  // connection.
  EFFECTIVE_CONNECTION_TYPE_EXCELLENT_4G,

  // Last value of the effective connection type. This value is unused.
  EFFECTIVE_CONNECTION_TYPE_LAST,
};

@interface TTNetworkManager : NSObject


@property(nonatomic, strong)Class<TTJSONResponseSerializerProtocol> defaultJSONResponseSerializerClass;

@property(nonatomic, strong)Class<TTResponseModelResponseSerializerProtocol> defaultResponseModelResponseSerializerClass;

@property(nonatomic, strong)Class<TTBinaryResponseSerializerProtocol> defaultBinaryResponseSerializerClass;

@property(nonatomic, strong)Class<TTHTTPRequestSerializerProtocol> defaultRequestSerializerClass;

@property(nonatomic, strong)Class<TTResponsePreProcessorProtocol> defaultResponseRreprocessorClass;

@property(nonatomic, copy)NSDictionary * commonParams;

@property(nonatomic, copy)TTNetworkManagerCommonParamsBlock commonParamsblock;

@property (nonatomic, copy)TTURLTransformBlock urlTransformBlock;

@property(nonatomic, assign)BOOL pureChannelForJSONResponseSerializer;

@property(nonatomic, assign) BOOL isEncryptQuery;

@property(nonatomic, assign) BOOL isEncryptQueryInHeader;

@property(nonatomic, assign) BOOL isKeepPlainQuery;

@property(nonatomic, copy) TTURLHashBlock urlHashBlock;



+ (instancetype)shareInstance;

+ (TTNetworkManagerImplType)getLibraryImpl;

- (NSURL *)transferedURL:(NSURL *)url;


+ (void)setHttpDnsEnabled:(BOOL)httpDnsEnabled;
+ (BOOL)httpDnsEnabled;

typedef void (^Monitorblock)(NSDictionary*, NSString*);
+ (Monitorblock) g_monitorBlock;
+ (void)setMonitorBlock:(Monitorblock)block;
+ (Monitorblock)MonitorBlock;

typedef void (^GetDomainblock)(NSData*);
+ (GetDomainblock) g_GetDomainBlock;
+ (void)setGetDomainBlock:(GetDomainblock)block;
+ (GetDomainblock)GetDomainBlock;

+ (NSString*) g_CityName;
+ (void)setCityName:(NSString*)city;
+ (NSString*)GetCityName;

- (void)creatAppInfo;

- (void)start;

- (void)setProxy:(NSString *)proxy;
- (void)setBoeProxyEnabled:(BOOL)enabled;

- (TTNetEffectiveConnectionType)getEffectiveConnectionType;
- (TTNetworkQuality*)getNetworkQuality;
- (TTPacketLossMetrics*)getPacketLossMetrics:(TTPacketLossProtocol)protocol;

@property(nonatomic, copy) NSString* ServerConfigHostFirst;
@property(nonatomic, copy) NSString* ServerConfigHostSecond;
@property(nonatomic, copy) NSString* ServerConfigHostThird;

@property(nonatomic, copy) NSString* DomainHttpDns;
@property(nonatomic, copy) NSString* DomainNetlog;
@property(nonatomic, copy) NSString* DomainBoe;

@property(nonatomic, copy) NSString* getDomainDefaultJSON;

@property(nonatomic, copy) NSString* bypassBoeJSON;

@property(atomic, copy) NSArray* ServerCertificate;

@property(nonatomic, copy) NSString* storeIdcRuleJSON;

@property(nonatomic, copy) NSString* StoreIdc;

@property(nonatomic, copy) NSString* UserId;

@property(nonatomic, copy) NSString* hostResolverRulesForTesting;

@property(nonatomic, copy, readonly) NSString* clientIP;

@property(nonatomic, copy, readonly) NSString* userIdc;

@property(nonatomic, copy, readonly) NSString* userRegion;

typedef void (^GetNqeResultBlock)(NSInteger httpRtt, NSInteger transportRtt, NSInteger downstreamThroughputKbps);

typedef void (^GetPacketLossResultBlock)(TTPacketLossProtocol protocol, double upstreamLossRate, double upstreamLossRateVariance, double downstreamLossRate, double downstreamLossRateVariance);

typedef void (^RequestFilterBlock)(TTHttpRequest *request);

typedef void (^ResponseFilterBlock)(TTHttpRequest *request, TTHttpResponse *response, id data, NSError *responseError);

typedef void (^ResponseChainFilterBlock)(TTHttpRequest *request, TTHttpResponse *response, id data, NSError **responseError);

@property(nonatomic, copy) RequestFilterBlock   requestFilterBlock;
@property(nonatomic, copy) ResponseFilterBlock  responseFilterBlock;

- (void)setEnableReqFilter:(BOOL)enableReqFilter;

- (void)addRequestFilterBlock:(RequestFilterBlock)requestFilterBlock;

- (void)addResponseFilterBlock:(ResponseFilterBlock)responseFilterBlock;

- (void)addResponseChainFilterBlock:(ResponseChainFilterBlock)responseChainFilterBlock;

@property(nonatomic, assign) BOOL dontCallbackInMainThread;

@property(atomic, assign) BOOL enableApiHttpIntercept;

@property(atomic, copy) NSArray *apiHttpHostListArray;

@property(nonatomic, assign) BOOL enableHttpCache;

@property(nonatomic, assign) int httpCacheSize;

@property(nonatomic, assign) double initNetworkThreadPriority;

typedef void (^FrontierUrlsCallbackBlock)(NSArray<NSString *> *urls);
extern FrontierUrlsCallbackBlock g_frontierUrlsCallbackBlock;
+ (void)setFrontierUrlsCallbackBlock:(FrontierUrlsCallbackBlock)block;
+ (FrontierUrlsCallbackBlock)GetFrontierUrlsCallbackBlock;

typedef NSDictionary* (^AddSecurityFactorBlock)(NSURL* url, NSDictionary *requestHeaders);
@property(atomic, copy) AddSecurityFactorBlock addSecurityFactorBlock;

#pragma mark -- Response Model
#pragma mark -- Response Model Request Use RequestModel

- (TTHttpTask *)requestModel:(TTRequestModel *)model
                          callback:(TTNetworkResponseModelFinishBlock)callback;


- (TTHttpTask *)requestModel:(TTRequestModel *)model
                    callback:(TTNetworkResponseModelFinishBlock)callback
        callbackInMainThread:(BOOL)callbackInMainThread;

- (TTHttpTask *)requestModel:(TTRequestModel *)model
                 requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                responseSerializer:(Class<TTResponseModelResponseSerializerProtocol>)responseSerializer
                        autoResume:(BOOL)autoResume
                          callback:(TTNetworkResponseModelFinishBlock)callback;

- (TTHttpTask *)requestModel:(TTRequestModel *)model
           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
          responseSerializer:(Class<TTResponseModelResponseSerializerProtocol>)responseSerializer
                  autoResume:(BOOL)autoResume
                    callback:(TTNetworkResponseModelFinishBlock)callback
        callbackInMainThread:(BOOL)callbackInMainThread;

- (TTHttpTask *)requestModel:(TTRequestModel *)model
           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
          responseSerializer:(Class<TTResponseModelResponseSerializerProtocol>)responseSerializer
                  autoResume:(BOOL)autoResume
                    callback:(TTNetworkResponseModelFinishBlock)callback
               callbackQueue:(dispatch_queue_t)callbackQueue;

#pragma mark -- Response JSON
#pragma mark -- Response JSON Request User URL

- (TTHttpTask *)requestForJSONWithURL:(NSString *)URL
                                     params:(id)params
                                     method:(NSString *)method
                           needCommonParams:(BOOL)commonParams
                                   callback:(TTNetworkJSONFinishBlock)callback;

- (TTHttpTask *)requestForJSONWithURL:(NSString *)URL
                               params:(id)params
                               method:(NSString *)method
                     needCommonParams:(BOOL)commonParams
                             callback:(TTNetworkJSONFinishBlock)callback
                 callbackInMainThread:(BOOL)callbackInMainThread;


- (TTHttpTask *)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                          needCommonParams:(BOOL)commonParams
                                  callback:(TTNetworkJSONFinishBlockWithResponse)callback;

- (TTHttpTask *)requestForJSONWithURL:(NSString *)URL
                                     params:(id)params
                                     method:(NSString *)method
                           needCommonParams:(BOOL)commonParams
                          requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                         responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                                 autoResume:(BOOL)autoResume
                                   callback:(TTNetworkJSONFinishBlock)callback;


- (TTHttpTask *)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                          needCommonParams:(BOOL)commonParams
                         requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                        responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                                autoResume:(BOOL)autoResume
                                  callback:(TTNetworkJSONFinishBlockWithResponse)callback;

- (TTHttpTask *)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                          needCommonParams:(BOOL)commonParams
                               headerField:(NSDictionary *)headerField
                         requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                        responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                                autoResume:(BOOL)autoResume
                                  callback:(TTNetworkJSONFinishBlockWithResponse)callback;

- (TTHttpTask *)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                          needCommonParams:(BOOL)commonParams
                               headerField:(NSDictionary *)headerField
                         requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                        responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                                autoResume:(BOOL)autoResume
                             verifyRequest:(BOOL)verifyRequest
                        isCustomizedCookie:(BOOL)isCustomizedCookie
                                  callback:(TTNetworkJSONFinishBlockWithResponse)callback;


- (TTHttpTask *)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                          needCommonParams:(BOOL)commonParams
                               headerField:(NSDictionary *)headerField
                         requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                        responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                                autoResume:(BOOL)autoResume
                             verifyRequest:(BOOL)verifyRequest
                        isCustomizedCookie:(BOOL)isCustomizedCookie
                                  callback:(TTNetworkJSONFinishBlockWithResponse)callback
                      callbackInMainThread:(BOOL)callbackInMainThread;

- (TTHttpTask *)requestForJSONWithResponse:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                          needCommonParams:(BOOL)commonParams
                               headerField:(NSDictionary *)headerField
                         requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                        responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                                autoResume:(BOOL)autoResume
                             verifyRequest:(BOOL)verifyRequest
                        isCustomizedCookie:(BOOL)isCustomizedCookie
                                  callback:(TTNetworkJSONFinishBlockWithResponse)callback
                             callbackQueue:(dispatch_queue_t)callbackQueue;


#pragma mark -- Binary Model
#pragma mark -- Binary Model Request Use URL

- (TTHttpTask *)requestForBinaryWithURL:(NSString *)URL
                                       params:(id)params
                                       method:(NSString *)method
                             needCommonParams:(BOOL)commonParams
                                     callback:(TTNetworkObjectFinishBlock)callback;



- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                 params:(id)params
                                 method:(NSString *)method
                       needCommonParams:(BOOL)commonParams
                               callback:(TTNetworkObjectFinishBlockWithResponse)callback;

- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                            needCommonParams:(BOOL)commonParams
                                 headerField:(NSDictionary *)headerField
                             enableHttpCache:(BOOL)enableHttpCache
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                    progress:(NSProgress * __autoreleasing *)progress
                                    callback:(TTNetworkObjectFinishBlockWithResponse)callback;

- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                            needCommonParams:(BOOL)needCommonParams
                                 headerField:(NSDictionary *)headerField
                             enableHttpCache:(BOOL)enableHttpCache
                                  autoResume:(BOOL)autoResume
                          isCustomizedCookie:(BOOL)isCustomizedCookie
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                    progress:(NSProgress * __autoreleasing *)progress
                                    callback:(TTNetworkObjectFinishBlockWithResponse)callback
                        callbackInMainThread:(BOOL)callbackInMainThread;

- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                            needCommonParams:(BOOL)needCommonParams
                                 headerField:(NSDictionary *)headerField
                             enableHttpCache:(BOOL)enableHttpCache
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                    progress:(NSProgress * __autoreleasing *)progress
                                    callback:(TTNetworkObjectFinishBlockWithResponse)callback
                        callbackInMainThread:(BOOL)callbackInMainThread;

- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                            needCommonParams:(BOOL)needCommonParams
                                 headerField:(NSDictionary *)headerField
                             enableHttpCache:(BOOL)enableHttpCache
                                  autoResume:(BOOL)autoResume
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                    progress:(NSProgress * __autoreleasing *)progress
                                    callback:(TTNetworkObjectFinishBlockWithResponse)callback
                        callbackInMainThread:(BOOL)callbackInMainThread;

- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                            needCommonParams:(BOOL)needCommonParams
                                 headerField:(NSDictionary *)headerField
                             enableHttpCache:(BOOL)enableHttpCache
                                  autoResume:(BOOL)autoResume
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                    progress:(NSProgress * __autoreleasing *)progress
                                    callback:(TTNetworkObjectFinishBlockWithResponse)callback
                               callbackQueue:(dispatch_queue_t)callbackQueue;


- (TTHttpTask *)requestForBinaryWithURL:(NSString *)URL
                                       params:(id)params
                                       method:(NSString *)method
                             needCommonParams:(BOOL)commonParams
                            requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                           responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                   autoResume:(BOOL)autoResume
                                     callback:(TTNetworkObjectFinishBlock)callback;


- (TTHttpTask *)requestForBinaryWithResponse:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                            needCommonParams:(BOOL)commonParams
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                  autoResume:(BOOL)autoResume
                                    callback:(TTNetworkObjectFinishBlockWithResponse)callback;


- (TTHttpTask *)requestForChunkedBinaryWithURL:(NSString *)URL
                                        params:(id)params
                                        method:(NSString *)method
                              needCommonParams:(BOOL)commonParams
                                   headerField:(NSDictionary *)headerField
                               enableHttpCache:(BOOL)enableHttpCache
                             requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                            responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                    autoResume:(BOOL)autoResume
                                headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                                  dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
                                      callback:(TTNetworkObjectFinishBlock)callback;

- (TTHttpTask *)requestForChunkedBinaryWithResponse:(NSString *)URL
                                             params:(id)params
                                             method:(NSString *)method
                                   needCommonParams:(BOOL)commonParams
                                        headerField:(NSDictionary *)headerField
                                    enableHttpCache:(BOOL)enableHttpCache
                                  requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                                 responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                         autoResume:(BOOL)autoResume
                                 isCustomizedCookie:(BOOL)isCustomizedCookie
                                     headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                                       dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
                               callbackWithResponse:(TTNetworkObjectFinishBlockWithResponse)callbackWithResponse
                                   redirectCallback:(TTNetworkURLRedirectBlock)redirectCallback;

- (TTHttpTask *)requestForChunkedBinaryWithResponse:(NSString *)URL
                                             params:(id)params
                                             method:(NSString *)method
                                   needCommonParams:(BOOL)commonParams
                                        headerField:(NSDictionary *)headerField
                                    enableHttpCache:(BOOL)enableHttpCache
                                  requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                                 responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                        autoResume:(BOOL)autoResume
                                     headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                                       dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
                               callbackWithResponse:(TTNetworkObjectFinishBlockWithResponse)callbackWithResponse;

- (TTHttpTask *)requestForChunkedBinaryWithResponse:(NSString *)URL
                                             params:(id)params
                                             method:(NSString *)method
                                   needCommonParams:(BOOL)commonParams
                                        headerField:(NSDictionary *)headerField
                                    enableHttpCache:(BOOL)enableHttpCache
                                  requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                                 responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                         autoResume:(BOOL)autoResume
                                     headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                                       dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
                               callbackWithResponse:(TTNetworkObjectFinishBlockWithResponse)callbackWithResponse redirectCallback:(TTNetworkURLRedirectBlock)redirectCallback;

- (TTHttpTask *)requestForWebview:(NSURLRequest *)request
                  enableHttpCache:(BOOL)enableHttpCache
                   headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                     dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
             callbackWithResponse:(TTNetworkObjectFinishBlockWithResponse)callbackWithResponse;

- (TTHttpTask *)requestForWebview:(NSURLRequest *)request
                       autoResume:(BOOL)autoResume
                  enableHttpCache:(BOOL)enableHttpCache
                   headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                     dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
             callbackWithResponse:(TTNetworkObjectFinishBlockWithResponse)callbackWithResponse;

- (TTHttpTask *)requestForWebview:(NSURLRequest *)request
                       autoResume:(BOOL)autoResume
                  enableHttpCache:(BOOL)enableHttpCache
                   headerCallback:(TTNetworkChunkedDataHeaderBlock)headerCallback
                     dataCallback:(TTNetworkChunkedDataReadBlock)dataCallback
             callbackWithResponse:(TTNetworkObjectFinishBlockWithResponse)callbackWithResponse
                 redirectCallback:(TTNetworkURLRedirectBlock)redirectCallback;

- (TTHttpTask *)uploadWithURL:(NSString *)URLString
                               parameters:(id)parameters
                constructingBodyWithBlock:(TTConstructingBodyBlock)bodyBlock
                                 progress:(NSProgress * __autoreleasing *)progress
                         needcommonParams:(BOOL)needCommonParams
                                 callback:(TTNetworkJSONFinishBlock)callback;

- (TTHttpTask *)uploadWithURL:(NSString *)URLString
                              headerField:(NSDictionary *)headerField
                               parameters:(id)parameters
                constructingBodyWithBlock:(TTConstructingBodyBlock)bodyBlock
                                 progress:(NSProgress * __autoreleasing *)progress
                         needcommonParams:(BOOL)needCommonParams
                                 callback:(TTNetworkJSONFinishBlock)callback;

- (TTHttpTask *)uploadWithURL:(NSString *)URLString
                               parameters:(id)parameters
                              headerField:(NSDictionary *)headerField
                constructingBodyWithBlock:(TTConstructingBodyBlock)bodyBlock
                                 progress:(NSProgress * __autoreleasing *)progress
                         needcommonParams:(BOOL)needCommonParams
                        requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                       responseSerializer:(Class<TTJSONResponseSerializerProtocol>)responseSerializer
                               autoResume:(BOOL)autoResume
                                 callback:(TTNetworkJSONFinishBlock)callback;


- (TTHttpTask *)uploadWithResponse:(NSString *)URLString
                        parameters:(id)parameters
                       headerField:(NSDictionary *)headerField
         constructingBodyWithBlock:(TTConstructingBodyBlock)bodyBlock
                          progress:(NSProgress * __autoreleasing *)progress
                  needcommonParams:(BOOL)needCommonParams
                 requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                        autoResume:(BOOL)autoResume
                          callback:(TTNetworkObjectFinishBlockWithResponse)callback;


- (TTHttpTask *)uploadWithResponse:(NSString *)URLString
                        parameters:(id)parameters
                       headerField:(NSDictionary *)headerField
         constructingBodyWithBlock:(TTConstructingBodyBlock)bodyBlock
                          progress:(NSProgress * __autoreleasing *)progress
                  needcommonParams:(BOOL)needCommonParams
                 requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                        autoResume:(BOOL)autoResume
                          callback:(TTNetworkObjectFinishBlockWithResponse)callback
                           timeout:(NSTimeInterval)timeout;


- (TTHttpTask *)uploadRawDataWithResponse:(NSString *)URLString
                                   method:(NSString *)method
                              headerField:(NSDictionary *)headerField
                                bodyField:(NSData *)bodyField
                                 progress:(NSProgress * __autoreleasing *)progress
                        requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                       responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                               autoResume:(BOOL)autoResume
                                 callback:(TTNetworkObjectFinishBlockWithResponse)callback
                                  timeout:(NSTimeInterval)timeout;


- (TTHttpTask *)uploadRawFileWithResponse:(NSString *)URLString
                                   method:(NSString *)method
                              headerField:(NSDictionary *)headerField
                                 filePath:(NSString *)filePath
                                 progress:(NSProgress * __autoreleasing *)progress
                 requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                        autoResume:(BOOL)autoResume
                          callback:(TTNetworkObjectFinishBlockWithResponse)callback
                           timeout:(NSTimeInterval)timeout;


- (TTHttpTask *)uploadRawFileWithResponseByRange:(NSString *)URLString
                                          method:(NSString *)method
                                     headerField:(NSDictionary *)headerField
                                        filePath:(NSString *)filePath
                                          offset:(uint64_t)uploadFileOffset
                                          length:(uint64_t)uploadFileLength
                                        progress:(NSProgress * __autoreleasing *)progress
                               requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                              responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                      autoResume:(BOOL)autoResume
                                        callback:(TTNetworkObjectFinishBlockWithResponse)callback
                                         timeout:(NSTimeInterval)timeout;


- (NSDictionary *)synchronizedRequstForURL:(NSString *)URL
                                    method:(NSString *)method
                               headerField:(NSDictionary *)headerField
                             jsonObjParams:(id)params
                          needCommonParams:(BOOL)needCommonParams;

- (NSDictionary *)synchronizedRequstForURL:(NSString *)URL
                                    method:(NSString *)method
                               headerField:(NSDictionary *)headerField
                             jsonObjParams:(id)params
                          needCommonParams:(BOOL)needCommonParams
                              needResponse:(BOOL)needReponse;

- (NSDictionary *)synchronizedRequstForURL:(NSString *)URL
                                    method:(NSString *)method
                               headerField:(NSDictionary *)headerField
                             jsonObjParams:(id)params
                          needCommonParams:(BOOL)needCommonParams
                              needResponse:(BOOL)needReponse
                               needEncrypt:(BOOL)needEncrypt;

- (NSDictionary *)synchronizedRequstForURL:(NSString *)URL
                                    method:(NSString *)method
                               headerField:(NSDictionary *)headerField
                             jsonObjParams:(id)params
                          needCommonParams:(BOOL)needCommonParams
                              needResponse:(BOOL)needReponse
                               needEncrypt:(BOOL)needEncrypt
           needContentEncodingAfterEncrypt:(BOOL)needContentEncoding;

- (NSDictionary *)synchronizedRequstForURL:(NSString *)URL
                                    method:(NSString *)method
                               headerField:(NSDictionary *)headerField
                             jsonObjParams:(id)params
                          needCommonParams:(BOOL)needCommonParams
                         requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)serializer
                              needResponse:(BOOL)needResponse
                               needEncrypt:(BOOL)needEncrypt
           needContentEncodingAfterEncrypt:(BOOL)needContentEncoding;

#pragma mark - Progress download a file API


- (TTHttpTask *)downloadTaskWithRequest:(NSString *)URL
                             parameters:(id)parameters
                            headerField:(NSDictionary *)headerField
                       needCommonParams:(BOOL)needCommonParams
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL *)destination
                      completionHandler:(void (^)(TTHttpResponse *response, NSURL *filePath, NSError *error))completionHandler;

#pragma mark - Interface for media usage

- (TTHttpTask *)requestForRangeMediaResource:(NSString *)URL
                                      params:(id)params
                                      method:(NSString *)method
                                      offset:(NSInteger)offset
                             requestedLength:(NSInteger)requestedLength
                            needCommonParams:(BOOL)commonParams
                                 headerField:(NSDictionary *)headerField
                             enableHttpCache:(BOOL)enableHttpCache
                           requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                          responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                  autoResume:(BOOL)autoResume
                    onHeaderReceivedCallback:(TTNetworkChunkedDataHeaderBlock)onHeaderReceivedCallback
                          onDataReadCallback:(TTNetworkChunkedDataReadBlock)onDataReadCallback
                     onRequestFinishCallback:(TTNetworkObjectFinishBlock)onRequestFinishCallback;

- (TTHttpTask *)requestForRangeMediaResourceWithResponse:(NSString *)URL
                                                  params:(id)params
                                                  method:(NSString *)method
                                                  offset:(NSInteger)offset
                                         requestedLength:(NSInteger)requestedLength
                                        needCommonParams:(BOOL)commonParams
                                             headerField:(NSDictionary *)headerField
                                         enableHttpCache:(BOOL)enableHttpCache
                                       requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                                      responseSerializer:(Class<TTBinaryResponseSerializerProtocol>)responseSerializer
                                              autoResume:(BOOL)autoResume
                                onHeaderReceivedCallback:(TTNetworkChunkedDataHeaderBlock)onHeaderReceivedCallback
                                      onDataReadCallback:(TTNetworkChunkedDataReadBlock)onDataReadCallback
                                 onRequestFinishCallback:(TTNetworkObjectFinishBlockWithResponse)onRequestFinishCallback;

#pragma mark - MISC


- (void)doRouteSelection;


- (TTHttpTask *)downloadTaskWithRequest:(NSString *)URL
                             parameters:(id)parameters
                            headerField:(NSDictionary *)headerField
                       needCommonParams:(BOOL)needCommonParams
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL *)destination
                             autoResume:(BOOL)autoResume
                      completionHandler:(void (^)(TTHttpResponse *response, NSURL *filePath, NSError *error))completionHandler;

- (TTHttpTask *)downloadTaskWithRequest:(NSString *)URL
                             parameters:(id)parameters
                            headerField:(NSDictionary *)headerField
                       needCommonParams:(BOOL)needCommonParams
                      requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                               progress:(NSProgress * __autoreleasing *)progress
                            destination:(NSURL *)destination
                             autoResume:(BOOL)autoResume
                      completionHandler:(void (^)(TTHttpResponse *response, NSURL *filePath, NSError *error))completionHandler;


- (TTHttpTask *)downloadTaskBySlice:(NSString *)URLString
                         parameters:(id)parameters
                        headerField:(NSDictionary *)headerField
                   needCommonParams:(BOOL)needCommonParams
                  requestSerializer:(Class<TTHTTPRequestSerializerProtocol>)requestSerializer
                   progressCallback:(void (^)(int64_t current, int64_t total))progressCallback
                        destination:(NSURL *)destination
                         autoResume:(BOOL)autoResume
                  completionHandler:(void (^)(TTHttpResponse *response, NSURL *filePath, NSError *error))completionHandler;


- (TTHttpTask *)requestForBinaryWithStreamTask:(NSString *)URL
                                        params:(id)params
                                        method:(NSString *)method
                              needCommonParams:(BOOL)commonParams
                                   headerField:(NSDictionary *)headerField
                               enableHttpCache:(BOOL)enableHttpCache
                                    autoResume:(BOOL)autoResume
                                dispatch_queue:(dispatch_queue_t)dispatch_queue;

- (void)clearHttpCache;

- (int64_t)getHttpDiskCacheSize;

- (void)setHttpDiskCacheSize:(int)size;

- (void)setNetworkQualityObserverBlock:(GetNqeResultBlock)getNqeResultBlock;

- (void)setPacketLossObserverBlock:(GetPacketLossResultBlock)block;

- (void)changeNetworkThreadPriority:(double)priority;

- (void)tryStartNetDetect:(NSArray<NSString *> *)urls
                  timeout:(NSInteger)timeout
                  actions:(NSInteger)actions;

- (TTDnsResult*)ttDnsResolveWithHost:(NSString*)host
                               sdkId:(int)sdkId;

- (BOOL)enableTTBizHttpDns:(BOOL)enable
                   domain:(NSString*)domain
                   authId:(NSString*)authId
                  authKey:(NSString*)authKey
                  tempKey:(BOOL)tempKey
         tempKeyTimestamp:(NSString*)tempKeyTimestamp;

@end


