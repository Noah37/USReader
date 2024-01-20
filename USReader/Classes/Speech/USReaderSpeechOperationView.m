//
//  USReaderSpeechOperationView.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/10.
//

#import "USReaderSpeechOperationView.h"
#import "USConstants.h"
#import <Masonry/Masonry.h>
#import "USReaderSpeechConfig.h"
#import "ASValueTrackingSlider.h"

@interface USReaderSpeechOperationView ()<ASValueTrackingSliderDataSource,ASValueTrackingSliderDelegate>

@property (nonatomic, strong) UIButton *idlButton;
@property (nonatomic, strong) UIButton *speedButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *carButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIButton *slowButton;
@property (nonatomic, strong) UIButton *quickButton;
@property (nonatomic, strong) ASValueTrackingSlider *progressSlider;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIButton *shelfButton;
@property (nonatomic, strong) UIButton *nextChapterButton;
@property (nonatomic, strong) UIButton *previousChapterButton;
@property (nonatomic, strong) UIButton *pauseButton;

@property (nonatomic, strong) UIButton *catelogButton;

@property (nonatomic, strong) UIButton *speakersButton;

@property (nonatomic, strong) USReaderTime *totalTime;
@property (nonatomic, strong) USReaderTime *currentTime;


@end

@implementation USReaderSpeechOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)reloadData {
    NSString *nickName = [USReaderSpeechConfig sharedConfig].currentSpeaker.getCurrentName;
    [_speakersButton setTitle:[NSString stringWithFormat:@"朗读音色·%@", nickName] forState:UIControlStateNormal];
}

- (void)setDuration:(USReaderTime *)duration currentTime:(USReaderTime *)currentTime {
    if (duration && currentTime) {
        _totalTime = duration;
        _currentTime = currentTime;
        self.progressLabel.text = [NSString stringWithFormat:@"%@/%@", currentTime.minuteStringValue, duration.minuteStringValue];
        self.progressSlider.value = currentTime.value.doubleValue/duration.value.doubleValue;
    } else {
        self.progressLabel.text = @"--:--/--:--";
        self.progressSlider.value = 0.0;
    }
}

- (void)setupSubviews {
    self.userInteractionEnabled = YES;
    [self addSubview:self.speakersButton];
    [self.speakersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.speakersButton.superview).offset(-44);
        make.centerX.equalTo(self.speakersButton.superview);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pauseButton.superview);
        make.bottom.equalTo(self.speakersButton.mas_top).offset(-30);
        make.width.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.previousChapterButton];
    [self.previousChapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pauseButton.mas_left).offset(-40);
        make.centerY.equalTo(self.pauseButton.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.shelfButton];
    [self.shelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shelfButton.superview).offset(16);
        make.centerY.equalTo(self.pauseButton.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.nextChapterButton];
    [self.nextChapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pauseButton.mas_right).offset(40);
        make.centerY.equalTo(self.pauseButton.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.catelogButton];
    [self.catelogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.catelogButton.superview).offset(-16);
        make.centerY.equalTo(self.pauseButton.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.slowButton];
    [self.slowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.bottom.equalTo(self.pauseButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.quickButton];
    [self.quickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(16);
        make.bottom.equalTo(self.pauseButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.quickButton.mas_left).offset(-5);
        make.centerY.equalTo(self.quickButton.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(80);
    }];
    
    [self addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slowButton.mas_right).offset(16);
        make.right.equalTo(self.progressLabel.mas_left).offset(-5);
        make.bottom.equalTo(self.pauseButton.mas_top).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat idlMarginX = 16;
    CGFloat idlWidth = 40;
    CGFloat idlSpace = (kScreenWidth - idlWidth * 5 - idlMarginX*2)/4;
    
    [self addSubview:self.idlButton];
    [self.idlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idlButton.superview).offset(idlMarginX);
        make.bottom.equalTo(self.slowButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(idlWidth);
    }];
    
    [self addSubview:self.speedButton];
    [self.speedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idlButton.mas_right).offset(idlSpace);
        make.bottom.equalTo(self.slowButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(idlWidth);
    }];
    
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedButton.mas_right).offset(idlSpace);
        make.bottom.equalTo(self.slowButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(idlWidth);
    }];
    
    [self addSubview:self.carButton];
    [self.carButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right).offset(idlSpace);
        make.bottom.equalTo(self.slowButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(idlWidth);
    }];
    
    [self addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.superview).offset(-idlMarginX);
        make.bottom.equalTo(self.quickButton.mas_top).offset(-20);
        make.width.height.mas_equalTo(idlWidth);
        make.top.equalTo(self.moreButton.superview);
    }];
}

- (void)idlAction {
    
}

- (void)speedAction {
    
}

- (void)commentAction {
    
}

- (void)carAction {
    
}

- (void)moreAction {
    
}

- (void)slowAction {
    CGFloat totalTimeInterval = self.totalTime.value.doubleValue;
    CGFloat currentTimeInterval = totalTimeInterval * self.progressSlider.value - 15;
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationView:progressDidChange:)]) {
        [self.delegate USReaderSpeechOperationView:self progressDidChange:currentTimeInterval];
    }
}

- (void)quickAction {
    CGFloat totalTimeInterval = self.totalTime.value.doubleValue;
    CGFloat currentTimeInterval = totalTimeInterval * self.progressSlider.value + 15;
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationView:progressDidChange:)]) {
        [self.delegate USReaderSpeechOperationView:self progressDidChange:currentTimeInterval];
    }
}

- (void)progressChangeAction {
    CGFloat totalTimeInterval = self.totalTime.value.doubleValue;
    CGFloat currentTimeInterval = totalTimeInterval * self.progressSlider.value;
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationView:progressDidChange:)]) {
        [self.delegate USReaderSpeechOperationView:self progressDidChange:currentTimeInterval];
    }
}

- (void)shelfAction {
    
}

- (void)nextChapterAction {
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationViewClickNext:)]) {
        [self.delegate USReaderSpeechOperationViewClickNext:self];
    }
}

- (void)previousChapterAction {
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationViewClickPrevious:)]) {
        [self.delegate USReaderSpeechOperationViewClickPrevious:self];
    }
}

- (void)pauseAction {
    if (self.pauseButton.selected) {
        if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationViewClickPause:)]) {
            [self.delegate USReaderSpeechOperationViewClickPause:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationViewClickStart:)]) {
            [self.delegate USReaderSpeechOperationViewClickStart:self];
        }
    }
}

- (void)catelogAction {
    
}

- (void)speakersAction {
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationViewClickSpeakers:)]) {
        [self.delegate USReaderSpeechOperationViewClickSpeakers:self];
    }
}

#pragma mark - ASValueTrackingSliderDataSource
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    CGFloat totalTimeInterval = self.totalTime.value.doubleValue;
    CGFloat currentTimeInterval = totalTimeInterval * value;
    return [USReaderTime timeWithNumber:[NSNumber numberWithDouble:currentTimeInterval]].minuteStringValue;
}

#pragma mark - ASValueTrackingSliderDelegate
- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider {
    if ([self.delegate respondsToSelector:@selector(USReaderSpeechOperationView:progressWillChange:)]) {
        [self.delegate USReaderSpeechOperationView:self progressWillChange:slider.value];
    }
}

- (void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider {
    [self progressChangeAction];
}

- (void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider {
    
}

#pragma mark - getter
- (UIButton *)idlButton {
    if (!_idlButton) {
        _idlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_idlButton setImage:USAssetImage(@"idl") forState:UIControlStateNormal];
        [_idlButton addTarget:self action:@selector(idlAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _idlButton;
}

- (UIButton *)speedButton {
    if (!_speedButton) {
        _speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speedButton setImage:USAssetImage(@"speed") forState:UIControlStateNormal];
        [_speedButton addTarget:self action:@selector(speedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:USAssetImage(@"comment") forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIButton *)carButton {
    if (!_carButton) {
        _carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carButton setImage:USAssetImage(@"car") forState:UIControlStateNormal];
        [_carButton addTarget:self action:@selector(carAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:USAssetImage(@"more_horizonal") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIButton *)slowButton {
    if (!_slowButton) {
        _slowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_slowButton setImage:USAssetImage(@"slow15_") forState:UIControlStateNormal];
        [_slowButton addTarget:self action:@selector(slowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slowButton;
}

- (UIButton *)quickButton {
    if (!_quickButton) {
        _quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quickButton setImage:USAssetImage(@"quick15") forState:UIControlStateNormal];
        [_quickButton addTarget:self action:@selector(quickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quickButton;
}

- (UIButton *)shelfButton {
    if (!_shelfButton) {
        _shelfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shelfButton setImage:USAssetImage(@"bookshelf") forState:UIControlStateNormal];
        [_shelfButton addTarget:self action:@selector(shelfAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shelfButton;
}

- (UIButton *)nextChapterButton {
    if (!_nextChapterButton) {
        _nextChapterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextChapterButton setImage:USAssetImage(@"next_chapter") forState:UIControlStateNormal];
        [_nextChapterButton addTarget:self action:@selector(nextChapterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextChapterButton;
}

- (UIButton *)previousChapterButton {
    if (!_previousChapterButton) {
        _previousChapterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousChapterButton setImage:USAssetImage(@"previous") forState:UIControlStateNormal];
        [_previousChapterButton addTarget:self action:@selector(previousChapterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousChapterButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:USAssetImage(@"pause_") forState:UIControlStateSelected];
        [_pauseButton setImage:USAssetImage(@"start") forState:UIControlStateNormal];
        [_pauseButton setImage:nil forState:UIControlStateHighlighted];
        [_pauseButton setImage:nil forState:UIControlStateDisabled];
        [_pauseButton addTarget:self action:@selector(pauseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UIButton *)catelogButton {
    if (!_catelogButton) {
        _catelogButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_catelogButton setImage:USAssetImage(@"catalog") forState:UIControlStateNormal];
        [_catelogButton addTarget:self action:@selector(catelogAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _catelogButton;
}

- (UIButton *)speakersButton {
    if (!_speakersButton) {
        _speakersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *nickName = [USReaderSpeechConfig sharedConfig].currentSpeaker.getCurrentName;
        [_speakersButton setTitle:[NSString stringWithFormat:@"朗读音色·%@", nickName] forState:UIControlStateNormal];
        _speakersButton.layer.cornerRadius = 10;
        _speakersButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _speakersButton.layer.borderWidth = 1.0;
        _speakersButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        [_speakersButton addTarget:self action:@selector(speakersAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speakersButton;
}

- (ASValueTrackingSlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[ASValueTrackingSlider alloc] init];
        _progressSlider.tintColor = [UIColor whiteColor];
        _progressSlider.thumbTintColor = [UIColor whiteColor];
        _progressSlider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _progressSlider.minimumTrackTintColor = [UIColor whiteColor];
        _progressSlider.popUpViewColor = [UIColor whiteColor];
        _progressSlider.textColor = [UIColor blackColor];
        _progressSlider.dataSource = self;
        _progressSlider.delegate = self;
        _progressSlider.maximumValue = 1.0;
        _progressSlider.minimumValue = 0.0;
//        [_progressSlider addTarget:self action:@selector(progressChangeAction) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.text = @"--:--/--:--";
    }
    return _progressLabel;
}

@end
