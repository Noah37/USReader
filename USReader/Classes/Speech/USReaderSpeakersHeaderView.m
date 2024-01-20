//
//  USReaderSpeakersHeaderView.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import "USReaderSpeakersHeaderView.h"
#import <Masonry/Masonry.h>

@interface USReaderSpeakersHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation USReaderSpeakersHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleLabel.superview);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end
