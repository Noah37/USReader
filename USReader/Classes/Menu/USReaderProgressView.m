//
//  USReaderProgressView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderProgressView.h"
#import "ASValueTrackingSlider.h"
#import "USReaderMenu.h"

@interface USReaderProgressView ()<ASValueTrackingSliderDelegate, ASValueTrackingSliderDataSource>

@property (nonatomic, strong) USReaderMenu *readerMenu;
@property (nonatomic, strong) UIButton *previousChapter;
@property (nonatomic, strong) UIButton *nextChapter;
@property (nonatomic, strong) ASValueTrackingSlider *slider;

@end

@implementation USReaderProgressView

- (instancetype)initWithMenu:(USReaderMenu *)menu {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _readerMenu = menu;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.previousChapter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousChapter.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.previousChapter setTitle:@"上一章" forState:UIControlStateNormal];
    [self.previousChapter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.previousChapter addTarget:self action:@selector(clickPreviousChapter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previousChapter];
    
    self.nextChapter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextChapter.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.nextChapter setTitle:@"下一章" forState:UIControlStateNormal];
    [self.nextChapter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextChapter addTarget:self action:@selector(clickNextChapter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextChapter];
    
    self.slider = [[ASValueTrackingSlider alloc] init];
    self.slider.delegate = self;
    self.slider.dataSource = self;
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    // 设置显示进度保留几位小数 (由于重写了 dataSource 则不用不到该属性了)
    // slider.setMaxFractionDigitsDisplayed(0)
    // 设置气泡背景颜色
    self.slider.popUpViewColor = [UIColor colorWithRed:253/255.0 green:85/255.0 blue:103/255.0 alpha:1.0]; // US_RGB(253, 85, 103);
    // 设置气泡字体颜色
    self.slider.textColor = [UIColor whiteColor];
    // 设置气泡字体以及字体大小
    self.slider.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:22];
    // 设置气泡箭头高度
    self.slider.popUpViewArrowLength = 5;
    // 设置当前进度颜色
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:253/255.0 green:85/255.0 blue:103/255.0 alpha:1.0];
    // 设置总进度颜色
    self.slider.maximumTrackTintColor = [UIColor whiteColor];
    // 设置当前拖拽圆圈颜色
    self.slider.tintColor = [UIColor whiteColor];
    [self addSubview:self.slider];
    
    [self reloadProgress];
}
    
/// 刷新阅读进度显示
- (void)reloadProgress {
    
}

/// 上一章
- (void)clickPreviousChapter {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickPreviousChapter:)]) {
        [self.readerMenu.delegate readMenuClickPreviousChapter:self.readerMenu];
    }
}

/// 下一章
- (void)clickNextChapter {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickNextChapter:)]) {
        [self.readerMenu.delegate readMenuClickNextChapter:self.readerMenu];
    }
}

// MARK: ASValueTrackingSliderDataSource
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    return [NSString stringWithFormat:@"%f", value];
}

// MARK: -- ASValueTrackingSliderDelegate

/// 进度显示将要显示
- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider {
    
}
// 进度显示将要隐藏
- (void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider {
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuDraggingProgress:toChapterID:toPage:)]) {
        [self.readerMenu.delegate readMenuDraggingProgress:self.readerMenu toPage:slider.value - 1];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    CGFloat buttonW = 55;
    self.previousChapter.frame = CGRectMake(5, 0, buttonW, h);
    
    self.nextChapter.frame = CGRectMake(w - buttonW- 5, 0, buttonW,  h);
    
    CGFloat sliderX = CGRectGetMaxX(self.previousChapter.frame) + 10;
    CGFloat sliderW = w - 2 * sliderX;
    self.slider.frame = CGRectMake(sliderX, 0, sliderW, h);
    
}

@end
