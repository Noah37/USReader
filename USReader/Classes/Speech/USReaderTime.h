//
//  USReaderTime.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USReaderTime : NSObject

/**
 * factorize a time object with a given number object
 * \param aNumber the NSNumber object with a time in milliseconds
 * \return the VLCTime object
 */
+ (USReaderTime *_Nullable)timeWithNumber:(nullable NSNumber *)aNumber;
/**
 * factorize a time object with a given integer
 * \param aInt the int with a time in milliseconds
 * \return the VLCTime object
 */
+ (USReaderTime *_Nullable)timeWithInt:(int)aInt;

/**
 * init a time object with a given number object
 * \param aNumber the NSNumber object with a time in milliseconds
 * \return the VLCTime object
 */
- (instancetype _Nullable )initWithNumber:(nullable NSNumber *)aNumber;
/**
 * init a time object with a given integer
 * \param aInt the int with a time in milliseconds
 * \return the VLCTime object
 */
- (instancetype _Nullable )initWithInt:(int)aInt;


@property (nonatomic, strong, readonly, nullable) NSNumber * value;

/**
 * the current time value as string value localized for the current environment
 * \return the NSString object
 */
@property (readonly) NSString * _Nullable stringValue;
/**
 * the current time value as verbose string value localized for the current environment
 * \return the NSString object
 */
@property (readonly) NSString * _Nullable verboseStringValue;
/**
 * the current time value as string value localized for the current environment representing the time in minutes
 * \return the NSString object
 */
@property (readonly) NSString * _Nullable minuteStringValue;
/**
 * the current time value as int value
 * \return the int
 */
@property (readonly) int intValue;


@end

NS_ASSUME_NONNULL_END
