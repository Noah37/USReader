//
//  USReaderSettingView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderSettingView.h"
#import "USReaderMenu.h"
#import <Masonry/Masonry.h>
#import "USReaderButton.h"

@interface USReaderSettingView ()

@property (nonatomic, strong) USReaderButton *animationButton;
@property (nonatomic, strong) USReaderButton *automaticButton;
@property (nonatomic, strong) USReaderButton *eyeButton;
@property (nonatomic, strong) USReaderButton *moreButton;

@property (nonatomic, strong) UIStackView *container;

@end

@implementation USReaderSettingView

- (void)setupSubviews {
    [super setupSubviews];
    [self addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(16);
        make.top.inset(0);
        make.bottom.inset(KBottomSafeAreaHeight);
    }];
    
    [self.container addArrangedSubview:self.animationButton];
    [self.container addArrangedSubview:self.automaticButton];
    [self.container addArrangedSubview:self.eyeButton];
    [self.container addArrangedSubview:self.moreButton];
    
    [self.animationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
    [self.automaticButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
}

- (void)clickAnimation {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickCatalogue:)]) {
        [self.readerMenu.delegate readMenuClickEffect:self.readerMenu];
    }
}

- (void)clickAutomatic {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickComment:)]) {
        [self.readerMenu.delegate readMenuClickComment:self.readerMenu];
    }
}

- (void)clickEye {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickDayAndNight:)]) {
        [self.readerMenu.delegate readMenuClickDayAndNight:self.readerMenu];
    }
}

- (void)clickMoreSetting {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickSetting:)]) {
        [self.readerMenu.delegate readMenuClickSetting:self.readerMenu];
    }
}

#pragma mark - getter
- (USReaderButton *)animationButton {
    if (!_animationButton) {
        _animationButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_animationButton setImage:USAssetImage(@"animation") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_animationButton setTitle:@"翻页动画" forState:UIControlStateNormal];
        [_animationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_animationButton addTarget:self action:@selector(clickAnimation) forControlEvents:UIControlEventTouchUpInside];
        _animationButton.tintColor = [UIColor whiteColor];
    }
    return _animationButton;
}

- (USReaderButton *)automaticButton {
    if (!_automaticButton) {
        _automaticButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_automaticButton setImage:USAssetImage(@"automatic") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_automaticButton setTitle:@"自动阅读" forState:UIControlStateNormal];
        [_automaticButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_automaticButton addTarget:self action:@selector(clickAutomatic) forControlEvents:UIControlEventTouchUpInside];
        _automaticButton.tintColor = [UIColor whiteColor];
    }
    return _automaticButton;
}

- (USReaderButton *)eyeButton {
    if (!_eyeButton) {
        _eyeButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_eyeButton setImage:USAssetImage(@"eye") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_eyeButton setTitle:@"护眼模式" forState:UIControlStateNormal];
        [_eyeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eyeButton addTarget:self action:@selector(clickEye) forControlEvents:UIControlEventTouchUpInside];
        _eyeButton.tintColor = [UIColor whiteColor];
    }
    return _eyeButton;
}

- (USReaderButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_moreButton setImage:USAssetImage(@"more_horizonal") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_moreButton setTitle:@"更多设置" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(clickMoreSetting) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.tintColor = [UIColor whiteColor];
    }
    return _moreButton;
}

- (UIStackView *)container {
    if (!_container) {
        _container = [[UIStackView alloc] init];
        _container.axis = UILayoutConstraintAxisHorizontal;
        _container.spacing = 10;
        _container.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _container;
}

@end
