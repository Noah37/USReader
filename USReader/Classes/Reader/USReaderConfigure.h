//
//  USReaderConfigure.h
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import <Foundation/Foundation.h>
#import "USReaderEffectTypeConfigure.h"
#import "USReaderBGType.h"
#import "USReaderFont.h"

typedef enum : NSUInteger {
    USProgressTypeTotal,
    USProgressTypePage,
} USProgressType;

/// 阅读字体类型
typedef enum : NSUInteger {
    USFontTypeSystem, /// 系统
    USFontTypeOne, /// 黑体
    USFontTypeTwo, /// 楷体
    USFontTypeThree /// 宋体
} USFontType;

/// 阅读内容间距类型
typedef enum : NSUInteger {
    USSpacingTypeBig, /// 大间距
    USSpacingTypeMiddle, /// 适中间距
    USSpacingTypeSmall, /// 小间距
} USSpacingType;

NS_ASSUME_NONNULL_BEGIN

/// 阅读最小阅读字体大小
#define US_READER_FONT_SIZE_MIN 12

/// 阅读最大阅读字体大小
#define US_READER_FONT_SIZE_MAX 36
/// 阅读默认字体大小
#define US_READer_FONT_SIZE_DEFAULT 18

/// 阅读最大亮度
#define US_READER_LIGHT_MAX 1
/// 阅读最小亮度
#define US_READER_Light_MIN 0.3

@interface USReaderConfigure : NSObject

/// 段间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
@property (nonatomic, assign, readonly) CGFloat paragraphSpacing;
/// 行间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
@property (nonatomic, assign, readonly) CGFloat lineSpacing;
/// 背景颜色
@property (nonatomic, strong, readonly) UIColor *bgColor;
/// 字体颜色
@property (nonatomic, strong, readonly) UIColor *textColor;
/// 进度显示索引
@property (nonatomic, strong) NSNumber *progressIndex;
/// 字体大小
@property (nonatomic, strong) NSNumber *fontSize;
/// 状态栏字体颜色
@property (nonatomic, strong, readonly) UIColor *statusTextColor;
@property (nonatomic, assign, readonly) USProgressType progressType;

/// 翻页类型
@property (nonatomic, assign) USEffectType effectType;

/// 翻页类型
@property (nonatomic, strong) USReaderEffectTypeConfigure *effectTypeConfigure;

@property (nonatomic, strong) USReaderBGType *selectedBgType;

/// 自定义字体样式
@property (nonatomic, strong, readonly) NSArray <USReaderFontFile *>* customFontFiles;
/// 当前选中的自定义字体，不存在则使用系统字体
@property (nonatomic, strong, nullable) USReaderFontFile *customFont;
/// 亮度设置 [US_READER_LIGHT_MIN,US_READER_LIGHT_MAX]
@property (nonatomic, strong, readonly) NSNumber *light;

+ (instancetype)shared;
- (UIFont *)font:(BOOL)isTitle;
- (NSDictionary <NSAttributedStringKey, id>*)attributes:(BOOL)isTitle isPaging:(BOOL)isPaging;
- (void)save;

- (NSArray <USReaderBGType *>*)bgTypes;

- (void)fontPlus;
- (void)fontMinus;

- (void)changeLight:(CGFloat)light;

@end

NS_ASSUME_NONNULL_END
