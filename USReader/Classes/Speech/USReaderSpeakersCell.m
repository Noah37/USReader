//
//  USReaderSpeakersCell.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import "USReaderSpeakersCell.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import "USConstants.h"

@interface USReaderSpeakersCell ()

@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIView *circleView;

@end

@implementation USReaderSpeakersCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.contentBgView];
        [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentBgView.superview);
        }];
        
        [self.contentView addSubview:self.avatar];
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.inset(10);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.avatar addSubview:self.circleView];
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.circleView.superview);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatar.mas_trailing).offset(5);
            make.centerY.equalTo(self.nameLabel.superview);
        }];
        
        [self.contentView addSubview:self.tagView];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(5);
            make.centerY.equalTo(self.tagView.superview);
        }];
        
        [self.tagView addSubview:self.tagLabel];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.inset(2);
            make.centerY.equalTo(self.tagLabel.superview);
        }];
        
    }
    return self;
}

- (void)setSpeaker:(USReaderSpeaker *)speaker {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:speaker.getCurrentAvatar] placeholderImage:USAssetImage(@"user_avatar")];
    self.nameLabel.text = speaker.getCurrentName;
    self.tagLabel.text = speaker.engineName;
}

- (void)setCellSelected:(BOOL)selected {
    self.circleView.hidden = !selected;
}

#pragma mark - getter
- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.layer.cornerRadius = 8;
        _contentBgView.layer.masksToBounds = YES;
        _contentBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _contentBgView;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 15;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.layer.cornerRadius = 15;
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.borderColor = [UIColor redColor].CGColor;
        _circleView.layer.borderWidth = 1;
    }
    return _circleView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        _tagView.layer.cornerRadius = 2;
        _tagView.layer.masksToBounds = YES;
        _tagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _tagView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = [UIFont systemFontOfSize:9];
    }
    return _tagLabel;
}

@end
