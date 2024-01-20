
#import <Foundation/Foundation.h>

@interface TTCaseInsenstiveDictionary<__covariant KeyType, __covariant ObjectType> : NSMutableDictionary<KeyType, ObjectType> {
    NSMutableDictionary<KeyType, ObjectType> *inner_dict;
}

@end

@interface TTHttpResponseTimingInfo : NSObject

@property (nonatomic, strong, readonly) NSDate *start;
@property (nonatomic, assign, readonly) int64_t proxy;
@property (nonatomic, assign, readonly) int64_t dns;
@property (nonatomic, assign, readonly) int64_t connect;
@property (nonatomic, assign, readonly) int64_t ssl;
@property (nonatomic, assign, readonly) int64_t send;
@property (nonatomic, assign, readonly) int64_t wait;
@property (nonatomic, assign, readonly) int64_t receive;
@property (nonatomic, assign, readonly) int64_t total;

@property (nonatomic, assign, readonly) int64_t receivedResponseContentLength;

@property (nonatomic, assign, readonly) int64_t totalReceivedBytes;

@property (nonatomic, assign, readonly) BOOL isSocketReused;
@property (nonatomic, assign, readonly) BOOL isCached;
@property (nonatomic, assign, readonly) BOOL isFromProxy;
@property (nonatomic, copy,   readonly) NSString *remoteIP;
@property (nonatomic, assign, readonly) uint16_t remotePort;

@end

@interface TTHttpResponse : NSObject

/*!
 @property statusCode
 @abstract Returns the HTTP status code of the receiver.
 @result The HTTP status code of the receiver.
 */
@property (readonly) NSInteger statusCode;

/*!
 @property allHeaderFields
 @abstract Returns a dictionary containing all the HTTP header fields
 of the receiver.
 @discussion By examining this header dictionary, clients can see
 the "raw" header information which was reported to the protocol
 implementation by the HTTP server. This may be of use to
 sophisticated or special-purpose HTTP clients.
 @result A dictionary containing all the HTTP header fields of the
 receiver.
 */
@property (nullable, readonly, copy) TTCaseInsenstiveDictionary *allHeaderFields;

/*!
 @property URL
 @abstract Returns the URL of the receiver.
 @result The URL of the receiver.
 */
@property (nullable, readonly, copy) NSURL *URL;

/*!
 @propertys MIMEType
 @abstract Returns the MIME type of the receiver.
 @discussion The MIME type is based on the information provided
 from an origin source. However, that value may be changed or
 corrected by a protocol implementation if it can be determined
 that the origin server or source reported the information
 incorrectly or imprecisely. An attempt to guess the MIME type may
 be made if the origin source did not report any such information.
 @result The MIME type of the receiver.
 */
@property (nullable, readonly, copy) NSString *MIMEType;

@property (readonly, assign) BOOL isInternalRedirect;

@property (readonly, strong) TTHttpResponseTimingInfo *timinginfo;

@end
