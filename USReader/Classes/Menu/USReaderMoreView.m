//
//  USReaderMoreView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderMoreView.h"
#import <Masonry/Masonry.h>
#import "USReaderSystemFontView.h"
#import "USReaderConfigure.h"

static CGFloat kSystemFontViewOffset = 298;

@interface USReaderMoreView ()<USReaderFontSizeViewDelegate,USReaderSystemFontViewDelegate>

@property (nonatomic, strong) USReaderLightView *lightView;
@property (nonatomic, strong) USReaderFontSizeView *fontSizeView;
@property (nonatomic, strong) USReaderBGView *bgView;
@property (nonatomic, strong) USReaderSettingView *settingView;
@property (nonatomic, strong) USReaderSystemFontView *systemFontView;

@end

@implementation USReaderMoreView


- (void)setupSubviews {
    [super setupSubviews];
    
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.lightView];
    [self addSubview:self.fontSizeView];
    [self addSubview:self.bgView];
    [self addSubview:self.settingView];
    [self addSubview:self.systemFontView];
    
    [self.systemFontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.systemFontView.superview).offset(kSystemFontViewOffset);
        make.left.right.equalTo(self.systemFontView.superview);
    }];
    
    [self.lightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.fontSizeView.mas_top).offset(-30);
        make.top.mas_equalTo(30);
    }];
    [self.fontSizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.bgView.mas_top).offset(-30);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.settingView.mas_top).offset(-30);
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(0);
    }];
}

- (void)afterDismiss {
    [self systemFontViewClickCustomFont:nil];
    [self.systemFontView afterDismiss];
}

#pragma mark - USReaderFontSizeViewDelegate
- (void)fontSizeViewClickSystem:(USReaderFontSizeView *)fontSizeView {
    [self.systemFontView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.systemFontView.superview);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
        
    [UIView animateWithDuration:0.2 animations:^{
      [self layoutIfNeeded];
    }];
}

#pragma mark - USReaderSystemFontViewDelegate
- (void)systemFontViewClickCustomFont:(USReaderSystemFontView *)fontSizeView {
    [self.systemFontView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.systemFontView.superview).offset(kSystemFontViewOffset);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
        
    [UIView animateWithDuration:0.2 animations:^{
      [self layoutIfNeeded];
    }];
    
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickFont:)]) {
        [self.readerMenu.delegate readMenuClickFont:self.readerMenu];
    }
}

#pragma mark -
- (USReaderLightView *)lightView {
    if (!_lightView) {
        _lightView = [[USReaderLightView alloc] initWithMenu:self.readerMenu];
        [_lightView setLight:[USReaderConfigure shared].light.doubleValue];
    }
    return _lightView;
}

- (USReaderFontSizeView *)fontSizeView {
    if (!_fontSizeView) {
        _fontSizeView = [[USReaderFontSizeView alloc] initWithMenu:self.readerMenu];
        _fontSizeView.delegate = self;
    }
    return _fontSizeView;
}

- (USReaderBGView *)bgView {
    if (!_bgView) {
        _bgView = [[USReaderBGView alloc] initWithMenu:self.readerMenu];
    }
    return _bgView;
}

- (USReaderSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[USReaderSettingView alloc] initWithMenu:self.readerMenu];
    }
    return _settingView;
}

- (USReaderSystemFontView *)systemFontView {
    if (!_systemFontView) {
        _systemFontView = [[USReaderSystemFontView alloc] initWithMenu:self.readerMenu];
        _systemFontView.delegate = self;
    }
    return _systemFontView;
}

@end
