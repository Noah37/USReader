
#import <Foundation/Foundation.h>
#import "TTResponseModelProtocol.h"
#import "TTRequestModel.h"

#import "TTHttpRequest.h"
#import "TTHttpResponse.h"

#pragma mark -- JSON response


@protocol TTJSONResponseSerializerProtocol <NSObject>

@required


@property (nonatomic, copy) NSSet *acceptableContentTypes;


+ (NSObject<TTJSONResponseSerializerProtocol> *)serializer;


- (id)responseObjectForResponse:(TTHttpResponse *)response
                        jsonObj:(id)jsonObj
                  responseError:(NSError *)responseError
                    resultError:(NSError *__autoreleasing *)resultError;

@end

#pragma mark -- responseModel response


@protocol TTResponseModelResponseSerializerProtocol <NSObject>


+ (NSObject<TTResponseModelResponseSerializerProtocol> *)serializer;

- (NSObject<TTResponseModelProtocol> *)responseObjectForResponse:(TTHttpResponse *)response
                                                         jsonObj:(id)jsonObj
                                                    requestModel:(TTRequestModel *)requestModel
                                                   responseError:(NSError *)responseError
                                                     resultError:(NSError *__autoreleasing *)resultError;
@end

#pragma mark -- binary response


@protocol TTBinaryResponseSerializerProtocol <NSObject>


+ (NSObject<TTBinaryResponseSerializerProtocol> *)serializer;


- (id)responseObjectForResponse:(TTHttpResponse *)response
                           data:(NSData *)data
                  responseError:(NSError *)responseError
                    resultError:(NSError *__autoreleasing *)resultError;

@end



@protocol TTResponsePreProcessorProtocol <NSObject>

+ (NSObject<TTResponsePreProcessorProtocol> *)processor;
- (void)preprocessWithResponse:(TTHttpResponse *)response
                responseObject:(id *)responseObject
                         error:(NSError **)error
                    ForRequest:(TTHttpRequest *)request;
- (void)finishPreprocess;

@property (nonatomic, assign, readonly) BOOL needsRetry;
@property (nonatomic, assign, readonly) BOOL alertHijack;
@property (nonatomic, strong, readonly) TTHttpRequest *retryRequest;
@property (nonatomic, assign, readonly) NSUInteger retryTimes;


@end

