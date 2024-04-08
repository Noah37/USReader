//
//  USReaderTextFastParser.m
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import "USReaderTextFastParser.h"
#import "NSString+Reader.h"
#import "USReaderParser.h"
#import "USReaderChapterModel.h"
#import "NSArray+USReader.h"

typedef NSDictionary<NSString *, NSValue *> USValueDict;

@interface USReaderTextFastParser ()

@end

@implementation USReaderTextFastParser

/// 异步解析本地链接
///
/// - Parameters:
///   - url: 本地文件地址
///   - completion: 解析完成
+ (void)parser:(NSURL *)url completion:(void(^)(USReaderModel *))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        USReaderModel *readModel = [self parser:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(readModel);
            }
        });
    });
}

/// 解析本地链接
///
/// - Parameter url: 本地文件地址
/// - Returns: 阅读对象
+ (USReaderModel *)parserTXT:(NSURL *)url {
    // 链接不为空且是本地文件路径
    if (url == nil || url.absoluteString.isEmpty || !url.isFileURL) {
        return nil;
    }
    // 获取文件后缀名作为 bookName
    NSString *bookName = [url.absoluteString stringByRemovingPercentEncoding].lastPathComponent.stringByDeletingPathExtension;
    // bookName 作为 bookID
    NSString *bookId = bookName;
    if (bookId.isEmpty) {
        return nil;
    }
    if (![USReaderModel isExist:bookId]) {
        NSString *content = [USReaderParser encode:url];
        if (content.isEmpty) {
            return nil;
        }
        USReaderModel *readModel = [USReaderModel model:bookId];
        readModel.bookSourceType = USBookSourceTypeLocal;
        readModel.bookName = bookName;
        [self parse:readModel content:content];
        
        if (readModel.chapterListModels.count == 0) {
            return nil;
        }
        NSMutableArray <USReaderChapterListModel *>*chapterListModels = readModel.chapterListModels;
        USReaderChapterListModel *chapterListModel = nil;
        // 插入第一章，介绍文案等
        NSInteger firstIndex = chapterListModels.firstObject.idString.integerValue;
        if (firstIndex > 0) {
            firstIndex -= 1;
        }
        USReaderChapterModel *firstChapterModel  = [[USReaderChapterModel alloc] init];
        firstChapterModel.bookID = bookName;
        firstChapterModel.idString = [NSNumber numberWithInteger:firstIndex];
        firstChapterModel.name = bookName;
        firstChapterModel.content = bookName;
        firstChapterModel.previousChapterID = nil;
        firstChapterModel.nextChapterID = chapterListModels.firstObject.idString;
        [firstChapterModel save];
        
        chapterListModel = [self GetChapterListModel:firstChapterModel];
        [chapterListModels insertObject:chapterListModel atIndex:0];
        readModel.chapterListModels = chapterListModels;
        
        [readModel.recordModel modify:chapterListModel.idString toPage:0 isSave:YES];
        
        // 遍历所有chapterModel
        for (USReaderChapterListModel *chapterListModel in chapterListModels) {
            [self parser:readModel chapterId:chapterListModel.idString isUpdateFont:YES];
        }
                
        [self parserChapter:firstChapterModel readModel:readModel chapterId:chapterListModel.idString isUpdateFont:YES];

        [readModel save];
        
        return readModel;
    } else {
        return [USReaderModel model:bookId];
    }
}

+ (USReaderModel *)parnerNovelChaptersURL:(NSURL *)url {
    // 链接不为空且是本地文件路径
    if (url == nil || url.absoluteString.isEmpty || !url.isFileURL) {
        return nil;
    }
    // 获取文件后缀名作为 bookName
    NSString *bookName = [url.absoluteString stringByRemovingPercentEncoding].lastPathComponent.stringByDeletingPathExtension;
    // bookName 作为 bookID
    NSString *bookId = bookName;
    if (bookId.isEmpty) {
        return nil;
    }
    if (![USReaderModel isExist:bookId]) {
        NSString *content = [USReaderParser encode:url];
        if (content.isEmpty) {
            return nil;
        }
        USReaderModel *readModel = [USReaderModel model:bookId];
        readModel.bookSourceType = USBookSourceTypeLocal;
        readModel.bookName = bookName;
        NSArray <NSURL *>* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:(NSDirectoryEnumerationSkipsHiddenFiles) error:nil];
        
        NSURL *avatarUrl = [contents usfirst:^BOOL(NSURL *obj) {
            return [obj.lastPathComponent containsString:@"avatar.jpg"];
        }];
        NSURL *bookUrl = [contents usfirst:^BOOL(NSURL *obj) {
            return [obj.lastPathComponent hasSuffix:@".txt"] && ![obj.lastPathComponent containsString:[self fullBookSuffix]];
        }];
        NSURL *fullBookUrl = [contents usfirst:^BOOL(NSURL *obj) {
            return [obj.lastPathComponent hasSuffix:@".txt"] && [obj.lastPathComponent containsString:[self fullBookSuffix]];
        }];
        UIImage *avatar = [[UIImage alloc] initWithContentsOfFile:[avatarUrl path]];
        NSString *bookContent = [[NSString alloc] initWithContentsOfURL:bookUrl encoding:NSUTF8StringEncoding error:nil];
        NSArray *bookLines = [bookContent componentsSeparatedByString:@"\r\n"];
        if (bookLines.count <= 1) {
            bookLines = [bookContent componentsSeparatedByString:@"\n"];
        }
        NSString *author = bookLines[1];
        NSString *catalog = bookLines[2];
        NSString *bookDesc = bookLines[3];
        NSMutableArray <USReaderChapterListModel *> *chapterListModels = [NSMutableArray array];
        NSURL *chapterPathURL = [contents usfirst:^BOOL(NSURL *obj) {
            BOOL isDirectory = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:obj.path isDirectory:&isDirectory];
            return isDirectory;
        }];
        NSArray <NSString *>* chapters = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:chapterPathURL.path error:nil] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSInteger obj1Index = [obj1 componentsSeparatedByString:@"-"].firstObject.integerValue;
            NSInteger obj2Index = [obj2 componentsSeparatedByString:@"-"].firstObject.integerValue;
            if (obj1Index < obj2Index) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        chapters = [chapters usfilter:^BOOL(NSString *result, NSInteger idx) {
            return [result hasSuffix:@".txt"];
        }];
        USReaderChapterModel *lastChapterModel;
        NSInteger count = chapters.count;
        
        for (NSString *chapter in chapters) {
            NSInteger index  = [chapters indexOfObject:chapter];
            NSURL *chapterURL = [chapterPathURL URLByAppendingPathComponent:chapter];
            NSString *chapterContent = [[NSString alloc] initWithContentsOfURL:chapterURL encoding:NSUTF8StringEncoding error:nil];
            chapterContent = [chapterContent stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
            // 章节内容
            USReaderChapterModel *chapterModel  = [[USReaderChapterModel alloc] init];
            
            // 书ID
            chapterModel.bookID = bookName;
            
            // 章节ID
            chapterModel.idString = [NSNumber numberWithInteger:index + 1];
            
            // 章节名
            chapterModel.name = [chapter.lastPathComponent replacingCharacters:[NSString chapterPrefix] templateString:@""];
            // 内容
            chapterModel.content = chapterContent.removeSEHeadAndTail;
            
            // 优先级
            chapterModel.priority = [NSNumber numberWithInteger:0];
            
            if (index == count - 1) {
                chapterModel.nextChapterID = nil;
            } else {
                lastChapterModel.nextChapterID = chapterModel.idString;
            }
            if (index == 0) {
                /// 这里可以插入一个封面进去
                USReaderChapterModel *firstChapterModel  = [[USReaderChapterModel alloc] init];
                firstChapterModel.bookID = bookName;
                firstChapterModel.idString = [NSNumber numberWithInteger:0];
                firstChapterModel.name = bookName;
                firstChapterModel.content = bookDesc;
                firstChapterModel.previousChapterID = nil;
                firstChapterModel.nextChapterID = chapterModel.idString;
                firstChapterModel.avatar = avatar;
                firstChapterModel.catalog = catalog;
                firstChapterModel.bookDesc = bookDesc;
                firstChapterModel.author = author;
                [firstChapterModel save];
                lastChapterModel = firstChapterModel;
                [chapterListModels addObject:[self GetChapterListModel:firstChapterModel]];
            }
            chapterModel.previousChapterID = lastChapterModel.idString;
            
            // 保存
            [chapterModel save];
            [lastChapterModel save];
            
            lastChapterModel = chapterModel;
            
            // 添加章节列表模型
            [chapterListModels addObject:[self GetChapterListModel:chapterModel]];
        }
        readModel.chapterListModels = chapterListModels;
        [readModel.recordModel modify:chapterListModels.firstObject.idString toPage:0 isSave:YES];

        [readModel save];
        return readModel;
    } else {
        return [USReaderModel model:bookId];
    }
}

+ (USReaderModel *)parnerNovelFullBookURL:(NSURL *)url {
    // 链接不为空且是本地文件路径
    if (url == nil || url.absoluteString.isEmpty || !url.isFileURL) {
        return nil;
    }
    // 获取文件后缀名作为 bookName
    NSString *bookName = [url.absoluteString stringByRemovingPercentEncoding].lastPathComponent.stringByDeletingPathExtension;
    // bookName 作为 bookID
    NSString *bookId = bookName;
    if (bookId.isEmpty) {
        return nil;
    }
    if (![USReaderModel isExist:bookId]) {
        NSArray <NSURL *>* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:(NSDirectoryEnumerationSkipsHiddenFiles) error:nil];
        NSURL *fullBookUrl = [contents usfirst:^BOOL(NSURL *obj) {
            return [obj.lastPathComponent hasSuffix:@".txt"] && [obj.lastPathComponent containsString:[self fullBookSuffix]];
        }];
        // 全本txt存在，直接解析全本
        if (fullBookUrl) {
            return [self parser:fullBookUrl];
        }
        return nil;
    } else {
        return [USReaderModel model:bookId];
    }
}

+ (USReaderModel *)parserNovelURL:(NSURL *)url {
    if ([self isExistFullBook:url]) {
        return [self parnerNovelFullBookURL:url];
    } else if ([url.lastPathComponent isTxtFile]) {
        return [self parserTXT:url];
    } else {
        return [self parnerNovelChaptersURL:url];
    }
}

/// 获取章节列表对象
///
/// - Parameter chapterModel: 章节内容对象
/// - Returns: 章节列表对象
+ (USReaderChapterListModel *)GetChapterListModel:(USReaderChapterModel *)chapterModel {
    USReaderChapterListModel *chapterListModel = [[USReaderChapterListModel alloc] init];
    chapterListModel.bookId = chapterModel.bookID;
    chapterListModel.idString = chapterModel.idString;
    chapterListModel.name = chapterModel.name;
    return chapterListModel;
}

/// 解析本地链接
///
/// - Parameter url: 本地文件地址
/// - Returns: 阅读对象
+ (USReaderModel *)parser:(NSURL *)url {
    // 链接不为空且是本地文件路径
    if (url == nil || url.absoluteString.isEmpty || !url.isFileURL) {
        return nil;
    }
    // 获取文件后缀名作为 bookName
    NSString *bookName = [[url.absoluteString stringByRemovingPercentEncoding].lastPathComponent.stringByDeletingPathExtension stringByReplacingOccurrencesOfString:[self fullBookSuffix] withString:@""];
    // bookName 作为 bookID
    NSString *bookId = bookName;
    if (bookId.isEmpty) {
        return nil;
    }
    if (![USReaderModel isExist:bookId]) {
        NSString *content = [USReaderParser encode:url];
        if (content.isEmpty) {
            return nil;
        }
        USReaderModel *readModel = [USReaderModel model:bookId];
        readModel.bookSourceType = USBookSourceTypeLocal;
        readModel.bookName = bookName;
        [self parse:readModel content:content];
        
        if (readModel.chapterListModels.count == 0) {
            return nil;
        }
        NSMutableArray <USReaderChapterListModel *>*chapterListModels = readModel.chapterListModels;
        USReaderChapterListModel *chapterListModel = nil;
        
        NSArray <NSURL *>* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[url URLByDeletingLastPathComponent] includingPropertiesForKeys:nil options:(NSDirectoryEnumerationSkipsHiddenFiles) error:nil];
        
        NSURL *avatarUrl = [contents usfirst:^BOOL(NSURL *obj) {
            return [obj.lastPathComponent containsString:@"avatar.jpg"];
        }];
        NSURL *bookUrl = [contents usfirst:^BOOL(NSURL *obj) {
            return [obj.lastPathComponent hasSuffix:@".txt"] && ![obj.lastPathComponent containsString:[self fullBookSuffix]];
        }];
        UIImage *avatar = [[UIImage alloc] initWithContentsOfFile:[avatarUrl path]];
        NSString *bookContent = [[NSString alloc] initWithContentsOfURL:bookUrl encoding:NSUTF8StringEncoding error:nil];
        NSArray *bookLines = [bookContent componentsSeparatedByString:@"\r\n"];
        NSString *author = bookLines[1];
        NSString *catalog = bookLines[2];
        NSString *bookDesc = bookLines[3];
        // 插入第一章，介绍文案等
        NSInteger firstIndex = chapterListModels.firstObject.idString.integerValue;
        if (firstIndex > 0) {
            firstIndex -= 1;
        }
        USReaderChapterModel *firstChapterModel  = [[USReaderChapterModel alloc] init];
        firstChapterModel.bookID = bookName;
        firstChapterModel.idString = [NSNumber numberWithInteger:firstIndex];
        firstChapterModel.name = bookName;
        firstChapterModel.content = bookDesc;
        firstChapterModel.previousChapterID = nil;
        firstChapterModel.nextChapterID = chapterListModels.firstObject.idString;
        firstChapterModel.avatar = avatar;
        firstChapterModel.catalog = catalog;
        firstChapterModel.bookDesc = bookDesc;
        firstChapterModel.author = author;
        [firstChapterModel save];
        
        chapterListModel = [self GetChapterListModel:firstChapterModel];
        [chapterListModels insertObject:chapterListModel atIndex:0];
        readModel.chapterListModels = chapterListModels;
        
        [readModel.recordModel modify:chapterListModel.idString toPage:0 isSave:YES];
        
        // 遍历所有chapterModel
        for (USReaderChapterListModel *chapterListModel in chapterListModels) {
            [self parser:readModel chapterId:chapterListModel.idString isUpdateFont:YES];
        }
                
        [self parserChapter:firstChapterModel readModel:readModel chapterId:chapterListModel.idString isUpdateFont:YES];

        [readModel save];
        
        return readModel;
    } else {
        return [USReaderModel model:bookId];
    }
}

/// 解析整本小说
///
/// - Parameters:
///   - readModel: readModel
///   - content: 小说内容
+ (void)parse:(USReaderModel *)readModel content:(NSString *)content {
//    NSString *bookContent = [self removeChapterCharacter:content];
    NSMutableArray <USReaderChapterListModel *> *chapterListModels = [NSMutableArray array];
    NSMutableDictionary <NSString *, USValueDict*>*ranges = [NSMutableDictionary dictionary];
    NSString *parten = [NSString stringWithFormat:@"%@第[0-9一二三四五六七八九十百千]*[章回].*", [NSString chapterPrefix]];
    NSString *cont = [USReaderParser contentTypesetting:content];
    NSArray <NSTextCheckingResult *>*results = [cont matches:parten];
    
    if (results.count > 0) {
        NSInteger count = results.count;
        NSRange lastRange;
        BOOL isHavePreface = YES;
        
        for (NSInteger index = 0; index < count; index++) {
            // 章节数量分析:
            // count + 1  = 匹配到的章节数量 + 最后一个章节
            // 1 + count + 1  = 第一章前面的前言内容 + 匹配到的章节数量 + 最后一个章节
            // DZMLog("章节总数: \(count + 1)  当前正在解析: \(i + 1)")
            NSRange range = NSMakeRange(0, 0);
            NSInteger location = 0;
            if (index < count) {
                range = results[index].range;
                location = range.location;
            }
            USReaderChapterListModel *chapterListModel = [[USReaderChapterListModel alloc] init];
            chapterListModel.bookId = readModel.bookID;
            chapterListModel.idString = [NSNumber numberWithInteger:[NSNumber numberWithBool:isHavePreface].integerValue + index];
            // 优先级
            NSNumber *priority = [NSNumber numberWithInteger:index - [NSNumber numberWithBool:!isHavePreface].integerValue];
            if (index == 0) { // 前言
                chapterListModel.name = @"开始";
                
                ranges[chapterListModel.idString.stringValue] = @{priority.stringValue:[NSValue valueWithRange:NSMakeRange(0, location)]};
                
                NSString *content = [cont substringWithRange:NSMakeRange(0, location)];
                lastRange = range;
                content = [self removeChapterCharacter:content];
                // 没有内容则不需要添加列表
                if (content.isEmpty) {
//                    isHavePreface = NO;
                    continue;
                }
            } else if (index == count) {
                // 章节名
                chapterListModel.name = [[cont substringWithRange:lastRange] replacingCharacters:[NSString chapterPrefix] templateString:@""];
                ranges[chapterListModel.idString.stringValue] = @{priority.stringValue:[NSValue valueWithRange:NSMakeRange(lastRange.location + lastRange.length, cont.length - lastRange.location - lastRange.length)]};
                
            } else {// 中间章节
                chapterListModel.name = [[cont substringWithRange:lastRange] replacingCharacters:[NSString chapterPrefix] templateString:@""];
                ranges[chapterListModel.idString.stringValue] = @{priority.stringValue:[NSValue valueWithRange:NSMakeRange(lastRange.location + lastRange.length, location - lastRange.location - lastRange.length)]};
            }
            lastRange = range;
            
            [chapterListModels addObject:chapterListModel];
        }
    } else {
        USReaderChapterListModel *chapterListModel = [[USReaderChapterListModel alloc] init];
        chapterListModel.name = @"开始";
        chapterListModel.bookId = readModel.bookID;
        chapterListModel.idString = [NSNumber numberWithInt:1];
        NSNumber *priority = @(0);
        
        ranges[chapterListModel.idString.stringValue] = @{priority.stringValue:[NSValue valueWithRange:NSMakeRange(0, cont.length)]};
        
        [chapterListModels addObject:chapterListModel];
    }
    readModel.fullText = cont;
    
    readModel.chapterListModels = chapterListModels;
    
    readModel.ranges = ranges;
}
  
/// 获取单个指定章节
+ (USReaderChapterModel *)parser:(USReaderModel *)readModel chapterId:(NSNumber *)chapterId isUpdateFont:(BOOL)isUpdateFont {
    // 获得[章节优先级:章节内容Range]
    USReaderRange * readerRange = readModel.ranges[chapterId.stringValue];
    if (readerRange != nil) {
        NSInteger priority = readerRange.allKeys.firstObject.integerValue;
        
        NSRange range = [readerRange.allValues.firstObject rangeValue];
        
        USReaderChapterListModel *chapterListModel = readModel.chapterListModels[priority];
        
        BOOL isFirstChapter = priority == 0;
        
        BOOL isLastChapter = priority == (readModel.chapterListModels.count - 1);
        
        NSNumber *previousChapterID = isFirstChapter ? nil:readModel.chapterListModels[priority - 1].idString;
        
        NSNumber *nextChapterID = isLastChapter ? nil:readModel.chapterListModels[priority + 1].idString;
        
        USReaderChapterModel *chapterModel = [[USReaderChapterModel alloc] init];
        chapterModel.bookID = chapterListModel.bookId;
        chapterModel.idString = chapterListModel.idString;
        
        chapterModel.name = chapterListModel.name;
        
        chapterModel.priority = [NSNumber numberWithInteger:priority];
        
        chapterModel.previousChapterID = previousChapterID;
        chapterModel.nextChapterID = nextChapterID;
        
        chapterModel.content = [NSString stringWithFormat:@"@"   "%@", [[readModel.fullText substringWithRange:range] removeSEHeadAndTail]];
        
        if (isUpdateFont) {
            [chapterModel updateFont];
        } else {
            [chapterModel save];
        }
        return chapterModel;
    }
    return nil;
}

/// 获取单个指定章节
+ (USReaderChapterModel *)parserChapter:(USReaderChapterModel *)chapter readModel:(USReaderModel *)readModel chapterId:(NSNumber *)chapterId isUpdateFont:(BOOL)isUpdateFont {
    // 获得[章节优先级:章节内容Range]
    USReaderRange * readerRange = readModel.ranges[chapterId.stringValue];
    if (readerRange != nil) {
        NSInteger priority = readerRange.allKeys.firstObject.integerValue;
        
        NSRange range = [readerRange.allValues.firstObject rangeValue];
        
        USReaderChapterListModel *chapterListModel = readModel.chapterListModels[priority];
        
        BOOL isFirstChapter = priority == 0;
        
        BOOL isLastChapter = priority == (readModel.chapterListModels.count - 1);
        
        NSNumber *previousChapterID = isFirstChapter ? nil:readModel.chapterListModels[priority - 1].idString;
        
        NSNumber *nextChapterID = isLastChapter ? nil:readModel.chapterListModels[priority + 1].idString;
        
        USReaderChapterModel *chapterModel = chapter;
        chapterModel.bookID = chapterListModel.bookId;
        chapterModel.idString = chapterListModel.idString;
        
        chapterModel.name = chapterListModel.name;
        
        chapterModel.priority = [NSNumber numberWithInteger:priority];
        
        chapterModel.previousChapterID = previousChapterID;
        chapterModel.nextChapterID = nextChapterID;
        
        if (!isFirstChapter) {
            chapterModel.content = [NSString stringWithFormat:@"@"   "%@", [[readModel.fullText substringWithRange:range] removeSEHeadAndTail]];
        }
        
        if (isUpdateFont) {
            [chapterModel updateFont];
        } else {
            [chapterModel save];
        }
        return chapterModel;
    }
    return nil;
}

+ (BOOL)isExistFullBook:(NSURL *)url {
    NSArray <NSURL *>* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:(NSDirectoryEnumerationSkipsHiddenFiles) error:nil];
    NSURL *fullBookUrl = [contents usfirst:^BOOL(NSURL *obj) {
        return [obj.lastPathComponent hasSuffix:@".txt"] && [obj.lastPathComponent containsString:[self fullBookSuffix]];
    }];
    return fullBookUrl ? YES:NO;
}

+ (NSString *)fullBookSuffix {
    return @"_全本阅读";
}

+ (NSString *)removeChapterCharacter:(NSString *)content {
    NSString *cont = [content stringByReplacingOccurrencesOfString:[NSString chapterPrefix] withString:@"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, content.length)];
    cont = [cont stringByReplacingOccurrencesOfString:@"\n　　" withString:@""];
    return cont;
}

@end
