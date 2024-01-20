
#import <Foundation/Foundation.h>
#import "TTHttpResponse.h"

@interface TTHttpResponseChromiumTimingInfo : TTHttpResponseTimingInfo

@end

@interface TTHttpResponseChromium : TTHttpResponse

@property (atomic, strong, readonly) TTHttpResponseChromiumTimingInfo *timingInfo;
@property (atomic, copy,   readonly) NSString *requestLog;

- (instancetype)initWithRedirectedInfo:(NSString *)current_url
                          new_location:(NSString *)new_location
                           status_code:(int)status_code
                      response_headers:(TTCaseInsenstiveDictionary*)response_headers
                  is_internal_redirect:(BOOL)is_internal_redirect;
@end
