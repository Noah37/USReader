//
//  USReaderLightView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderLightView.h"
#import "ASValueTrackingSlider.h"
#import <Masonry/Masonry.h>
#import "USReaderConfigure.h"

@interface USReaderLightView ()<ASValueTrackingSliderDelegate, ASValueTrackingSliderDataSource>

@property (nonatomic, strong) UIButton *previousLight;
@property (nonatomic, strong) UIButton *nextLight;
@property (nonatomic, strong) ASValueTrackingSlider *slider;

@end

@implementation USReaderLightView

- (void)setupSubviews {
    [super setupSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.previousLight = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousLight setImage:USAssetImage(@"brightess_white_low") forState:UIControlStateNormal];
    [self.previousLight addTarget:self action:@selector(clickPreviousLight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previousLight];
    
    self.nextLight = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextLight setImage:USAssetImage(@"brightess_white_high") forState:UIControlStateNormal];

    [self.nextLight addTarget:self action:@selector(clickNextLight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextLight];
    
    self.slider = [[ASValueTrackingSlider alloc] init];
    self.slider.delegate = self;
    self.slider.dataSource = self;
    self.slider.minimumValue = US_READER_Light_MIN;
    self.slider.maximumValue = US_READER_LIGHT_MAX;
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    // 设置显示进度保留几位小数 (由于重写了 dataSource 则不用不到该属性了)
//     slider.setMaxFractionDigitsDisplayed(0)
    // 设置气泡背景颜色
    self.slider.popUpViewColor = [UIColor colorWithRed:253/255.0 green:85/255.0 blue:103/255.0 alpha:1.0]; // US_RGB(253, 85, 103);
    // 设置气泡字体颜色
    self.slider.textColor = [UIColor whiteColor];
    // 设置气泡字体以及字体大小
    self.slider.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:22];
    // 设置气泡箭头高度
//    self.slider.popUpViewArrowLength = 5;
    // 设置当前进度颜色
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:253/255.0 green:85/255.0 blue:103/255.0 alpha:1.0];
    // 设置总进度颜色
    self.slider.maximumTrackTintColor = [UIColor whiteColor];
    // 设置当前拖拽圆圈颜色
    self.slider.tintColor = [UIColor whiteColor];
    [self addSubview:self.slider];
    
    [self.previousLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.nextLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(16);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(56);
        make.top.bottom.equalTo(self.slider.superview);
    }];
    
    [self reloadProgress];
}

- (void)setLight:(CGFloat)light {
    self.slider.value = light;
}
    
/// 刷新阅读进度显示
- (void)reloadProgress {
    
}

/// 亮度减
- (void)clickPreviousLight {
    CGFloat value = self.slider.value;
    if (value > 0.1) {
        value = value - 0.1;
    } else {
        value = 0;
    }
    self.slider.value = value;
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickPreviousLight:)]) {
        [self.readerMenu.delegate readMenuClickPreviousLight:self.readerMenu];
    }
}

/// 亮度加
- (void)clickNextLight {
    CGFloat value = self.slider.value;
    if (value < 1) {
        value = value + 0.1;
    } else {
        value = 1;
    }
    self.slider.value = value;
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuClickNextLight:)]) {
        [self.readerMenu.delegate readMenuClickNextLight:self.readerMenu];
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
    if ([self.readerMenu.delegate respondsToSelector:@selector(readMenuDraggingLight:light:)]) {
        [self.readerMenu.delegate readMenuDraggingLight:self.readerMenu light:slider.value];
    }
}

@end
