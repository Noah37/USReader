//
//  USReaderBGView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderBGView.h"
#import "USReaderBGItem.h"
#import <Masonry/Masonry.h>
#import "USReaderConfigure.h"
#import "USConstants.h"

@interface USReaderBGView ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UILabel *bgLabel;
@property (nonatomic, strong) UIButton *customThemeButton;
@property (nonatomic, strong) NSArray <USReaderBGItem *>*bgItems;

@end

@implementation USReaderBGView

- (void)setupSubviews {
    [super setupSubviews];
    
    [self addSubview:self.bgLabel];
    [self addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.customThemeButton];
    [self.bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(self.bgLabel.superview);
    }];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgLabel.mas_right).offset(10);
        make.top.bottom.inset(0);
        make.right.inset(16);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    NSArray <USReaderBGType *>*bgs = [[USReaderConfigure shared] bgTypes];
    CGFloat itemW = 30;
    CGFloat itemSpace = 15;
    USReaderBGItem *lastItem;
    NSMutableArray *array = [NSMutableArray array];
    for (USReaderBGType *bgName in bgs) {
        NSInteger index = [bgs indexOfObject:bgName];
//        UIColor *tintColor = index == 1 ? [UIColor colorWithWhite:1.0 alpha:1.0]:nil;
        USReaderBGItem *item = [[USReaderBGItem alloc] init];
        [item addTarget:self action:@selector(selectThemeBg:) forControlEvents:UIControlEventTouchUpInside];
        [item setBgType:bgName];
        [self.bgScrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.inset(index * (itemW + itemSpace));
            make.width.height.mas_equalTo(itemW);
            make.top.bottom.inset(0);
        }];
        lastItem = item;
        [array addObject:item];
    }
    self.bgItems = [array copy];
    
    [self.customThemeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastItem.mas_right).offset(20);
        make.right.inset(0);
    }];
    [self selectDefaultThemeBg];
}

- (void)selectDefaultThemeBg {
    USReaderBGType *selectedBgType = [USReaderConfigure shared].selectedBgType;
    for (NSInteger index = 0; index < self.bgItems.count; index++) {
        USReaderBGItem *item = self.bgItems[index];
        item.selected = NO;
        if (item.bgType.modelType == selectedBgType.modelType) {
            item.selected = YES;
        }
    }
    if (!selectedBgType) {
        self.bgItems.firstObject.selected = YES;
    }
}

- (void)selectThemeBg:(USReaderBGItem *)control {
    control.selected = !control.selected;
    for (NSInteger index = 0; index < self.bgItems.count; index++) {
        USReaderBGItem *item = self.bgItems[index];
        if (control == item) {
            continue;
        }
        item.selected = NO;
    }
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickBGColor:bgType:)]) {
        [self.readerMenu.delegate readMenuClickBGColor:self.readerMenu bgType:control.bgType];
    }
}

- (void)clickCustomTheme {
    
}

#pragma mark - getter
- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}

- (UIButton *)customThemeButton {
    if (!_customThemeButton) {
        _customThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_customThemeButton setTitle:@"个性背景" forState:UIControlStateNormal];
        [_customThemeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _customThemeButton.layer.cornerRadius = 15;
        _customThemeButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        _customThemeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _customThemeButton.layer.masksToBounds = YES;
        _customThemeButton.backgroundColor = [UIColor whiteColor];
        [_customThemeButton addTarget:self action:@selector(clickCustomTheme) forControlEvents:UIControlEventTouchUpInside];
        _customThemeButton.tintColor = [UIColor whiteColor];
    }
    return _customThemeButton;
}

- (UILabel *)bgLabel {
    if (!_bgLabel) {
        _bgLabel = [[UILabel alloc] init];
        _bgLabel.font = [UIFont systemFontOfSize:13];
        _bgLabel.textAlignment = NSTextAlignmentCenter;
        _bgLabel.textColor = [UIColor whiteColor];
        _bgLabel.text = @"背景";
    }
    return _bgLabel;
}

@end
