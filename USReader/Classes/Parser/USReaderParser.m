//
//  USReaderParser.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderParser.h"
#import "USReaderPageModel.h"
#import "USConstants.h"
#import "USCoreText.h"
#import "USReaderConfigure.h"
#import "NSString+Reader.h"
#import "USReaderTextFastParser.h"

@implementation USReaderParser

// MARK: -- 内容分页

/// 内容分页
///
/// - Parameters:
///   - attrString: 内容
///   - rect: 显示范围
///   - isFirstChapter: 是否为本文章第一个展示章节,如果是则加入书籍首页。(小技巧:如果不需要书籍首页,可不用传,默认就是不带书籍首页)
/// - Returns: 内容分页列表
+ (NSArray <USReaderPageModel *>*)pageing:(NSAttributedString *)attrString rect:(CGRect)rect isFirstChapter:(BOOL)isFirstChapter {
    NSMutableArray <USReaderPageModel *>* pageModels = [NSMutableArray array];
    
    NSArray <NSValue *>* ranges = [USCoreText GetPageingRanges:attrString rect:rect];
    if (ranges.count > 0) {
        NSInteger count = ranges.count;
        for (NSInteger index = 0; index < count; index++) {
            NSRange range = [ranges[index] rangeValue];
            NSAttributedString *content = [attrString attributedSubstringFromRange:range];
            USReaderPageModel *pageModel = [[USReaderPageModel alloc] init];
            pageModel.range = range;
            pageModel.content = content;
            pageModel.page = [NSNumber numberWithInteger:index];
            // --- (滚动模式 || 长按菜单) 使用 ---

            // 注意: 为什么这些数据会放到这里赋值，而不是封装起来， 原因是 contentSize 计算封装在 pageModel内部计算出现宽高为0的情况，所以放出来到这里计算，原因还未找到，但是放到这里计算就没有问题。封装起来则会出现宽高度不计算的情况。

            // 内容Size (滚动模式 || 长按菜单)
            CGFloat maxW = US_READERRECT.size.width;
            pageModel.contentSize = CGSizeMake(maxW, [USCoreText GetAttrStringHeight:content maxW:maxW]);
            // 当前页面开头是什么数据开头 (滚动模式)
            if (index == 0) {
                pageModel.headTypeIndex = @(USPageHeadTypeChapterName);
            } else if ([content.string hasPrefix:@"　　"]) {
                pageModel.headTypeIndex = @(USPageHeadTypeParagraph);
            } else {
                pageModel.headTypeIndex = @(USPageHeadTypeLine);
            }
            // 根据开头类型返回开头高度 (滚动模式)
            if (pageModel.headType == USPageHeadTypeChapterName) {
                pageModel.headTypeHeight = 0;
            } else if (pageModel.headType == USPageHeadTypeParagraph) {
                pageModel.headTypeHeight = [USReaderConfigure shared].paragraphSpacing;
            } else {
                pageModel.headTypeHeight = [USReaderConfigure shared].lineSpacing;
            }
            // --- (滚动模式 || 长按菜单) 使用 ---
            [pageModels addObject:pageModel];
        }
        
    }
    
    return pageModels;
}

// MARK: -- 内容整理排版

/// 内容排版整理
///
/// - Parameter content: 内容
/// - Returns: 整理好的内容
+ (NSString *)contentTypesetting:(NSString *)content {
    NSString *cont = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    cont = [content replacingCharacters:@"\\s*\\n+\\s*" templateString:@"\n　　"];
    
    return cont;
}

// MARK: -- 解码URL

/// 解码URL
///
/// - Parameter url: 文件路径
/// - Returns: 内容
+ (NSString *)encode:(NSURL *)url {
    NSString *content = @"";
    if (url.absoluteString.isEmpty) {
        return content;
    }
    content = [self encode:url encoding:NSUTF8StringEncoding];
    if (content.isEmpty) {
        content = [self encode:url encoding:0x80000632];
    }
    if (content.isEmpty) {
        content = [self encode:url encoding:0x80000631];
    }
    if (content.isEmpty) {
        content = @"";
    }
    return content;
}

/// 解析URL
///
/// - Parameters:
///   - url: 文件路径
///   - encoding: 进制编码
/// - Returns: 内容
+ (NSString *)encode:(NSURL *)url encoding:(NSStringEncoding)encoding {
    return [[NSString alloc] initWithContentsOfURL:url encoding:encoding error:nil];
}

#pragma mark - 解析当前小说文件夹
- (void)parseNovel:(NSString *)path {
    NSArray<NSString *> * contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *content in contents) {
        NSString *filePath = [path stringByAppendingPathComponent:content];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (isDirectory && [content isEqualToString:[self chapters]]) {
            /// 解析所有章节信息
            NSArray<NSString *> * chapters = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
            for (NSString *chapter in chapters) {
                NSString *chapterPath = [filePath stringByAppendingPathComponent:chapter];
                [USReaderTextFastParser parser:[NSURL fileURLWithPath:chapterPath]];
                
            }
        } else if ([content isImageFile]) {
            /// 解析小说封面图片
        } else if ([content isTxtFile]) {
            /// 解析小说名称及分类等
            
        }
    }
}

- (NSString *)chapters {
    return @"chapters";
}

@end
