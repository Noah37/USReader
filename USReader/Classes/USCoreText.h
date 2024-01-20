//
//  USCoreText.h
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface USCoreText : NSObject

/// 获得 CTFrame
///
/// - Parameters:
///   - attrString: 内容
///   - rect: 显示范围
/// - Returns: CTFrame
+ (CTFrameRef)GetFrameRef:(NSAttributedString *)attrString rect:(CGRect)rect;

/// 获得内容分页列表
///
/// - Parameters:
///   - attrString: 内容
///   - rect: 显示范围
/// - Returns: 内容分页列表
+ (NSArray <NSValue *>*)GetPageingRanges:(NSAttributedString *)attrString rect:(CGRect)rect;

/// 获得触摸位置文字的Location
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
/// - Returns: 触摸位置的Index
+ (CFIndex)GetTouchLocation:(CGPoint)point frameRef:(CTFrameRef)frameRef;

/// 获得触摸位置那一行文字的Range
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
/// - Returns: 一行的 NSRange
+ (NSRange)GetTouchLineRange:(CGPoint)point frameRef:(CTFrameRef)frameRef;

/// 获取一行文字的 Range
///
/// - Parameter line: CTLine
/// - Returns: 一行文字的 Range
+ (NSRange)GetLineRange:(CTLineRef)line;

/// 获得触摸位置在哪一行
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
/// - Returns: CTLine
+ (CTLineRef)GetTouchLine:(CGPoint)point frameRef:(CTFrameRef)frameRef;

/// 获得触摸位置那一个段落的 NSRange || 一行文字的 NSRange
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
///   - content: 内容字符串，传了则获取长按的段落 NSRange，没传则获取一行文字的 NSRange
/// - Returns: 一个段落的 NSRange || 一行文字的 NSRange
+ (NSRange)GetTouchParagraphRange:(CGPoint)point frameRef:(CTFrameRef)frameRef content:(NSString *)content;

/// 获取内容所有段落尾部 NSRange
///
/// - Parameters:
///   - frameRef: 内容 CTFrame
///   - content: 内容字符串，也就是生成 frameRef 的正文内容
/// - Returns: [NSRange] 传入内容的所有断尾 NSRange
+ (NSArray <NSValue *>*)GetParagraphEndRanges:(CTFrameRef)frameRef content:(NSString *)content;

/// 获取内容所有段落尾部 CGRect
///
/// - Parameters:
///   - frameRef: 内容 CTFrame
///   - content: 内容字符串，也就是生成 frameRef 的正文内容
/// - Returns: [CGRect] 传入内容的所有断尾 CGRect
+ (NSArray <NSValue *>*)GetParagraphEndRects:(CTFrameRef)frameRef content:(NSString *)content;

/// 通过 range 返回字符串所覆盖的位置 [CGRect]
///
/// - Parameter range: NSRange
/// - Parameter frameRef: 内容 CTFrame
/// - Parameter content: 内容字符串(有值则可以去除选中每一行区域内的 开头空格 - 尾部换行符 - 所占用的区域,不传默认返回每一行实际占用区域)
/// - Returns: 覆盖位置
+ (NSArray <NSValue *>*)GetRangeRects:(NSRange)range frameRef:(CTFrameRef)frameRef content:(NSString *)content;

/// 通过 range 获得合适的 MenuRect
///
/// - Parameter rects: [CGRect]
/// - Parameter frameRef: 内容 CTFrame
/// - Parameter viewFrame: 目标ViewFrame
/// - Parameter content: 内容字符串
/// - Returns: MenuRect
+ (CGRect)GetMenuRect:(NSRange)range frameRef:(CTFrameRef)frameRef viewFrame:(CGRect)viewFrame content:(NSString *)content;

/// 通过 [CGRect] 获得合适的 MenuRect
///
/// - Parameter rects: [CGRect]
/// - Parameter viewFrame: 目标ViewFrame
/// - Returns: MenuRect
+ (CGRect)GetMenuRect:(NSArray <NSValue *>*)rects viewFrame:(CGRect)viewFrame;

/// 获取指定内容高度
///
/// - Parameters:
///   - attrString: 内容
///   - maxW: 最大宽度
/// - Returns: 当前高度
+ (CGFloat)GetAttrStringHeight:(NSAttributedString *)attrString maxW:(CGFloat)maxW;

/// 获取行高
///
/// - Parameter line: CTLine
/// - Returns: 行高
+ (CGFloat)GetLineHeight:(CTFrameRef)frameRef;

/// 获取行高
///
/// - Parameter line: CTLine
/// - Returns: 行高
+ (CGFloat)GetLineHeightWithLine:(CTLineRef)line;

@end

NS_ASSUME_NONNULL_END
