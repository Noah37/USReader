
#import <Foundation/Foundation.h>

extern NSString * const Key;
extern int g_request_timeout;
extern int g_request_count_network_changed;


#ifndef isEmptyStringForNetworkUtil
#define isEmptyStringForNetworkUtil(str) (!str || ![str isKindOfClass:[NSString class]] || str.length == 0)
#endif

#define ENABLE_PARAMS_ENCRYPTION


typedef void(^TTDelayedBlockHandle)(BOOL cancel);


@interface TTNetworkUtil : NSObject

+ (NSURL *)URLWithURLString:(NSString *)str;

+ (NSURL *)URLWithURLString:(NSString *)str baseURL:(NSURL *)baseURL;

+ (NSString*)URLString:(NSString *)URLStr appendCommonParams:(NSDictionary *)commonParams;

+ (NSString *)filterSensitiveParams:(NSString *)inputUrl outputUrl:(NSString **)outputUrl onlyInHeader:(BOOL)onlyInHeader keepPlainQuery:(BOOL)keepPlainQuery;

+ (NSString *)md5Hex:(NSData *)data;

+ (TTDelayedBlockHandle)dispatchBlockAfterDelay:(int64_t)delta
                                          block:(dispatch_block_t)block;
+ (void)dispatchDelayedBlockImmediately:(TTDelayedBlockHandle)delayedHandle;

+ (NSString *)calculateFileMd5WithFilePath:(NSString *)filePath;

+ (NSString *)getNONEmptyString:(NSString*)str;

@end
