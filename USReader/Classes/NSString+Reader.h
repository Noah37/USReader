//
//  NSString+Reader.h
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define US_CHAPTER_NAME(name) [name getReaderChapterName]

@interface NSString (Reader)

+ (NSString *)chapterPrefix;

- (NSString *)getReaderChapterName;

- (BOOL)isEmpty;

/// 正则搜索相关字符位置
- (NSArray <NSTextCheckingResult *>*)matches:(NSString *)pattern;

/// 正则替换字符
- (NSString *)replacingCharacters:(NSString *)pattern templateString:(NSString *)templateString;

/// 去除首尾空格和换行
- (NSString *)removeSEHeadAndTail;

- (NSString *)removeAllWhitespaceAndNewline;

- (BOOL)isImageFile;
- (BOOL)isTxtFile;

@end

NS_ASSUME_NONNULL_END
