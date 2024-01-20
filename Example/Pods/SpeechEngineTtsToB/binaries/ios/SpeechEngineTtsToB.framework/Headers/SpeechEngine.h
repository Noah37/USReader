//
//  SpeechEngine.h
//  SpeechEngine
//
//  Created by fangweiwei on 2019/12/6.
//  Copyright © 2019 fangweiwei. All rights reserved.
//

#ifndef SpeechEngine_H
#define SpeechEngine_H

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SpeechEngineDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SpeechEngineDelegate<NSObject>

/// Callback of speech engine.
/// @param type Message type, SEMessageType, defined in SpeechEngineDefines.h.
/// @param data Message data, should be processed according to the message type.
- (void)onMessageWithType:(SEMessageType)type andData:(NSData *)data;

@end

@interface SpeechEngine : NSObject

- (void)onMessageWithType:(SEMessageType)type andData:(NSData *)data;

/// Prepare environment.  This method should be invoked in didFinishLaunchingWithOptions
/// @return Success or not.
+ (BOOL)prepareEnvironment;

/// Create speech engine instance.
/// @param delegate SpeechEngineDelegate, callback impletemented by caller.
/// @return Success or not.
- (BOOL)createEngineWithDelegate:(nullable id<SpeechEngineDelegate>)delegate;

/// Change speech engine's delegate.
/// @param delegate SpeechEngineDelegate, callback impletemented by caller.
- (void)setDelegate:(id<SpeechEngineDelegate>)delegate;

/// Destroy speech engine instance.
- (void)destroyEngine;

/// Set view to render for rtc video stream.
/// @param remoteView UIView.
- (void)setRemoteView:(UIView *)remoteView;

/// Set BOOL params, type can be dertermained from key.
/// @param boolParam BOOL param.
/// @param key Param key defined in SpeechEngineDefines.h.
- (void)setBoolParam:(BOOL)boolParam forKey:(const NSString *)key;

/// Set int params, type can be dertermained from key.
/// @param intParam Int param.
/// @param key Param key defined in SpeechEngineDefines.h.
- (void)setIntParam:(NSInteger)intParam forKey:(const NSString *)key;

/// Set NSString params, type can be dertermained from key.
/// @param stringParam NSString param.
/// @param key Param key defined in SpeechEngineDefines.h.
- (void)setStringParam:(NSString *)stringParam forKey:(const NSString *)key;

/// Get speech engine version.
/// @return NSString, version info.
- (NSString *)getVersion;

/// Check if engine type is supported.
/// @return bool, supported or not.
- (bool)isEngineSupported:(NSString *)engineName;

/// Init speech engine.
/// @return SEEngineErrorCode, 0 means sucess.
- (SEEngineErrorCode)initEngine;

/// Send directive to speech engine, directive means a special function.
/// @param directive SEDirective, defined in SpeechEngineDefines.h.
/// @return SEEngineErrorCode, 0 means sucess.
- (SEEngineErrorCode)sendDirective:(SEDirective)directive;

/// Send directive to speech engine, directive means a special function.
/// @param directive SEDirective, defined in SpeechEngineDefines.h.
/// @param data NSString, needed by directive, can't be nil.
/// @return SEEngineErrorCode, 0 means sucess.
- (SEEngineErrorCode)sendDirective:(SEDirective)directive data:(NSString*)data;


/// Feed audio data into speech engine.
/// @param audio audio data.
/// @param lenght audio data length.
/// @return SEEngineErrorCode, 0 means sucess.
- (SEEngineErrorCode)feedAudio:(int16_t *)audio length:(int32_t)length;

/// Processs audio data.
/// @param audio audio data.
/// @param length audio data length.
/// @param isFinal if audio is final.
/// @return SEEngineErrorCode, 0 means sucess.
- (SEEngineErrorCode)ProcessAudio:(int16_t *)audio length:(int32_t)length isFinal:(BOOL)isFinal;

/// Reset speech engine.
/// @return SEEngineErrorCode, 0 means success.
- (SEEngineErrorCode)ResetEngine;

/// Fetch result from speech engine.
/// @param result Binary result.
/// @return SEEngineErrorCode, 0 means success.
- (SEEngineErrorCode)FetchResult:(NSData **)result;

/// Fetch result from speech engine.
/// @param result Binary result.
/// @return SEEngineErrorCode, 0 means success.
- (SEEngineErrorCode)FetchResult:(SEResultType)type result:(NSData **)result;

@end

NS_ASSUME_NONNULL_END

#endif // SpeechEngine_H
