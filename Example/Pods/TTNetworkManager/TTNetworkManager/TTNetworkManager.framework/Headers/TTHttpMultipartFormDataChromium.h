
#import "TTHttpMultipartFormData.h"

@class TTHttpRequestChromium;

@interface TTHttpMultipartFormDataChromium : TTHttpMultipartFormData

- (NSData *)finalFormDataWithHttpRequest:(TTHttpRequestChromium *)request;
- (NSString *)getContentType;

@end
