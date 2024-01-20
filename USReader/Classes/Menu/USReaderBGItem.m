//
//  USReaderBGItem.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderBGItem.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"

@interface USReaderBGItem ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *circleView;

@property (nonatomic, strong) USReaderBGType *bgType;

@end

@implementation USReaderBGItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = NO;
        [self addSubview:self.imageView];
        [self addSubview:self.circleView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView.superview);
        }];
        
        [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.circleView.superview);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.circleView.hidden = !selected;
}

- (void)setBgType:(USReaderBGType *)bgType {
    _bgType = bgType;
    self.imageView.image = bgType.bgImage;
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 15;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)circleView {
    if (!_circleView) {
        _circleView = [[UIImageView alloc] init];
        _circleView.layer.cornerRadius = 15;
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.borderColor = [UIColor redColor].CGColor;
        _circleView.layer.borderWidth = 2;
//        _circleView.image = USAssetBgImage(@"circle", [UIColor redColor]);
    }
    return _circleView;
}

@end
