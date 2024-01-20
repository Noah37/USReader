
#import "TTHTTPRequestSerializerProtocol.h"

@interface TTHTTPRequestSerializerBase : NSObject<TTHTTPRequestSerializerProtocol>

+ (TTHttpRequest *)hashRequest:(TTHttpRequest *)request body:(NSData *)body;

@end
