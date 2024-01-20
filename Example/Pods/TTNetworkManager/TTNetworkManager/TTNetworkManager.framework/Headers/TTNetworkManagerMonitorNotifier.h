
#import <Foundation/Foundation.h>

#import "TTHttpRequest.h"
#import "TTHttpResponse.h"

extern NSString * const kTTNetworkManagerMonitorStartNotification;

extern NSString * const kTTNetworkManagerMonitorFinishNotification;

extern NSString * const kTTNetworkManagerMonitorCdnCacheVerify;

extern NSString * const kTTNetworkManagerMonitorRequestKey;
extern NSString * const kTTNetworkManagerMonitorResponseKey;
extern NSString * const kTTNetworkManagerMonitorErrorKey;
extern NSString * const kTTNetworkManagerMonitorResponseDataKey;
extern NSString * const kTTNetworkManagerMonitorRequestTriedTimesKey;


@interface TTNetworkManagerMonitorNotifier : NSObject

+ (instancetype)defaultNotifier;


- (void)setEnable:(BOOL)enable;


- (void)notifyForMonitorStartRequest:(TTHttpRequest *)request hasTriedTimes:(NSInteger)triedTimes;


- (void)notifyForMonitorFinishResponse:(TTHttpResponse *)response
                            forRequest:(TTHttpRequest *)request
                                 error:(NSError *)error
                              response:(id)responseObj;

- (void)notifyCdnCacheVerifyResponse:(TTHttpResponse *)response
                          forRequest:(TTHttpRequest *)request
                          errorState:(NSError*)errorState;

@end
