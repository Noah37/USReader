//
//  USReaderSpeakersViewController.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import <UIKit/UIKit.h>
#import "USReaderSpeaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderSpeakersViewController : UIViewController

@property (nonatomic, copy) void(^speakerChanged)(USReaderSpeaker *speaker);

@end

NS_ASSUME_NONNULL_END
