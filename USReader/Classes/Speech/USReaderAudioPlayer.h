//
//  USReaderAudioPlayer.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/13.
//

#import <Foundation/Foundation.h>
#import "USReaderTime.h"
#import "TTSEngineManager.h"

@class USReaderRecordModel,USReaderAudioPlayer;
@protocol USReaderAudioPlayerDataSource <TTSEngineDataSource>

- (USReaderRecordModel *_Nullable)nextRecord;

@end

@protocol USReaderAudioPlayerDelegate <TTSBaseEngineDelegate>

- (void)USReaderAudioPlayer:(USReaderAudioPlayer *_Nullable)player playTime:(NSTimeInterval)playTime;

@end

NS_ASSUME_NONNULL_BEGIN

@interface USReaderAudioPlayer : NSObject

@property (nonatomic, weak) id <USReaderAudioPlayerDataSource>dataSource;

@property (nonatomic, weak) id <USReaderAudioPlayerDelegate>delegate;

@property (nonatomic, strong, readonly) USReaderTime *playedTime;

@property (nonatomic, strong, readonly) USReaderTime *totalTime;

/* This method starts the audio hardware synchronously (if not already running), and triggers the sound playback which is streamed asynchronously at the specified time in the future.
 Time is an absolute time based on and greater than deviceCurrentTime. */
- (BOOL)playAtTime:(NSTimeInterval)time API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0));

/* Pauses playback, but remains ready to play. */
- (void)pause;

/* Synchronously stops playback, no longer ready to play.
 NOTE: - This will block while releasing the audio hardware that was acquired upon calling play() or prepareToPlay() */
- (void)stop;

- (void)resume;

/* properties */

@property(readonly, getter=isPlaying) BOOL playing; /* is it playing or not? */

+ (instancetype)sharedPlayer;

- (void)playWithRecord:(USReaderRecordModel *)record;

@end

NS_ASSUME_NONNULL_END
