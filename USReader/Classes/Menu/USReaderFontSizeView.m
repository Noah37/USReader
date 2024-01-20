//
//  USReaderFontSizeView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderFontSizeView.h"
#import <Masonry/Masonry.h>
#import "USReaderConfigure.h"

@interface USReaderFontSizeView ()

@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *fontLabel;
@property (nonatomic, strong) UILabel *fontSizeLabel;
@property (nonatomic, strong) UIButton *systemFontButton;

@end

@implementation USReaderFontSizeView

- (void)setupSubviews {
    [super setupSubviews];
    [self addSubview:self.previousButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.fontLabel];
    [self addSubview:self.fontSizeLabel];
    [self addSubview:self.systemFontButton];
    
    [self.fontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(self.fontLabel.superview);
    }];
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fontLabel.mas_right).offset(10);
        make.top.bottom.inset(0);
        make.width.mas_equalTo(80);
    }];
    [self.fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.previousButton.mas_right).offset(10);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(self.fontSizeLabel.superview);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fontSizeLabel.mas_right).offset(10);
        make.top.bottom.inset(0);
        make.width.mas_equalTo(80);
    }];
    [self.systemFontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.systemFontButton.superview).offset(-16);
        make.top.bottom.inset(0);
        make.width.mas_equalTo(80);
    }];
}

- (void)clickPrevious {
    if ([self.delegate respondsToSelector:@selector(fontSizeViewClickPrevious:)]) {
        [self.delegate fontSizeViewClickPrevious:self];
    }
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickFontSizePlus:)]) {
        [self.readerMenu.delegate readMenuClickFontSizePlus:self.readerMenu];
    }
    _fontSizeLabel.text = [USReaderConfigure shared].fontSize.stringValue;
    _nextButton.enabled = [self nextEnable];
    _previousButton.enabled = [self previousEnable];
}

- (void)clickNext {
    if ([self.delegate respondsToSelector:@selector(fontSizeViewClickNext:)]) {
        [self.delegate fontSizeViewClickNext:self];
    }
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickFontSizeAdd:)]) {
        [self.readerMenu.delegate readMenuClickFontSizeAdd:self.readerMenu];
    }
    _fontSizeLabel.text = [USReaderConfigure shared].fontSize.stringValue;
    _nextButton.enabled = [self nextEnable];
    _previousButton.enabled = [self previousEnable];
}

- (void)clickSystemFont {
    if ([self.delegate respondsToSelector:@selector(fontSizeViewClickSystem:)]) {
        [self.delegate fontSizeViewClickSystem:self];
    }
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickFont:)]) {
        [self.readerMenu.delegate readMenuClickFont:self.readerMenu];
    }
}

- (BOOL)previousEnable {
    if ([USReaderConfigure shared].fontSize.integerValue > US_READER_FONT_SIZE_MIN) {
        return YES;
    }
    return NO;
}

- (BOOL)nextEnable {
    if ([USReaderConfigure shared].fontSize.integerValue < US_READER_FONT_SIZE_MAX) {
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (UIButton *)previousButton {
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousButton setTitle:@"A -" forState:UIControlStateNormal];
        [_previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _previousButton.layer.cornerRadius = 15;
        _previousButton.layer.masksToBounds = YES;
        _previousButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _previousButton.layer.borderWidth = 1;
        [_previousButton addTarget:self action:@selector(clickPrevious) forControlEvents:UIControlEventTouchUpInside];
        _previousButton.tintColor = [UIColor whiteColor];
        _previousButton.enabled = [self previousEnable];
    }
    return _previousButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"A +" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _nextButton.layer.cornerRadius = 15;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _nextButton.layer.borderWidth = 1;
        [_nextButton addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.tintColor = [UIColor whiteColor];
        _nextButton.enabled = [self nextEnable];
    }
    return _nextButton;
}

- (UIButton *)systemFontButton {
    if (!_systemFontButton) {
        _systemFontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_systemFontButton setTitle:@"系统字体" forState:UIControlStateNormal];
        [_systemFontButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _systemFontButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _systemFontButton.layer.cornerRadius = 15;
        _systemFontButton.layer.masksToBounds = YES;
        _systemFontButton.backgroundColor = [UIColor whiteColor];
        [_systemFontButton addTarget:self action:@selector(clickSystemFont) forControlEvents:UIControlEventTouchUpInside];
        _systemFontButton.tintColor = [UIColor whiteColor];
    }
    return _systemFontButton;
}

- (UILabel *)fontLabel {
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.font = [UIFont systemFontOfSize:13];
        _fontLabel.textAlignment = NSTextAlignmentCenter;
        _fontLabel.textColor = [UIColor whiteColor];
        _fontLabel.text = @"字体";
    }
    return _fontLabel;
}

- (UILabel *)fontSizeLabel {
    if (!_fontSizeLabel) {
        _fontSizeLabel = [[UILabel alloc] init];
        _fontSizeLabel.font = [UIFont systemFontOfSize:13];
        _fontSizeLabel.textAlignment = NSTextAlignmentCenter;
        _fontSizeLabel.textColor = [UIColor whiteColor];
        _fontSizeLabel.text = [USReaderConfigure shared].fontSize.stringValue;
    }
    return _fontSizeLabel;
}

@end
