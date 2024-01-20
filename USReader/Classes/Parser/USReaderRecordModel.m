//
//  USReaderRecordModel.m
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import "USReaderRecordModel.h"
#import "USKeyedArchiver.h"

@interface USReaderRecordModel ()<NSCoding, NSCopying>

@end

@implementation USReaderRecordModel

- (id)copyWithZone:(nullable NSZone *)zone {
    USReaderRecordModel *recordModel = [[USReaderRecordModel allocWithZone:zone] init];
    recordModel.bookID = self.bookID;
    recordModel.chapterModel = self.chapterModel;
    recordModel.page = self.page;
    return recordModel;
}

- (NSAttributedString *)contentAttributedString {
    return [self.chapterModel contentAttributedString:self.page.integerValue];
}

- (BOOL)isExistPage:(NSInteger)page {
    if (page >= 0 && page < self.chapterModel.pageCount.integerValue) {
        return YES;
    }
    return NO;
}

- (BOOL)isFirstChapter {
    return self.chapterModel.isFirstChapter;
}

- (BOOL)isFirstPage {
    return self.page.integerValue == 0;
}

- (BOOL)isLastChapter {
    return self.chapterModel.isLastChapter;
}

- (BOOL)isLastPage {
    return self.page.integerValue == self.chapterModel.pageCount.integerValue - 1;
}

- (void)previousPage {
    self.page = [NSNumber numberWithInteger:MAX(self.page.integerValue - 1, 0)];
}

- (NSURL *)chapterUrl {
    return [self.chapterModel chapterAudioURL];
}

- (void)appointPage:(NSInteger)page {
    self.page = [NSNumber numberWithInteger:MIN(self.chapterModel.pageCount.integerValue, MAX(page, 0))];
}

- (void)nextPage {
    self.page = [NSNumber numberWithInteger:MIN(self.page.integerValue + 1, self.chapterModel.pageModels.count - 1)];
}

- (void)firstPage {
    self.page = @(0);
}

- (USReaderChapterModel *)firstChapter {
    NSNumber *previousChapterID = [NSNumber numberWithInt:2];
    USReaderChapterModel *preViousChapterModel = [USReaderChapterModel model:self.bookID chapterId:previousChapterID isUpdateFont:NO];
    while (preViousChapterModel.previousChapterID) {
        previousChapterID = preViousChapterModel.previousChapterID;
        preViousChapterModel = [USReaderChapterModel model:self.bookID chapterId:previousChapterID isUpdateFont:NO];
    }
    return preViousChapterModel;
}

- (void)lastPage {
    self.page = [NSNumber numberWithInteger:self.chapterModel.pageModels.count - 1];
}

- (NSNumber *)showPageNum {
    return [NSNumber numberWithInteger:self.page.integerValue + 1] ;
}

- (USReaderPageModel *)pageModel {
    if (self.page.integerValue < self.chapterModel.pageCount.integerValue) {
        return self.chapterModel.pageModels[self.page.integerValue];
    }
    return self.chapterModel.pageModels.firstObject;
}

- (void)reload {
    [self updateFont:YES];
}

/// 更新字体
- (void)updateFont:(BOOL)isSave {
    if (self.chapterModel != nil) {
        [_chapterModel updateFont];
#warning check
        self.page = [self.chapterModel page:self.locationFirst.integerValue];
        if (isSave) {
            [self save];
        }
    }
}

/// 保存记录
- (void)save {
    [USKeyedArchiver archiver:_bookID fileName:@"US_READER_RECORD" object:self];
}

/// 修改阅读记录为指定章节位置
- (void)modify:(USReaderChapterModel *)chapterModel page:(NSInteger)page isSave:(BOOL)isSave {
    self.chapterModel = chapterModel;
    
    self.page = [NSNumber numberWithInteger:page];
    
    if (isSave) {
        [self save];
    }
}

/// 修改阅读记录为指定章节位置
- (void)modify:(NSNumber *)chapterId location:(NSInteger)location isSave:(BOOL)isSave {
    if ([USReaderChapterModel isExist:_bookID chapterID:chapterId]) {
        _chapterModel = [USReaderChapterModel model:_bookID chapterId:chapterId isUpdateFont:YES];
        self.page = [_chapterModel page:location];
        if (isSave) {
            [self save];
        }
    }
}

/// 修改阅读记录为指定章节页码 (toPage == DZM_READ_LAST_PAGE 为当前章节最后一页)
- (void)modify:(NSNumber *)chapterId toPage:(NSInteger)toPage isSave:(BOOL)isSave {
    if ([USReaderChapterModel isExist:_bookID chapterID:chapterId]) {
        self.chapterModel = [USReaderChapterModel model:_bookID chapterId:chapterId isUpdateFont:YES];
        
        if (toPage == -1) {
            [self lastPage];
        } else {
            self.page = @(toPage);
        }
        if (isSave) {
            [self save];
        }
    }
}

/// 是否存在阅读记录
+ (BOOL)isExist:(NSString *)bookID {
    return [USKeyedArchiver isExist:bookID fileName:@"US_READER_RECORD"];
}

/// 获取阅读记录对象,如果则创建对象返回
+ (USReaderRecordModel *)model:(NSString *)bookId {
    USReaderRecordModel *recordModel = nil;
    if ([self isExist:bookId]) {
        recordModel = [USKeyedArchiver unarchiver:bookId fileName:@"US_READER_RECORD"];
        [recordModel.chapterModel updateFont];
    } else {
        recordModel = [[USReaderRecordModel alloc] init];
        recordModel.bookID = bookId;
    }
    return recordModel;
}

/// 拷贝阅读记录
- (USReaderRecordModel *)copyModel {
    USReaderRecordModel *recordModel = [[USReaderRecordModel alloc] init];
    recordModel.bookID = self.bookID;
    recordModel.chapterModel = self.chapterModel;
    recordModel.page = self.page;
    return recordModel;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.bookID = [coder decodeObjectForKey:@"bookID"];
        self.chapterModel = [coder decodeObjectForKey:@"chapterModel"];
        self.page = [coder decodeObjectForKey:@"page"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.bookID forKey:@"bookID"];
    [coder encodeObject:self.chapterModel forKey:@"chapterModel"];
    [coder encodeObject:self.page forKey:@"page"];

}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (dict != nil) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
