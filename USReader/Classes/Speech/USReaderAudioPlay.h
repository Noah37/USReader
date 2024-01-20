//
//  USReaderAudioPlay.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import <Foundation/Foundation.h>
#import "USReaderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderAudioPlay : NSObject

+ (instancetype)sharedPlay;

- (void)playRecord:(USReaderRecordModel *)record;

@end

NS_ASSUME_NONNULL_END
