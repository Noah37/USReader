//
//  USReaderCoverView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderCoverView.h"
#import <Masonry/Masonry.h>
#import "USReaderConfigure.h"
#import "USConstants.h"

@interface USReaderCoverView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *catalogLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation USReaderCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // Do any additional setup after loading the view.
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.avatarView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.authorLabel];
    [self addSubview:self.catalogLabel];
    [self addSubview:self.descLabel];

    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(US_NAVIGATIONBAR_HEIGHT);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(300);
        make.centerX.equalTo(self.avatarView.superview);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(US_READER_LEFT_INSET);
        make.right.inset(US_READER_RIGHT_INSET);
        make.top.equalTo(self.avatarView.mas_bottom).offset(50);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(US_READER_LEFT_INSET);
        make.right.inset(US_READER_RIGHT_INSET);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
    }];
    [self.catalogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(US_READER_LEFT_INSET);
        make.right.inset(US_READER_RIGHT_INSET);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(30);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(US_READER_LEFT_INSET);
        make.right.inset(US_READER_RIGHT_INSET);
        make.top.equalTo(self.catalogLabel.mas_bottom).offset(30);
    }];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
    }
    return _avatarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:30];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [USReaderConfigure shared].textColor;
    }
    return _titleLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:20];
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        _authorLabel.textColor = [USReaderConfigure shared].textColor;
    }
    return _authorLabel;
}

- (UILabel *)catalogLabel {
    if (!_catalogLabel) {
        _catalogLabel = [[UILabel alloc] init];
        _catalogLabel.font = [UIFont systemFontOfSize:20];
        _catalogLabel.textAlignment = NSTextAlignmentCenter;
        _catalogLabel.textColor = [USReaderConfigure shared].textColor;
    }
    return _catalogLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:20];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = [USReaderConfigure shared].textColor;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

@end
