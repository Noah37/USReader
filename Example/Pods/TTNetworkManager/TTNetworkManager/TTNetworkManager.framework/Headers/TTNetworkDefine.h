
#import "TTResponseModelProtocol.h"
#import "TTHttpMultipartFormData.h"
@class TTHttpResponse;
@class TTDnsResult;

#ifndef TTNetworkManager_TTNetworkDefine_h
#define TTNetworkManager_TTNetworkDefine_h

#pragma mark -- callback block
#pragma mark -- response block


typedef void (^TTNetworkResponseModelFinishBlock)(NSError *error, NSObject<TTResponseModelProtocol> * responseModel);


typedef void (^TTNetworkJSONFinishBlock)(NSError *error, id jsonObj);

typedef void (^TTNetworkJSONFinishBlockWithResponse)(NSError *error, id obj, TTHttpResponse *response);

typedef void (^TTNetworkObjectFinishBlock)(NSError *error, id obj);

typedef void (^TTNetworkObjectFinishBlockWithResponse)(NSError *error, id obj, TTHttpResponse *response);

typedef void (^TTNetworkChunkedDataHeaderBlock)(TTHttpResponse *response);

typedef void (^TTNetworkChunkedDataReadBlock)(NSData* obj);

typedef void (^TTNetworkURLRedirectBlock)(NSString *new_location, TTHttpResponse *old_repsonse);

#pragma mark -- callback block
#pragma mark -- Download progress callback block

typedef void (^TTNetObjectProgressBlock)(int progress);

#pragma mark -- rqeuest block block

/**
 *
 *  if the request body contains file, this block will be called.
 *
 *  @param formData used to build request body which contains file.
 */
typedef void (^TTConstructingBodyBlock)(id<TTMultipartFormData> formData);

#pragma mark -- error

#define kTTNetworkCustomErrorKey @"kTTNetworkCustomErrorKey"
#define kTTNetworkErrorDomain @"kTTNetworkErrorDomain"
#define kTTNetworkUserinfoTipKey @"kTTNetworkUserinfoTipKey"

#define kTTNetworkErrorTipNoNetwork @"No Network"
#define kTTNetworkErrorTipNetworkError @"Network Error"
#define kTTNetworkErrorTipServerError @"Server Error"
#define kTTNetworkErrorTipParseJSONError @"ParseJSON Error"
#define kTTNetworkErrorTipNetworkHijacked  @"Network Hijacked"
/**
 * Error code description.
 */
typedef NS_ENUM(NSInteger, TTNetworkErrorCode){
    // The json data returned by server is not dict format.
    TTNetworkErrorCodeNetworkJsonResultNotDictionary = -99,
    // The request has been dropped when user set drop header (cli_need_drop_request:1)
    TTNetworkErrorCodeDropClientRequest = -98,

    // The self-defined error code starts with -9.

    /**
     *  CDN cache error.
     */
    TTNetworkErrorCodeCdnCache = -9,

    /**
     * when enableApiHttpIntercept is set, |api http| in api_http_host_list has been intercepted and
     * report monitor log.
     */
    TTNetworkErrorCodeApiHttpIntercepted = -8,

    /**
     * State is error in client side (such as not initialization)
     */
    TTNetworkErrorCodeIllegalClientState = -7,
    
    /**
     * invalid request url
     */
    TTNetworkErrorCodeBadURLRequest = -6,
    
    /**
     * network has been hijacked.
     */
    TTNetworkErrorCodeNetworkHijacked = -5,
    /**
     *  json parsed failed.
     */
    TTNetworkErrorCodeParseJSONError = -4,
    /**
     * Sever has some errors.
     */
    TTNetworkErrorCodeServerError = -3,
    /**
     * Connection errors.
     */
    TTNetworkErrorCodeNetworkError = -2,
    /**
     * Network is not available.
     */
    TTNetworkErrorCodeNoNetwork = -1,
    /**
     * No error. Success.
     */
    TTNetworkErrorCodeSuccess = 0,

    // The following error codes start with 1 are same with Android's.
    
    TTNetworkErrorCodeUnknown = 1,
    TTNetworkErrorCodeConnectTimeOut = 2,
    TTNetworkErrorCodeSocketTimeOut = 3,
    TTNetworkErrorCodeIOException = 4,
    TTNetworkErrorCodeSocketException = 5,
    TTNetworkErrorCodeResetByPeer = 6,
    TTNetworkErrorCodeBindException = 7,
    TTNetworkErrorCodeConnectExceptioin = 8,
    TTNetworkErrorCodeNoReouteToHost = 9,
    TTNetworkErrorCodeProtUnreachable = 10,
    TTNetworkErrorCodeUnknonwHost = 11,
    
    //errno
    TTNetworkErrorCodeECONNRESET = 12,
    TTNetworkErrorCodeECONNREFUSED = 13,
    TTNetworkErrorCodeEHOSTUNREACH = 14,
    TTNetworkErrorCodeENETUNREACH = 15,
    TTNetworkErrorCodeEADDRNOTAVAIL = 16,
    TTNetworkErrorCodeEADDRINUSE = 17,
    
    TTNetworkErrorCodeNoHttpResponse = 18,
    TTNetworkErrorCodeClientProtocolException = 19,
    TTNetworkErrorCodeFileTooLarge = 20,
    TTNetworkErrorCodeTooManyRedirect = 21,
    
    TTNetworkErrorCodeUnknowClientError = 31,
    TTNetworkErrorCodeNoSpace = 32,
    
    // errno
    TTNetworkErrorCodeENOENT = 33, //no such file or directory
    TTNetworkErrorCodeEDQUOT = 34, //exceed disk quota
    TTNetworkErrorCodeEROFS = 35,
    TTNetworkErrorCodeEACCES = 36, //permission denyed
    TTNetworkErrorCodeEIO = 37
};
#define CPPSTR(str) str == nil ? "" : str.UTF8String

#endif
