//
//  USConstants.m
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import "USConstants.h"

@implementation USConstants

+ (UIEdgeInsets)safeAreaInsets {
    return [UIApplication sharedApplication].keyWindow.safeAreaInsets;
}

+ (BOOL)isXDevice {
    return [self safeAreaInsets].top > 0;
}

+ (CGFloat)screenWidth {
    return [UIApplication sharedApplication].keyWindow.bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIApplication sharedApplication].keyWindow.bounds.size.height;
}

+ (CGRect)readerRect {
    CGFloat top = [self readerTopInset];
    CGFloat left = [self readerLeftInset];
    CGFloat right = [self readerRightInset];
    CGFloat bottom = [self readerBottomInset];
    CGFloat width = [self screenWidth];
    CGFloat height = [self screenHeight];
    return CGRectMake(left, top, width - left - right, height - top - bottom);
}

+ (CGFloat)readerLeftInset {
    return 15;
}

+ (CGFloat)readerRightInset {
    return 15;
}

+ (CGFloat)readerTopInset {
    return [self safeAreaInsets].top;
}

+ (CGFloat)readerBottomInset {
    return [self safeAreaInsets].bottom;
}

+ (NSString *)documentPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)readerFolder {
    return @"USReader";
}

/// 总进度字符串
+ (NSString *)totalProgressString:(CGFloat)progress {
    return [NSString stringWithFormat:@"%.1f%%", floor(progress * 1000)/10];
}

/// 获得当前时间戳
+ (NSTimeInterval)Timer1970:(BOOL)isMsec {
    if (isMsec) {
        return [[NSDate date] timeIntervalSince1970] * 1000;
    } else {
        return [[NSDate date] timeIntervalSince1970];
    }
}

/// 获取指定时间字符串 (dateFormat: "YYYY-MM-dd-HH-mm-ss")
+ (NSString *)TimerString:(NSString *)dateFormat time:(NSDate *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:time];
}

/// 计算显示时间
+ (NSString *)TimerString:(NSInteger)time {
    NSInteger currentTime = [self Timer1970:NO];
    NSTimeInterval spacing = currentTime - time;
    if (spacing < 60) {
        return @"刚刚";
    } else if (spacing < (60 * 60)) {
        return [NSString stringWithFormat:@"%f分钟前", spacing/60];
    } else if (spacing < (60 * 60 * 24)) {
        return [NSString stringWithFormat:@"%f小时前", spacing/60/60];
    } else if (spacing < (60 * 60 * 24 * 4)) {
        return [NSString stringWithFormat:@"%f天前", spacing/60/60/24];
    } else {
        NSString *timeString = [self TimerString:@"YYYY-MM-dd HH:mm" time:[NSDate dateWithTimeIntervalSince1970:time]];
        timeString = [timeString stringByReplacingOccurrencesOfString:[self TimerString:@"YYYY-" time:[NSDate date]] withString:@""];
        return timeString;
    }
}

/// 设置行间距
+ (NSMutableAttributedString *)TextLineSpacing:(NSString *)string lineSpacing:(CGFloat)lineSpacing attrs:(NSMutableDictionary <NSAttributedStringKey, id>*)attrs {
    return [self TextLineSpacing:string lineSpacing:lineSpacing lineBreakMode:(NSLineBreakByTruncatingTail) attrs:attrs];
}

/// 设置行间距
+ (NSMutableAttributedString *)TextLineSpacing:(NSString *)string lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode attrs:(NSMutableDictionary <NSAttributedStringKey, id>*)attrs {
    
    NSMutableDictionary *dict = attrs ? attrs:[NSMutableDictionary dictionary];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    style.lineBreakMode = lineBreakMode;
    dict[NSParagraphStyleAttributeName] = style;
    
    return [[NSMutableAttributedString alloc] initWithString:string attributes:dict];
}

/// 计算总进度
+ (CGFloat)totalProgress:(USReaderModel *)readModel recordModel:(USReaderRecordModel *)recordModel {
    CGFloat progress = 0.0;
    
    if (readModel == nil || recordModel == nil) {
        return progress;
    }
    if (recordModel.isLastChapter && recordModel.isLastPage) { // 最后一章最后一页
        progress = 1.0;
    } else {
        // 当前章节在所有章节列表中的位置
        CGFloat chapterIndex = recordModel.chapterModel.priority.doubleValue;
        
        // 章节总数量
        CGFloat chapterCount = readModel.chapterListModels.count;
        // 阅读记录首位置
        CGFloat locationFirst = recordModel.locationFirst.doubleValue;
        // 阅读记录内容长度
        CGFloat fullContentLength = recordModel.chapterModel.fullContent.length;
        // 获得当前阅读进度
        progress = chapterIndex/chapterCount + locationFirst/fullContentLength/chapterCount;
    }
    return progress;
}

/// 设置分割线
+ (UIView *)SpaceLine:(UIView *)view color:(UIColor *)color {
    UIView *spaceLine = [[UIView alloc] init];
    spaceLine.backgroundColor = color;
    [view addSubview:spaceLine];
    return spaceLine;
}

+ (UIImage *)assetBgImageName:(NSString *)name tintedColor:(UIColor *)tintColor {
    
    UIImage *image = [UIImage imageNamed:name inBundle:[self resourceBundle] compatibleWithTraitCollection:nil];
    if (tintColor) {
        return [image imageByTintColor:tintColor];
    }
    return image;
}

+ (NSBundle *)resourceBundle {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                                stringByAppendingPathComponent:@"/USReader.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    return resource_bundle;
}

@end
