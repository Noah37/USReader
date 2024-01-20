//
//  USReaderSpeechOperationView.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/10.
//

#import <UIKit/UIKit.h>
#import "USReaderAudioPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@class USReaderSpeechOperationView;
@protocol USReaderSpeechOperationViewDelegate <NSObject>

- (void)USReaderSpeechOperationViewClickSpeakers:(USReaderSpeechOperationView *)operationView;
- (void)USReaderSpeechOperationViewClickStart:(USReaderSpeechOperationView *)operationView;
- (void)USReaderSpeechOperationViewClickPause:(USReaderSpeechOperationView *)operationView;
- (void)USReaderSpeechOperationViewClickNext:(USReaderSpeechOperationView *)operationView;
- (void)USReaderSpeechOperationViewClickPrevious:(USReaderSpeechOperationView *)operationView;
- (void)USReaderSpeechOperationView:(USReaderSpeechOperationView *)operationView progressWillChange:(CGFloat)progress;
- (void)USReaderSpeechOperationView:(USReaderSpeechOperationView *)operationView progressDidChange:(CGFloat)progress;

@end

@interface USReaderSpeechOperationView : UIView

@property (nonatomic, strong, readonly) UIButton *pauseButton;

@property (nonatomic, weak) id <USReaderSpeechOperationViewDelegate>delegate;

- (void)reloadData;

- (void)setDuration:(USReaderTime *)duration currentTime:(USReaderTime *)currentTime;

@end

NS_ASSUME_NONNULL_END
