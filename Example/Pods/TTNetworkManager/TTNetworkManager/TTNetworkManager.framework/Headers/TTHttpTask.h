
#import <Foundation/Foundation.h>

#import "TTHttpResponse.h"
#import "TTHttpRequest.h"

typedef NS_ENUM(NSInteger, TTHttpTaskState) {
    TTHttpTaskStateRunning   = 0,
    TTHttpTaskStateSuspended = 1,
    TTHttpTaskStateCanceling = 2,
    TTHttpTaskStateCompleted = 3,
};

@interface TTHttpTask : NSObject

/*
 * The current state of the task.
 */
@property (readonly) TTHttpTaskState state;

/*
 * Set the timeout for detailed phases of a request.
 * They are effective only when corresponding callback is used
 * to initiate a request.
 */
@property (nonatomic, assign) NSTimeInterval recvHeaderTimeout;
@property (nonatomic, assign) NSTimeInterval readDataTimeout;

/*
 * Set the request protect timeout for per task request.
 * cancel the request when duration of request has reached
 * the protectTimeout. unit: seconds.
 */
@property (nonatomic, assign) NSTimeInterval protectTimeout;

/*
 * Set the timeout for per task request.
 * NOTE: this value overwrite the request's timeoutInteval if both exist.
 */
@property (assign) NSTimeInterval timeoutInterval;

/*
 * YES to skip the ssl certificate error.
 */
@property (assign) BOOL skipSSLCertificateError;

/*
 * YES means task working in stream mode. Call readDataOfMinLength to
 * retreive data.
 */
@property (assign) BOOL isStreamingTask;

/**
 * Set http cache.
 * YES : open the current task Http Cache.
 * NO : close the current task Http Cache.
 */
@property (nonatomic, assign) BOOL enableHttpCache;

/* -cancel returns immediately, but marks a task as being canceled
 */
- (void)cancel;

/*
 * Not implemented
 */
- (void)suspend;

/*
 * start a task
 */
- (void)resume;

- (void)setThrottleNetSpeed:(int64_t)bytesPerSecond;

/*
 * Sets a scaling factor for the priority of the task. The scaling factor is a
 * value between 0.0 and 1.0 (inclusive), where 0.0 is considered the lowest
 * priority and 1.0 is considered the highest.
 *
 * The priority is a hint and not a hard requirement of task performance. The
 * priority of a task may be changed using this API at any time, but not all
 * protocols support this; in these cases, the last priority that took effect
 * will be used.
 *
 * If no priority is specified, the task will operate with the default priority
 * as defined by the constant NSURLSessionTaskPriorityDefault. Two additional
 * priority levels are provided: NSURLSessionTaskPriorityLow and
 * NSURLSessionTaskPriorityHigh, but use is not restricted to these.
 */
- (void)setPriority:(float)priority;

/**
 *  （Actively）Read response from a task.
 *  Only supported by stream mode task , otherwise exception will be thrown.
 *  Use requestForBinaryWithStreamTaskTask will set the task mode into stream mode automatically.
 *
 *  @param minBytes                Least bytes of response in callback(>)
 *  @param maxBytes                Max bytes of response in callback(<=)，note that maxBytes will influence the buffer in iOS layer
 *  @param timeout                 Timeout of the callback
 *  @param completionHandler       Callback when data is read.
 */
- (void)readDataOfMinLength:(NSUInteger)minBytes
                  maxLength:(NSUInteger)maxBytes
                    timeout:(NSTimeInterval)timeout
          completionHandler:(void (^)(NSData *data, BOOL atEOF, NSError *error, TTHttpResponse *response))completionHandler;

/**
 *get request in task
 *so that user can task action on this request, such as set customized headers
 *autoResume must set to NO when get task, and call [task resume] to start network task after this
 */
- (TTHttpRequest *)request;

@end
