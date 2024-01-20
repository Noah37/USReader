
#import <Foundation/Foundation.h>
#import "TTNetworkManager.h"

@interface TTNetworkManagerChromium : TTNetworkManager

@property (nonatomic,copy) NSString *defaultUserAgent;

- (BOOL)ensureEngineStarted;
- (void *)getEngine;
- (void)setUserIdcInternal:(NSString *)userIdc;
- (void)setUserRegionInternal:(NSString *)userRegion;
- (void)setClientIPInternal:(NSString *)clientIP;
@end
