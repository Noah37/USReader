//
//  NSString+Reader.m
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import "NSString+Reader.h"

@implementation NSString (Reader)

+ (NSString *)chapterPrefix {
    return @"#\\[.*?\\]#";
}

- (NSString *)getReaderChapterName {
    return [[NSString stringWithFormat:@"\n%@\n\n", self] replacingCharacters:[NSString chapterPrefix] templateString:@""];
}

- (BOOL)isEmpty {
    return [self isEqualToString:@""];
}

/// 正则搜索相关字符位置
- (NSArray <NSTextCheckingResult *>*)matches:(NSString *)pattern {
    if ([self isEmpty]) {
        return @[];
    }
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:(NSRegularExpressionCaseInsensitive) error:nil];
    return [regularExpression matchesInString:self options:(NSMatchingReportProgress) range:NSMakeRange(0, self.length)];
}

/// 正则替换字符
- (NSString *)replacingCharacters:(NSString *)pattern templateString:(NSString *)template {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:(NSRegularExpressionCaseInsensitive) error:nil];
    return [regularExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:template];
}

/// 去除首尾空格和换行
- (NSString *)removeSEHeadAndTail {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeAllWhitespaceAndNewline {
    NSString *result = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"　　" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"”" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return result;
}

- (BOOL)isImageFile {
    return [self hasSuffix:@".jpg"] || [self hasSuffix:@".png"];
}

- (BOOL)isTxtFile {
    return [self hasSuffix:@".txt"];
}

@end
