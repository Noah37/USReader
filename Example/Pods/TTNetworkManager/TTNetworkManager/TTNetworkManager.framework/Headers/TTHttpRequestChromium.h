
#import <Foundation/Foundation.h>
#import "TTHttpRequest.h"
#import "TTHttpMultipartFormDataChromium.h"

@interface TTHttpRequestChromium : TTHttpRequest

@property (atomic, strong) TTHttpMultipartFormDataChromium *form;
@property (atomic, copy) NSString *urlString;
@property (atomic, strong) NSDictionary *params;


- (instancetype)initWithURL:(NSString *)url method:(NSString *)method multipartForm:(TTHttpMultipartFormDataChromium *)form;
- (void)setHTTPBodyNoCopy:(NSData *)HTTPBody;

@end
