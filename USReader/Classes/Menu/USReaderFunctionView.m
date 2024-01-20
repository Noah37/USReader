//
//  USReaderFunctionView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderFunctionView.h"
#import "USReaderMenu.h"
#import <Masonry/Masonry.h>
#import "USReaderButton.h"

@interface USReaderFunctionView ()

@property (nonatomic, strong) USReaderMenu *readerMenu;

@property (nonatomic, strong) USReaderButton *catalogButton;
@property (nonatomic, strong) USReaderButton *commentButton;
@property (nonatomic, strong) USReaderButton *darkButton;
@property (nonatomic, strong) USReaderButton *settingButton;

@property (nonatomic, strong) UIStackView *container;

@end

@implementation USReaderFunctionView

- (void)setupSubviews {
    [self addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container.superview);
    }];
    
    [self.container addArrangedSubview:self.catalogButton];
    [self.container addArrangedSubview:self.commentButton];
    [self.container addArrangedSubview:self.darkButton];
    [self.container addArrangedSubview:self.settingButton];
    
    [self.catalogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
    [self.darkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(49);
    }];
}

- (void)clickCatalog {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickCatalogue:)]) {
        [self.readerMenu.delegate readMenuClickCatalogue:self.readerMenu];
    }
}

- (void)clickComment {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickComment:)]) {
        [self.readerMenu.delegate readMenuClickComment:self.readerMenu];
    }
}

- (void)clickDarkMode {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickDayAndNight:)]) {
        [self.readerMenu.delegate readMenuClickDayAndNight:self.readerMenu];
    }
}

- (void)clickSetting {
    if ([self.delegate respondsToSelector:@selector(functionViewClickMore:)]) {
        [self.delegate functionViewClickMore:self];
    }
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickSetting:)]) {
        [self.readerMenu.delegate readMenuClickSetting:self.readerMenu];
    }
}

#pragma mark - getter
- (USReaderButton *)catalogButton {
    if (!_catalogButton) {
        _catalogButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_catalogButton setImage:USAssetImage(@"catalog") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_catalogButton setTitle:@"目录" forState:UIControlStateNormal];
        [_catalogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_catalogButton addTarget:self action:@selector(clickCatalog) forControlEvents:UIControlEventTouchUpInside];
        _catalogButton.tintColor = [UIColor whiteColor];
    }
    return _catalogButton;
}

- (USReaderButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_commentButton setImage:USAssetImage(@"comment") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.tintColor = [UIColor whiteColor];
    }
    return _commentButton;
}

- (USReaderButton *)darkButton {
    if (!_darkButton) {
        _darkButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_darkButton setImage:USAssetImage(@"darkmode") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_darkButton setTitle:@"夜间模式" forState:UIControlStateNormal];
        [_darkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_darkButton addTarget:self action:@selector(clickDarkMode) forControlEvents:UIControlEventTouchUpInside];
        _darkButton.tintColor = [UIColor whiteColor];
    }
    return _darkButton;
}

- (USReaderButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [USReaderButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_settingButton setImage:USAssetImage(@"setting_fill") forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
        _settingButton.tintColor = [UIColor whiteColor];
    }
    return _settingButton;
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
