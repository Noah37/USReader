//
//  USReaderMenu.m
//  Masonry
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderMenu.h"
#import "USReaderContentView.h"
#import "USReaderTopView.h"
#import "USReaderBottomView.h"
#import "USReaderMoreView.h"
#import "USReaderController.h"
#import <Masonry/Masonry.h>
#import "USReaderSpeechViewController.h"

@interface USReaderMenu ()<USReaderTopViewDelegate, USReaderBottomViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) USReaderController *readerController;

@property (nonatomic, weak) USReaderContentView *contentView;

@property (nonatomic, strong) USReaderTopView *topView;

@property (nonatomic, strong) USReaderBottomView *bottomView;

@property (nonatomic, strong) USReaderMoreView *moreView;

@property (nonatomic, strong) UIButton *speechButton;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@property (nonatomic, assign) BOOL isAnimateComplete;

/// 菜单显示状态
@property (nonatomic, assign) BOOL isMenuShow;

@property (nonatomic, assign) BOOL isMoreShow;

@property (nonatomic, strong) USReaderSpeechViewController *speechVC;

@end

@implementation USReaderMenu

/// 初始化
- (instancetype)initWithVC:(USReaderController *)readerController delegate:(id<USReaderMenuDelegate>)delegate {
    self = [super init];
    if (self) {
        self.readerController = readerController;
        self.delegate = delegate;
        self.contentView = readerController.contentView;
        self.isAnimateComplete = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.moreView];
    [self.contentView addSubview:self.speechButton];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topView.superview.mas_top);
        make.left.right.inset(0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.superview.mas_bottom).offset(KBottomBarHeight);
        make.left.right.inset(0);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.moreView.superview.mas_bottom).offset(kReaderMoreHeight);
        make.left.right.inset(0);
    }];
    
    [self.speechButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(16);
        make.bottom.equalTo(self.speechButton.superview).offset(-200);
    }];
    
    [self.contentView addGestureRecognizer:self.singleTap];
}

- (void)dismiss {
    self.topView.transform = CGAffineTransformIdentity;
    self.bottomView.transform = CGAffineTransformIdentity;
    self.moreView.transform = CGAffineTransformIdentity;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    self.moreView.hidden = YES;
    self.isMenuShow = NO;
    self.isMoreShow = NO;
}

- (void)showMenu:(BOOL)isShow {
    if (self.isMenuShow == isShow || !self.isAnimateComplete) {
        return;
    }
    self.isAnimateComplete = NO;
    if (isShow) {
        self.speechButton.hidden = NO;
        if ([self.delegate respondsToSelector:@selector(readMenuWillDisplay:)]) {
            [self.delegate readMenuWillDisplay:self];
        }
    } else {
        self.speechButton.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(readMenuWillEndDisplay:)]) {
            [self.delegate readMenuWillEndDisplay:self];
        }
    }
    self.isMenuShow = isShow;
    [self showBottomView:isShow completion:nil];
    [self showTopView:isShow completion:^{
        self.isAnimateComplete = YES;
        if (isShow) {
            if ([self.delegate respondsToSelector:@selector(readMenuDidDisplay:)]) {
                [self.delegate readMenuDidDisplay:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(readMenuDidEndDisplay:)]) {
                [self.delegate readMenuDidEndDisplay:self];
            }
        }
    }];
    if (self.isMoreShow) {
        self.isMoreShow = isShow;
        [self showMoreView:isShow completion:nil];
    }
    
}

- (void)showTopView:(BOOL)isShow completion:(void(^)(void))completion {
//    [[UIApplication sharedApplication] setStatusBarHidden:!isShow withAnimation:(UIStatusBarAnimationSlide)];
    if (isShow) {
        self.topView.hidden = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.readerController setNeedsStatusBarAppearanceUpdate];
    }];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        if (isShow) {
            self.topView.transform = CGAffineTransformMakeTranslation(0, KTopBarHeight);
        } else {
            self.topView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        if (!isShow) {
            self.topView.hidden = YES;
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)showBottomView:(BOOL)isShow completion:(void(^)(void))completion {
    if (isShow) {
        self.bottomView.hidden = NO;
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (isShow) {
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, -KBottomBarHeight);
        } else {
            self.bottomView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        if (!isShow) {
            self.bottomView.hidden = YES;
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)showMoreView:(BOOL)isShow completion:(void(^)(void))completion {
    if (isShow) {
        self.moreView.hidden = NO;
    }
    self.isMoreShow = isShow;
    [UIView animateWithDuration:0.2 animations:^{
        if (isShow) {
            self.moreView.transform = CGAffineTransformMakeTranslation(0, -kReaderMoreHeight);
        } else {
            self.moreView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        if (!isShow) {
            self.moreView.hidden = YES;
            [self.moreView afterDismiss];
        }
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - action
- (void)actionSingleTap {
    [self showMenu:!self.isMenuShow];
}

- (void)actionSpeech {
    if (_speechVC) {
        [self.readerController presentViewController:_speechVC animated:YES completion:nil];
        return;
    }
    USReaderSpeechViewController *speechVC = [[USReaderSpeechViewController alloc] initWithRecordModel:self.readerController.currentRecordModel];
    speechVC.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak typeof(self)weakSelf = self;
    speechVC.playNextHandler = ^(USReaderRecordModel * _Nonnull recordModel) {
        [weakSelf playNext:recordModel];
    };
    speechVC.playPreviousHandler = ^(USReaderRecordModel * _Nonnull recordModel) {
        [weakSelf playPrevious:recordModel];
    };
    speechVC.nextRecordHandler = ^USReaderRecordModel * _Nonnull(USReaderRecordModel * _Nonnull recordModel) {
        return [weakSelf getNextPageRecord];
    };
    speechVC.previousRecordHandler = ^USReaderRecordModel * _Nonnull(USReaderRecordModel * _Nonnull recordModel) {
        return [weakSelf getPreviousPageRecord];
    };
    [self.readerController presentViewController:speechVC animated:YES completion:nil];
    _speechVC = speechVC;
}

- (USReaderRecordModel *)getNextPageRecord {
    return [self.readerController.displayViewController nextPage];
}

- (USReaderRecordModel *)getPreviousPageRecord {
    return [self.readerController.displayViewController lastPage];
}

/// 播放下一个页面
- (void)playNext:(USReaderRecordModel *)recordModel {
    [self.readerController.displayViewController nextPage];
    [_speechVC setCurrentRecordModel:self.readerController.currentRecordModel];
}

/// 播放上一个页面
- (void)playPrevious:(USReaderRecordModel *)recordModel {
    [self.readerController.displayViewController lastPage];
    [_speechVC setCurrentRecordModel:self.readerController.currentRecordModel];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSArray *clsUnTouchable = @[@"USReaderTopView",@"USReaderProgressView",@"USReaderBottomView",@"USReaderFunctionView", @"USReaderButton", @"UIStackView", @"USReaderMoreView", @"USReaderBGItem", @"USReaderBGView", @"USReaderLightView", @"USReaderFontSizeView", @"USReaderSettingView", @"USReaderProgressView", @"USReaderSystemFontView", @"USReaderSystemFontCell"];
    UIView *touchView = [touch view];
    UIView *touchSuperView = [touchView superview];
    if ([clsUnTouchable containsObject:NSStringFromClass([touchView class])] || [clsUnTouchable containsObject:NSStringFromClass([touchSuperView class])]) {
        return NO;
    }
    return YES;
}

#pragma mark - USReaderBottomViewDelegate
- (void)bottomViewClickMore:(USReaderBottomView *)bottomView {
    [self showMoreView:!self.isMoreShow completion:nil];
}

#pragma mark - USReaderTopViewDelegate
- (void)readerTopViewClickBack:(USReaderTopView *)readerTopView {
    [self.readerController.navigationController popViewControllerAnimated:YES];
}

- (void)readerTopViewClickMore:(USReaderTopView *)readerTopView {
    
}

#pragma mark - getter
- (USReaderTopView *)topView {
    if (!_topView) {
        _topView = [[USReaderTopView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}

- (USReaderBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[USReaderBottomView alloc] initWithMenu:self];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (USReaderMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[USReaderMoreView alloc] initWithMenu:self];
    }
    return _moreView;
}

- (UIButton *)speechButton {
    if (!_speechButton) {
        _speechButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speechButton setTitle:@"听书" forState:UIControlStateNormal];
        _speechButton.backgroundColor = [UIColor brownColor];
        [_speechButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_speechButton addTarget:self action:@selector(actionSpeech) forControlEvents:UIControlEventTouchUpInside];
        _speechButton.hidden = YES;
    }
    return _speechButton;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSingleTap)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.delegate = self;
    }
    return _singleTap;
}

@end
