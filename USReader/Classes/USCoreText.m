//
//  USCoreText.m
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import "USCoreText.h"
#import "NSString+Reader.h"

@implementation USCoreText

/// 获得 CTFrame
///
/// - Parameters:
///   - attrString: 内容
///   - rect: 显示范围
/// - Returns: CTFrame
+ (CTFrameRef)GetFrameRef:(NSAttributedString *)attrString rect:(CGRect)rect {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
    return frameRef;
}

/// 获得内容分页列表
///
/// - Parameters:
///   - attrString: 内容
///   - rect: 显示范围
/// - Returns: 内容分页列表
+ (NSArray <NSValue *>*)GetPageingRanges:(NSAttributedString *)attrString rect:(CGRect)rect {
    NSMutableArray *rangeArray = [NSMutableArray array];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CFRange range = CFRangeMake(0, 0);
    NSInteger rangeOffset = 0;
    while (range.location + range.length < attrString.length) {
        CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(rangeOffset, 0), path, nil);
        range = CTFrameGetVisibleStringRange(frameRef);
        [rangeArray addObject:[NSValue valueWithRange:NSMakeRange(rangeOffset, range.length)]];
        rangeOffset += range.length;
    }
    return rangeArray;
}

/// 获得触摸位置文字的Location
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
/// - Returns: 触摸位置的Index
+ (CFIndex)GetTouchLocation:(CGPoint)point frameRef:(CTFrameRef)frameRef {
    CFIndex location = -1;
    CTLineRef line = [self GetTouchLine:point frameRef:frameRef];
    if (line != nil) {
        location = CTLineGetStringIndexForPosition(line, point);
    }
    return location;
}

/// 获得触摸位置那一行文字的Range
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
/// - Returns: 一行的 NSRange
+ (NSRange)GetTouchLineRange:(CGPoint)point frameRef:(CTFrameRef)frameRef {
    CTLineRef line = [self GetTouchLine:point frameRef:frameRef];
    return [self GetLineRange:line];
}

/// 获取一行文字的 Range
///
/// - Parameter line: CTLine
/// - Returns: 一行文字的 Range
+ (NSRange)GetLineRange:(CTLineRef)line {
    NSRange range = NSMakeRange(NSNotFound, 0);
    if (line != nil) {
        CFRange lineRange = CTLineGetStringRange(line);
        range = NSMakeRange(lineRange.location == kCFNotFound ? NSNotFound:lineRange.location, lineRange.length);
    }
    return range;
}

/// 获得触摸位置在哪一行
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
/// - Returns: CTLine
+ (CTLineRef)GetTouchLine:(CGPoint)point frameRef:(CTFrameRef)frameRef {
    CTLineRef line = nil;
    if (frameRef == nil) {
        return line;
    }
    CGPathRef path = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(path);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    NSInteger lineCount = CFArrayGetCount(lines);
    if (lineCount == 0) {
        return line;
    }
    CGPoint *origins = NULL;
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    for (NSInteger i = 0; i < lineCount; i++) {
        CGPoint origin = origins[i];
        CTLineRef tempLine = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineDescent = 0;
        CGFloat lineAscent = 0;
        CGFloat lineLeading = 0;
        CTLineGetTypographicBounds(tempLine, &lineAscent, &lineDescent, &lineLeading);
        
        CGFloat lineWidth = bounds.size.width;
        
        CGFloat lineHeight = lineAscent + lineDescent + lineLeading;
        
        CGRect lineFrame = CGRectMake(origin.x, bounds.size.height - origin.y - lineAscent, lineWidth, lineHeight);
        lineFrame = CGRectInset(lineFrame, -5, -5);
        
        if (CGRectContainsPoint(lineFrame, point)) {
            line = tempLine;
            break;
        }
        
    }
    free(origins);
    
    return line;
}

/// 获得触摸位置那一个段落的 NSRange || 一行文字的 NSRange
///
/// - Parameters:
///   - point: 触摸位置
///   - frameRef: 内容 CTFrame
///   - content: 内容字符串，传了则获取长按的段落 NSRange，没传则获取一行文字的 NSRange
/// - Returns: 一个段落的 NSRange || 一行文字的 NSRange
+ (NSRange)GetTouchParagraphRange:(CGPoint)point frameRef:(CTFrameRef)frameRef content:(NSString *)content {
    CTLineRef line = [self GetTouchLine:point frameRef:frameRef];
    NSRange range = [self GetLineRange:line];
    
    // 如果有正文，则获取整个段落的 NSRange
    if (line != nil && content != nil) {
        CFArrayRef lines = CTFrameGetLines(frameRef);
        NSInteger count = CFArrayGetCount(lines);
        NSArray *nsLines = (__bridge NSArray *)(lines);
        NSInteger index = [nsLines indexOfObject:(__bridge id _Nonnull)(line)];
        NSInteger num = 0;
        
        NSRange rangeHeader = range;
        NSRange rangeFooter = range;
        BOOL isHeader = NO;
        BOOL isFooter = NO;
        
        while (!isHeader || !isFooter) {
            if (!isHeader) {
                NSInteger newIndex = index - num;
                CTLineRef line = CFArrayGetValueAtIndex(lines, newIndex);
                rangeHeader = [self GetLineRange:line];
                
                NSString * headerString = [content substringWithRange:rangeHeader];
                isHeader = [headerString containsString:@"　　"];
                if (newIndex == 0) {
                    isHeader = YES;
                }
            }
            if (isFooter) {
                NSInteger newIndex = index + num;
                CTLineRef line = CFArrayGetValueAtIndex(lines, newIndex);
                rangeFooter = [self GetLineRange:line];
                
                NSString * footerString = [content substringWithRange:rangeFooter];
                isFooter = [footerString containsString:@"\n"];
                if (newIndex == (count - 1)) {
                    isFooter = YES;
                }
            }
            num += 1;
        }
        range = NSMakeRange(rangeHeader.location, rangeFooter.location + rangeFooter.length - rangeHeader.location);
    }
    return range;
}

/// 获取内容所有段落尾部 NSRange
///
/// - Parameters:
///   - frameRef: 内容 CTFrame
///   - content: 内容字符串，也就是生成 frameRef 的正文内容
/// - Returns: [NSRange] 传入内容的所有断尾 NSRange
+ (NSArray <NSValue *>*)GetParagraphEndRanges:(CTFrameRef)frameRef content:(NSString *)content {
    NSMutableArray *ranges = [NSMutableArray array];
    if (frameRef != nil && content != nil) {
        CFArrayRef lines = CTFrameGetLines(frameRef);
        CFIndex count = CFArrayGetCount(lines);
        for (NSInteger index = 0; index < count; index++) {
            CTLineRef line = CFArrayGetValueAtIndex(lines, index);
            NSRange lintRang = [self GetLineRange:line];
            NSString *lineString = [content substringWithRange:lintRang];
            BOOL isEnd = [lineString containsString:@"\n"];
            if (isEnd) {
                [ranges addObject:[NSValue valueWithRange:lintRang]];
            }
        }
    }
    return ranges;
}

/// 获取内容所有段落尾部 CGRect
///
/// - Parameters:
///   - frameRef: 内容 CTFrame
///   - content: 内容字符串，也就是生成 frameRef 的正文内容
/// - Returns: [CGRect] 传入内容的所有断尾 CGRect
+ (NSArray <NSValue *>*)GetParagraphEndRects:(CTFrameRef)frameRef content:(NSString *)content {
    NSMutableArray *rects = [NSMutableArray array];
    NSArray * ranges = [self GetParagraphEndRanges:frameRef content:content];
    for (NSValue *range in ranges) {
        NSArray *rect = [self GetRangeRects:[range rangeValue] frameRef:frameRef content:content];
        [rects addObjectsFromArray:rect];
    }
    return rects;
}

/// 通过 range 返回字符串所覆盖的位置 [CGRect]
///
/// - Parameter range: NSRange
/// - Parameter frameRef: 内容 CTFrame
/// - Parameter content: 内容字符串(有值则可以去除选中每一行区域内的 开头空格 - 尾部换行符 - 所占用的区域,不传默认返回每一行实际占用区域)
/// - Returns: 覆盖位置
+ (NSArray <NSValue *>*)GetRangeRects:(NSRange)range frameRef:(CTFrameRef)frameRef content:(NSString *)content {
    NSMutableArray *rects = [NSMutableArray array];
    if (frameRef == nil) {
        return rects;
    }
    if (range.location == 0 || range.location == NSNotFound) {
        return rects;
    }
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint *origins = NULL;
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    for (NSInteger index = 0; index < count; index++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        CFRange lineCFRange = CTLineGetStringRange(line);
        NSRange lineRange = NSMakeRange(lineCFRange.location == kCFNotFound ? NSNotFound:lineCFRange.location, lineCFRange.length);
        
        NSRange contentRange = NSMakeRange(NSNotFound, 0);
        
        if ((lineRange.location + lineRange.length) > range.location && lineRange.location < (range.location + range.location)) {
            contentRange.location = MAX(lineRange.location, range.location);
            NSInteger end = MIN(lineRange.location + lineRange.length, range.location + range.length);
            contentRange.length = end = contentRange.location;
        }
        if (contentRange.length > 0) {
            // 去掉 -> 开头空格 - 尾部换行符 - 所占用的区域
            if (content != nil && ![content isEqualToString:@""]) {
                NSString *tempContent = [content substringWithRange:contentRange];
                NSArray <NSTextCheckingResult *>*spaceRanges = [tempContent matches:@"\\s\\s"];
                if (spaceRanges.count > 0) {
                    NSRange spaceRange = spaceRanges.firstObject.range;
                    contentRange = NSMakeRange(contentRange.location + spaceRange.length, contentRange.length - spaceRange.length);
                }
                NSArray <NSTextCheckingResult *>*enterRanges = [tempContent matches:@"\\n"];
                if (enterRanges.count > 0) {
                    NSRange enterRange = enterRanges.firstObject.range;
                    contentRange = NSMakeRange(contentRange.location, contentRange.length - enterRange.length);
                }
            }
            // 正常使用(如果不需要排除段头空格跟段尾换行符可将上面代码删除)
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, contentRange.location, nil);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, contentRange.location + contentRange.length, nil);
            CGPoint origin = origins[index];
            CGFloat lineAscent = 0;
            CGFloat lineDescent = 0;
            CGFloat lineLeading = 0;

            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            
            CGRect contentRect = CGRectMake(origin.x + xStart, origin.y - lineDescent, fabs(xEnd - xStart), lineAscent + lineDescent + lineLeading);
            [rects addObject:[NSValue valueWithCGRect:contentRect]];
        }
    }
    free(origins);
    return rects;
}

/// 通过 range 获得合适的 MenuRect
///
/// - Parameter rects: [CGRect]
/// - Parameter frameRef: 内容 CTFrame
/// - Parameter viewFrame: 目标ViewFrame
/// - Parameter content: 内容字符串
/// - Returns: MenuRect
+ (CGRect)GetMenuRect:(NSRange)range frameRef:(CTFrameRef)frameRef viewFrame:(CGRect)viewFrame content:(NSString *)content {
    NSArray *rects = [self GetRangeRects:range frameRef:frameRef content:content];
    return [self GetMenuRect:rects viewFrame:viewFrame ];
}

/// 通过 [CGRect] 获得合适的 MenuRect
///
/// - Parameter rects: [CGRect]
/// - Parameter viewFrame: 目标ViewFrame
/// - Returns: MenuRect
+ (CGRect)GetMenuRect:(NSArray <NSValue *>*)rects viewFrame:(CGRect)viewFrame {
    CGRect menuRect = CGRectZero;
    if (rects.count == 0) {
        return menuRect;
    }
    if (rects.count == 1) {
        menuRect = [rects.firstObject CGRectValue];
    } else {
        menuRect = [rects.firstObject CGRectValue];
        NSInteger count = rects.count;
        for (NSInteger index = 0; index < count; index++) {
            CGRect rect = [rects[index] CGRectValue];
            CGFloat minX = CGRectGetMinX(rect);
            CGFloat maxX = CGRectGetMaxX(rect);
            CGFloat minY = CGRectGetMinY(rect);
            CGFloat maxY = CGRectGetMaxY(rect);
            menuRect.origin.x = minX;
            menuRect.origin.y = minY;
            menuRect.size.width = maxX - minX;
            menuRect.size.height = maxY - minY;
        }
    }
    menuRect.origin.y = viewFrame.size.height - menuRect.origin.y - menuRect.size.height;
    return menuRect;
}

/// 获取指定内容高度
///
/// - Parameters:
///   - attrString: 内容
///   - maxW: 最大宽度
/// - Returns: 当前高度
+ (CGFloat)GetAttrStringHeight:(NSAttributedString *)attrString maxW:(CGFloat)maxW {
    CGFloat height = 0;
    if (attrString.length > 0) {
        // 注意设置的高度必须大于文本高度
        CGFloat maxH = 1000;
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
        // 计算高度一行代码就够了，底下的注释代码虽然也能计算，但是过于麻烦
        CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(maxW, CGFLOAT_MAX), nil);

//        CGRect drawingRect = CGRectMake(0, 0, maxW, maxH);
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, drawingRect);
//        
//        
//        CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil);
//        CFArrayRef lines = CTFrameGetLines(frameRef);
//        CFIndex indexCount = CFArrayGetCount(lines);
//        CGPoint origins[indexCount];
//        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
//        NSInteger lineCount = CFArrayGetCount(lines);
//        CGFloat lineY = origins[lineCount - 1].y;
//        CGFloat lineAscent = 0;
//        CGFloat lineDescent = 0;
//        CGFloat lineLeading = 0;
//        
//        CTLineGetTypographicBounds(CFArrayGetValueAtIndex(lines, lineCount - 1), &lineAscent, &lineDescent, &lineLeading);
//        
//        height = maxH - lineY + ceilf(lineDescent);
        height = textSize.height;
    }
    return height;
}

//
/// 获取行高
///
/// - Parameter line: CTLine
/// - Returns: 行高
+ (CGFloat)GetLineHeight:(CTFrameRef)frameRef {
    if (frameRef == nil) {
        return 0;
    }
    CFArrayRef lines = CTFrameGetLines(frameRef);
    if (CFArrayGetCount(lines) == 0) {
        return 0;
    }
    return [self GetLineHeightWithLine:CFArrayGetValueAtIndex(lines, 0)];
}

/// 获取行高
///
/// - Parameter line: CTLine
/// - Returns: 行高
+ (CGFloat)GetLineHeightWithLine:(CTLineRef)line {
    if (line == nil) {
        return 0;
    }
    CGFloat lineAscent = 0;
    CGFloat lineDescent = 0;
    CGFloat lineLeading = 0;
    CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
    
    return lineAscent + lineDescent + lineLeading;
}

@end

