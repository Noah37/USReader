//
//  USReaderChapterModel.m
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import "USReaderChapterModel.h"
#import "USConstants.h"
#import "USReaderConfigure.h"
#import "USReaderParser.h"
#import "NSString+Reader.h"
#import "USKeyedArchiver.h"

@interface USReaderChapterModel ()<NSCoding>

/// 完整富文本内容
@property (nonatomic, strong) NSAttributedString *fullContent;

@property (nonatomic, strong) NSNumber *pageCount;
/// 内容属性变化记录(我这里就只判断内容了字体属性变化了，标题也就跟着变化或者保存变化都无所谓了。如果有需求可以在加上比较标题属性变化)
@property (nonatomic, strong) NSMutableDictionary <NSAttributedStringKey, id>*attributes;

@end

@implementation USReaderChapterModel

- (CGFloat)pageTotalHeight {
    CGFloat pageTotalHeight = 0;
    for (USReaderPageModel *pageModel in self.pageModels) {
        pageTotalHeight += pageModel.contentSize.height + pageModel.headTypeHeight;
    }
    return pageTotalHeight;
}

/// 更新字体
- (void)updateFont {
    NSDictionary *tempAttributes = [[USReaderConfigure shared] attributes:NO isPaging:YES];
    if (self.attributes != tempAttributes) {
        self.attributes = [tempAttributes mutableCopy];
        self.fullContent = [self fullContentAttrString];
        self.pageModels = [USReaderParser pageing:_fullContent rect:US_READERRECT isFirstChapter:self.isFirstChapter];
        self.pageCount = [NSNumber numberWithInteger:_pageModels.count];
        [self save];
    }
}

/// 完整内容排版
- (NSMutableAttributedString *)fullContentAttrString {
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.showName attributes:[[USReaderConfigure shared]attributes:YES isPaging:NO]];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:[self.content removeSEHeadAndTail] attributes:[[USReaderConfigure shared] attributes:NO isPaging:NO]];
    [titleString appendAttributedString:contentString];
    return titleString;
}

#pragma mark - public
/// 当前章节是否为第一个章节
- (BOOL)isFirstChapter {
    return (self.previousChapterID == nil);
}

/// 当前章节是否为最后一个章节
- (BOOL)isLastChapter {
    return (self.nextChapterID == nil);
}

/// 完整章节名称
- (NSString *)fullName {
    return US_CHAPTER_NAME(self.name);
}

- (NSString *)showName {
    NSString *lastName = [self.name componentsSeparatedByString:@"-"].lastObject;
    return US_CHAPTER_NAME([lastName componentsSeparatedByString:@"."].firstObject);
}

- (NSNumber *)pageCount {
    return [NSNumber numberWithInteger:self.pageModels.count];
}

- (NSURL *)chapterAudioURL {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.bookID ofType:nil];
    NSString *chapterPath = [[path stringByAppendingPathComponent:@"chapters"] stringByAppendingPathComponent:[self.name stringByDeletingPathExtension]];
    NSString *audioPath = [chapterPath stringByAppendingPathExtension:@"mp3"];
    if (audioPath && [[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
        return [NSURL fileURLWithPath:audioPath];
    }
    return nil;
}

#pragma mark - getter
- (NSMutableDictionary *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return _attributes;
}
 
/// 内容属性变化记录(我这里就只判断内容了字体属性变化了，标题也就跟着变化或者保存变化都无所谓了。如果有需求可以在加上比较标题属性变化)
//    private var attributes:[NSAttributedString.Key:Any]! = [:]

    // MARK: 辅助功能

/// 获取指定页码字符串
- (NSString *)contentString:(NSInteger)page {
    return self.pageModels[page].content.string;
}

/// 获取指定页码富文本
- (NSAttributedString *)contentAttributedString:(NSInteger)page {
    return self.pageModels[page].showContent;
}

/// 获取指定页开始坐标
- (NSNumber *)locationFirst:(NSInteger)page {
    return [NSNumber numberWithInteger:self.pageModels[page].range.location];
}

/// 获取指定页码末尾坐标
- (NSNumber *)locationLast:(NSInteger)page {
    NSRange range = self.pageModels[page].range;
    return [NSNumber numberWithInteger:range.location + range.location];
}

/// 获取指定页中间
- (NSNumber *)locationCenter:(NSInteger)page {
    NSRange range = self.pageModels[page].range;
    return [NSNumber numberWithInteger:range.location + (range.location + range.length)/2];
}

/// 获取存在指定坐标的页码
- (NSNumber *)page:(NSInteger)location {
    NSInteger count = self.pageModels.count;
    for (NSInteger index = 0; index < count; index++) {
        NSRange range = self.pageModels[index].range;
        if (location < (range.location + range.length)) {
            return [NSNumber numberWithInteger:index];
        }
    }
    return [NSNumber numberWithInteger:0];
}
  
- (void)save {
    [USKeyedArchiver archiver:self.bookID fileName:self.idString.stringValue object:self];
}

- (void)deleteChapter {
    
}

/// 是否存在章节内容
+ (BOOL)isExist:(NSString *)bookID chapterID:(NSNumber *)chapterId {
    return [USKeyedArchiver isExist:bookID fileName:chapterId.stringValue];
}

// MARK: 构造

/// 获取章节对象,如果则创建对象返回
+ (USReaderChapterModel *)model:(NSString *)bookID chapterId:(NSNumber *)chapterId isUpdateFont:(BOOL)isUpdateFont {
    USReaderChapterModel *chapterModel = [[USReaderChapterModel alloc] init];
    if ([self isExist:bookID chapterID:chapterId]) {
        chapterModel = [USKeyedArchiver unarchiver:bookID fileName:chapterId.stringValue];
        if (isUpdateFont) {
            [chapterModel updateFont];
        }
    } else {
        chapterModel = [[USReaderChapterModel alloc] init];
        chapterModel.bookID = bookID;
        chapterModel.idString = chapterId;
    }
    return chapterModel;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.bookID = [coder decodeObjectForKey:@"bookID"];
        self.idString = [coder decodeObjectForKey:@"idString"];
        self.previousChapterID = [coder decodeObjectForKey:@"previousChapterID"];
        self.nextChapterID = [coder decodeObjectForKey:@"nextChapterID"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.priority = [coder decodeObjectForKey:@"priority"];
        self.content = [coder decodeObjectForKey:@"content"];
        self.fullContent = [coder decodeObjectForKey:@"fullContent"];
        self.pageCount = [coder decodeObjectForKey:@"pageCount"];
        self.pageModels = [coder decodeObjectForKey:@"pageModels"];
        self.attributes = [coder decodeObjectForKey:@"attributes"];
        self.avatar = [coder decodeObjectForKey:@"avatar"];
        self.author = [coder decodeObjectForKey:@"author"];
        self.bookDesc = [coder decodeObjectForKey:@"bookDesc"];
        self.catalog = [coder decodeObjectForKey:@"catalog"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.bookID forKey:@"bookID"];
    [coder encodeObject:self.idString forKey:@"idString"];
    [coder encodeObject:self.previousChapterID forKey:@"previousChapterID"];
    [coder encodeObject:self.nextChapterID forKey:@"nextChapterID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.priority forKey:@"priority"];
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeObject:self.fullContent forKey:@"fullContent"];
    [coder encodeObject:self.pageCount forKey:@"pageCount"];
    [coder encodeObject:self.pageModels forKey:@"pageModels"];
    [coder encodeObject:self.attributes forKey:@"attributes"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.author forKey:@"author"];
    [coder encodeObject:self.bookDesc forKey:@"bookDesc"];
    [coder encodeObject:self.catalog forKey:@"catalog"];

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
