//
//  USConstants.h
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import <UIKit/UIKit.h>
#import "USReaderModel.h"
#import <YYCategories/YYCategories.h>

NS_ASSUME_NONNULL_BEGIN

#define US_SAFEAREAINSETS  [USConstants safeAreaInsets]
#define US_SAFEAREAINSETS_BOTTOM  [USConstants safeAreaInsets].bottom
#define US_SAFEAREAINSETS_TOP  [USConstants safeAreaInsets].top
#define US_READERRECT [USConstants readerRect]
#define US_READER_TOP_INSET [USConstants readerTopInset]
#define US_READER_BOTTOM_INSET [USConstants readerBottomInset]
#define US_READER_LEFT_INSET [USConstants readerLeftInset]
#define US_READER_RIGHT_INSET [USConstants readerRightInset]
#define US_READER_INSETS UIEdgeInsetsMake(US_READER_TOP_INSET, US_READER_LEFT_INSET, US_READER_BOTTOM_INSET, US_READER_RIGHT_INSET)
#define US_ISXDEVICE [USConstants isXDevice]

#define US_DOCUMENTPATH [USConstants documentPath]
#define US_READERFOLDER [USConstants readerFolder]

#define CLOUDREBE_READER_TOTAL_PROGRESS(readModel, recordModel) [USConstants totalProgress:readModel recordModel:recordModel]
#define US_READER_LEFT_VIEW_WIDTH 335
#define US_READER_LEFT_HEADER_VIEW_HEIGHT 50

#define US_SCREENWIDTH [USConstants screenWidth]
#define US_SCREENHEIGHT [USConstants screenHeight]

#define US_RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define US_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define US_NAVIGATIONBAR_HEIGHT 103.0

#define US_READER_COLOR_253_85_103 US_RGB(253, 85, 103)
#define US_READER_COLOR_MENU_COLOR US_RGB(230, 230, 230)

#define USAssetImage(name) [USConstants assetBgImageName:name tintedColor:[UIColor whiteColor]]
#define USAssetBgImage(name, tintColor) [USConstants assetBgImageName:name tintedColor:tintColor]

@interface USConstants : NSObject

+ (UIEdgeInsets)safeAreaInsets;
+ (BOOL)isXDevice;
+ (CGRect)readerRect;
+ (CGFloat)readerLeftInset;
+ (CGFloat)readerRightInset;
+ (CGFloat)readerTopInset;
+ (CGFloat)readerBottomInset;

+ (NSString *)documentPath;
+ (NSString *)readerFolder;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
/// 计算总进度
+ (CGFloat)totalProgress:(USReaderModel *)readModel recordModel:(USReaderRecordModel *)recordModel;
/// 总进度字符串
+ (NSString *)totalProgressString:(CGFloat)progress;

/// 计算显示时间
+ (NSString *)TimerString:(NSInteger)time;
/// 获取指定时间字符串 (dateFormat: "YYYY-MM-dd-HH-mm-ss")
+ (NSString *)TimerString:(NSString *)dateFormat time:(NSDate *)time;
/// 获得当前时间戳
+ (NSTimeInterval)Timer1970:(BOOL)isMsec;

/// 设置行间距
+ (NSMutableAttributedString *)TextLineSpacing:(NSString *)string lineSpacing:(CGFloat)lineSpacing attrs:(NSMutableDictionary <NSAttributedStringKey, id>*)attrs;
/// 设置行间距
+ (NSMutableAttributedString *)TextLineSpacing:(NSString *)string lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode attrs:(NSMutableDictionary <NSAttributedStringKey, id>*)attrs;
/// 设置分割线
+ (UIView *)SpaceLine:(UIView *)view color:(UIColor *)color;


+ (UIImage *)assetBgImageName:(NSString *)name tintedColor:(UIColor *_Nullable)tintColor;

+ (NSBundle *)resourceBundle;

@end

NS_ASSUME_NONNULL_END
