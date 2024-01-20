//
//  USReaderConfigure.m
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import "USReaderConfigure.h"
#import "USConstants.h"
#import "USKeyedArchiver.h"
#import <YYCategories/YYCategories.h>

/// 主题颜色
#define US_READER_COLOR_MAIN [UIColor colorWithRed:253/255.0 green:85/255.0 blue:103/255.0 alpha:1.0]
/// 菜单默认颜色
#define US_READER_COLOR_MENU [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
/// 菜单背景颜色
#define US_READER_COLOR_MENU_BG [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:0.95]
/// 阅读背景颜色列表
#define US_READER_BG_COLORS @[[UIColor whiteColor],[UIColor colorWithRed:238/255.0 green:224/255.0 blue:202/255.0 alpha:1.0], [UIColor colorWithRed:205/255.0 green:239/255.0 blue:205/255.0 alpha:1.0], [UIColor colorWithRed:206/255.0 green:233/255.0 blue:241/255.0 alpha:1.0], [UIColor colorWithRed:58/255.0 green:52/255.0 blue:54/255.0 alpha:1.0], [UIColor colorWithRed:206/255.0 green:233/255.0 blue:241/255.0 alpha:1.0], [UIColor colorWithPatternImage:USAssetImage(@"read_bg_0_icon")]]

/// 阅读字体大小叠加指数
#define US_READER_FONT_SIZE_SPACE 2
/// 章节标题 - 在当前字体大小上叠加指数
#define US_READER_FONT_SIZE_SPACE_TITLE 8

@interface USReaderConfigure ()

/// 开启长按菜单功能 (滚动模式是不支持长按功能的)
@property (nonatomic, assign) BOOL openLongPress;
/// 背景颜色索引
@property (nonatomic, strong) NSNumber *bgColorIndex;
/// 字体类型索引
@property (nonatomic, strong) NSNumber *fontIndex;
/// 翻页类型索引
@property (nonatomic, strong) NSNumber *effectIndex;
/// 间距类型索引
@property (nonatomic, strong) NSNumber *spacingIndex;
/// 使用分页进度 || 总文章进度(网络文章也可以使用)
/// 总文章进度注意: 总文章进度需要有整本书的章节总数,以及当前章节带有从0开始排序的索引。
/// 如果还需要在拖拽底部功能条上进度条过程中展示章节名,则需要带上章节列表数据,并去 DZMRMProgressView 文件中找到 ASValueTrackingSliderDataSource 修改返回数据源为章节名。
@property (nonatomic, assign) USProgressType progressType;
/// 字体类型
@property (nonatomic, assign) USFontType fontType;
/// 间距类型
@property (nonatomic, assign) USSpacingType spacingType;
/// 背景颜色
@property (nonatomic, strong) UIColor *bgColor;
/// 字体颜色
@property (nonatomic, strong) UIColor *textColor;
/// 状态栏字体颜色
@property (nonatomic, strong) UIColor *statusTextColor;
/// 行间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
@property (nonatomic, assign) CGFloat lineSpacing;
/// 段间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
@property (nonatomic, assign) CGFloat paragraphSpacing;

@property (nonatomic, strong) NSArray <USReaderBGType *>* bgTypes;

@property (nonatomic, strong) NSArray <USReaderFontFile *>* customFontFiles;

@property (nonatomic, strong) NSNumber *light;

@end

@implementation USReaderConfigure

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)fontPlus {
    NSInteger fontSizeInteger = self.fontSize.integerValue;
    if (fontSizeInteger < US_READER_FONT_SIZE_MAX) {
        self.fontSize = [NSNumber numberWithInteger:fontSizeInteger + 1];
    }
}

- (void)fontMinus {
    NSInteger fontSizeInteger = self.fontSize.integerValue;
    if (fontSizeInteger > US_READER_FONT_SIZE_MIN) {
        self.fontSize = [NSNumber numberWithInteger:fontSizeInteger - 1];
    }
}

- (void)changeLight:(CGFloat)light {
    if (light > US_READER_LIGHT_MAX || light < US_READER_Light_MIN) {
        return;
    }
    self.light = [NSNumber numberWithDouble:light];
}

- (UIFont *)font:(BOOL)isTitle {
    NSInteger size = self.fontSize.integerValue + (isTitle ? 8:0);
    if (_customFont) {
        return [UIFont fontWithName:_customFont.fontName size:size];
    } else if (self.fontType == USFontTypeOne) {
        return [UIFont fontWithName:@"EuphemiaUCAS-Italic" size:size];
    } else if (self.fontType == USFontTypeTwo) {
        return [UIFont fontWithName:@"AmericanTypewriter-Light" size:size];
    } else if (self.fontType == USFontTypeThree) {
        return [UIFont fontWithName:@"Papyrus" size:size];
    }
    return [UIFont systemFontOfSize:size];
}

/// 字体属性
/// isPaging: 为YES的时候只需要返回跟分页相关的属性即可 (原因:包含UIColor,小数点相关的...不可返回,因为无法进行比较)
- (NSDictionary <NSAttributedStringKey, id>*)attributes:(BOOL)isTitle isPaging:(BOOL)isPaging {
    // 段落配置
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
    style.lineHeightMultiple = 1.0;
    
    if (isTitle) {
        style.lineSpacing = 0;
        style.paragraphSpacing = 0;
        style.alignment = NSTextAlignmentCenter;
    } else {
        style.lineSpacing = self.lineSpacing;
        // 换行模式（避免每页尾部留空白）
        style.lineBreakMode = NSLineBreakByCharWrapping;
        style.paragraphSpacing = 0;
        style.alignment = NSTextAlignmentJustified;
    }
    if (isPaging) {
        return @{
            NSFontAttributeName:[self font:isTitle],
            NSParagraphStyleAttributeName:style
        };
    } else {
        return @{
            NSForegroundColorAttributeName:self.textColor,
            NSFontAttributeName:[self font:isTitle],
            NSParagraphStyleAttributeName:style
        };
    }
}

- (void)save {
    NSDictionary *dict = @{
        @"bgColorIndex":self.bgColorIndex,
        @"fontIndex":self.fontIndex,
        @"effectIndex":self.effectIndex,
        @"spacingIndex":self.spacingIndex,
        @"progressIndex":self.progressIndex,
        @"fontSize":self.fontSize,
    };
    [USKeyedArchiver archiver:@"US_READER_EFFECT_CONFIGURE" fileName:@"EffectConfigure" object:self.effectTypeConfigure];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"US_READER_CONFIGURE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static USReaderConfigure *configure = nil;
    dispatch_once(&onceToken, ^{
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"US_READER_CONFIGURE"];
        USReaderEffectTypeConfigure *effectConfigure = [USKeyedArchiver unarchiver:@"US_READER_EFFECT_CONFIGURE" fileName:@"EffectConfigure"];
        configure = [[USReaderConfigure alloc] initWithDict:dict];
        if (effectConfigure) {
            configure.effectTypeConfigure = effectConfigure;
        }
    });
    return configure;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (dict != nil) {
            [self setValuesForKeysWithDictionary:dict];
        } else {
            [self initData];
        }
        self.customFontFiles = [USReaderFont loadAllFontFamily];
    }
    return self;
}

/// 初始化配置数据,以及处理初始化数据的增删
- (void)initData {
    if (self.bgColorIndex == nil || (self.bgColorIndex.integerValue >= US_READER_BG_COLORS.count)) {
        self.bgColorIndex = [NSNumber numberWithInteger:[US_READER_BG_COLORS indexOfObject:[UIColor colorWithPatternImage:USAssetImage(@"read_bg_0")]]];
    }
    if (self.fontIndex == nil) {
        self.fontIndex = [NSNumber numberWithInteger:USFontTypeTwo];
    }
    if (self.spacingIndex == nil) {
        self.spacingIndex = [NSNumber numberWithInteger:USSpacingTypeSmall];
    }
    if (self.effectIndex == nil) {
        self.effectIndex = [NSNumber numberWithInteger:USEffectTypeSimulation];
    }
    
    if (self.fontSize == nil || (self.fontSize.intValue > US_READER_FONT_SIZE_MAX || self.fontSize.intValue < US_READER_FONT_SIZE_MIN)) {
        self.fontSize = [NSNumber numberWithInteger:US_READer_FONT_SIZE_DEFAULT];
    }
    
    if (self.progressIndex == nil) {
        self.progressIndex = [NSNumber numberWithInteger:USProgressTypePage];
    }
    if (self.light == nil) {
        self.light = [NSNumber numberWithInteger:US_READER_LIGHT_MAX];
    }
    
    if (!self.effectTypeConfigure) {
        self.effectTypeConfigure = [[USReaderEffectTypeConfigure alloc] initWithEffectType:(USEffectTypeSimulation)];
    }
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    return [[USReaderConfigure alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (USProgressType)progressType {
    return self.progressIndex.integerValue;
}

- (USEffectType)effectType {
    return self.effectIndex.integerValue;
}

- (USFontType)fontType {
    return self.fontIndex.integerValue;
}

- (USSpacingType)spacingType {
    return self.spacingIndex.integerValue;
}

- (USReaderEffectTypeConfigure *)effectTypeConfigure {
    if (!_effectTypeConfigure) {
        _effectTypeConfigure = [[USReaderEffectTypeConfigure alloc] initWithEffectType:(USEffectTypeSimulation)];
    }
    return _effectTypeConfigure;
}

- (UIColor *)bgColor {
    if (self.bgColorIndex.integerValue == [US_READER_BG_COLORS indexOfObject:[UIColor colorWithPatternImage:[UIImage imageNamed:@"read_bg_0_icon"]]]) {
        return [UIColor colorWithPatternImage:[UIImage imageNamed:@"read_bg_0"]];
    }
    return US_READER_BG_COLORS[self.bgColorIndex.integerValue];
}

- (void)setSelectedBgType:(USReaderBGType *)selectedBgType {
    _selectedBgType = selectedBgType;
    [self changeTextColor:selectedBgType.bgTextColor];
}

- (void)changeTextColor:(UIColor *)textColor {
    _textColor = textColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        return [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)statusTextColor {
    return [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
}

- (CGFloat)lineSpacing {
    if (self.spacingType == USSpacingTypeBig) {
        return 10;
    } else if (self.spacingType == USSpacingTypeMiddle) {
        return 7;
    }
    return 5;
}

- (CGFloat)paragraphSpacing {
    if (self.spacingType == USSpacingTypeBig) {
        return 20;
    } else if (self.spacingType == USSpacingTypeMiddle) {
        return 15;
    }
    return 10;
}

- (NSArray <USReaderBGType *>*)bgTypes {
    if (!_bgTypes) {
        USReaderBGType *whiteMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeWhite];
        USReaderBGType *nightMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeNight];
        USReaderBGType *yellowMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeYellow];
        USReaderBGType *greenMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeGreen];
        USReaderBGType *blackGreenMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeBlackGreen];
        USReaderBGType *pinkMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypePink];
        USReaderBGType *sheepskinMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeSheepSkin];
        USReaderBGType *violetMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeViolet];
        USReaderBGType *waterMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeWater];
        USReaderBGType *weekGreenMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeWeekPink];
        USReaderBGType *weekPinkMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeWeekPink];
        USReaderBGType *coffeeMode = [[USReaderBGType alloc] initWithModeType:USReaderBgModeTypeCoffee];
        _bgTypes = @[whiteMode, nightMode, yellowMode, greenMode, blackGreenMode, pinkMode, sheepskinMode, violetMode, waterMode, weekGreenMode, weekPinkMode, coffeeMode];
    }
    return _bgTypes;
}


@end


