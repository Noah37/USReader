//
//  USReaderTopView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderTopView.h"
#import <Masonry/Masonry.h>

@interface USReaderTopView ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *rightContainer;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation USReaderTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.backButton];
        [self addSubview:self.rightContainer];
        [self addSubview:self.titleLabel];
        [self.rightContainer addArrangedSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
        }];
        
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.inset(16);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right).offset(20);
            make.right.equalTo(self.rightContainer.mas_left).offset(-20);
            make.bottom.inset(16);
            make.top.inset(KTopBarHeight - 16 - 20);
        }];
        
        [self.rightContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(16);
            make.bottom.inset(16);
            make.top.equalTo(self.titleLabel.mas_top);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)clickBack {
    if ([self.delegate respondsToSelector:@selector(readerTopViewClickBack:)]) {
        [self.delegate readerTopViewClickBack:self];
    }
}

- (void)clickMore {
    if ([self.delegate respondsToSelector:@selector(readerTopViewClickMore:)]) {
        [self.delegate readerTopViewClickMore:self];
    }
}

#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        if (@available(iOS 13.0, *)) {
            UIImage *image = [[UIImage imageNamed:@"back" inBundle:bundle withConfiguration:nil] imageWithTintColor:[UIColor whiteColor]];
            [_backButton setImage:image forState:UIControlStateNormal];
        } else {
            [_backButton setImage:[UIImage imageNamed:@"back" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
        [_backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIStackView *)rightContainer {
    if (!_rightContainer) {
        _rightContainer = [[UIStackView alloc] init];
        _rightContainer.axis = UILayoutConstraintAxisHorizontal;
        _rightContainer.spacing = 10;
    }
    return _rightContainer;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_moreButton setImage:[[UIImage imageNamed:@"more_horizonal" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_moreButton addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.tintColor = [UIColor whiteColor];
    }
    return _moreButton;
}

@end
