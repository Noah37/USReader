//
//  USReaderBottomView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderBottomView.h"
#import "USReaderProgressView.h"
#import "USReaderFunctionView.h"
#import "USReaderMenu.h"
#import <Masonry/Masonry.h>

@interface USReaderBottomView ()<USReaderFunctionViewDelegate>

@property (nonatomic, strong) USReaderMenu *readerMenu;

@property (nonatomic, strong) USReaderProgressView *progressView;

@property (nonatomic, strong) USReaderFunctionView *functionView;

@end

@implementation USReaderBottomView

- (instancetype)initWithMenu:(USReaderMenu *)menu {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _readerMenu = menu;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.progressView];
    [self addSubview:self.functionView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.functionView.mas_top).offset(-20);
        make.left.right.inset(0);
        make.top.equalTo(self.progressView.superview).offset(20);
        make.height.mas_equalTo(kProgressHeight);
    }];
    
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(16);
        make.height.mas_equalTo(KTabBarHeight);
        make.bottom.inset(KBottomSafeAreaHeight);
    }];
}

- (void)functionViewClickMore:(USReaderFunctionView *)functionView {
    if ([self.delegate respondsToSelector:@selector(bottomViewClickMore:)]) {
        [self.delegate bottomViewClickMore:self];
    }
}

#pragma mark - getter
- (USReaderProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[USReaderProgressView alloc] initWithMenu:self.readerMenu];
    }
    return _progressView;
}

- (USReaderFunctionView *)functionView {
    if (!_functionView) {
        _functionView = [[USReaderFunctionView alloc] initWithMenu:self.readerMenu];
        _functionView.delegate = self;
    }
    return _functionView;
}

@end
