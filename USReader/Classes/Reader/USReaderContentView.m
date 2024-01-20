//
//  USReaderContentView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderContentView.h"

@interface USReaderContentView ()

@property (nonatomic, strong) UIControl *cover;

@property (nonatomic, assign) BOOL isShowCover;

@end

@implementation USReaderContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.cover = [[UIControl alloc] init];
    self.cover.alpha = 0.0;
    self.cover.userInteractionEnabled = NO;
    self.cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.cover addTarget:self action:@selector(clickCover) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cover];
}

- (void)clickCover {
    self.cover.userInteractionEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(contentViewClickCover:)]) {
        [self.delegate contentViewClickCover:self];
    }
    [self showCover:NO];
}

- (void)showCover:(BOOL)isShow {
    if (self.isShowCover == isShow) {
        return;
    }
    if (isShow) {
        [self bringSubviewToFront:self.cover];
        self.cover.userInteractionEnabled = YES;
    }
    self.isShowCover = isShow;
    [UIView animateWithDuration:0.2 animations:^{
        self.cover.alpha = [NSNumber numberWithBool:isShow].floatValue;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cover.frame = self.bounds;
}

@end
