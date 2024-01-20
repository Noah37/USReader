//
//  USReaderButton.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderButton.h"
#import <Masonry/Masonry.h>

@interface USReaderButton ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation USReaderButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(34);
            make.top.inset(0);
            make.centerX.equalTo(self.imageView.superview);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom);
            make.left.right.inset(0);
            make.bottom.lessThanOrEqualTo(self.titleLabel.superview);
        }];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    USReaderButton *button = [[USReaderButton alloc] init];
    
    return button;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.titleLabel.textColor = color;
}

- (void)setTintColor:(UIColor *)tintColor {
    self.titleLabel.tintColor = tintColor;
    self.imageView.tintColor = tintColor;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    self.imageView.image = image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
