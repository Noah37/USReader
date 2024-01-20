
#import "TTRequestModel.h"
#import "TTNetworkDefine.h"
#import "TTHttpRequest.h"

@protocol TTHTTPRequestSerializerProtocol <NSObject>


+ (NSObject<TTHTTPRequestSerializerProtocol> *)serializer;


- (TTHttpRequest *)URLRequestWithRequestModel:(TTRequestModel *)requestModel
                                       commonParams:(NSDictionary *)commonParam;


- (TTHttpRequest *)URLRequestWithURL:(NSString *)URL
                                    params:(id)params
                                    method:(NSString *)method
                     constructingBodyBlock:(TTConstructingBodyBlock)bodyBlock
                              commonParams:(NSDictionary *)commonParam;


- (TTHttpRequest *)URLRequestWithURL:(NSString *)URL
                               headerField:(NSDictionary *)headField
                                    params:(NSDictionary *)params
                                    method:(NSString *)method
                     constructingBodyBlock:(TTConstructingBodyBlock)bodyBlock
                              commonParams:(NSDictionary *)commonParam;


- (NSString *)userAgentString;


@end
