//
//  USReaderModel.m
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import "USReaderModel.h"
#import "USKeyedArchiver.h"
#import "NSArray+USReader.h"

@implementation USReaderModel

/// 是否存在阅读对象
+ (BOOL)isExist:(NSString *)bookID {
    return [USKeyedArchiver isExist:bookID fileName:@"US_READER_OBJECT"];
}

/// 获取阅读对象,如果则创建对象返回
+ (USReaderModel *)model:(NSString *)bookId {
    USReaderModel *readModel;
    if ([USReaderModel isExist:bookId]) {
        readModel = [USKeyedArchiver unarchiver:bookId fileName:@"US_READER_OBJECT"];
    } else {
        readModel = [[USReaderModel alloc] init];
        readModel.bookID = bookId;
    }
    readModel.recordModel = [USReaderRecordModel model:bookId];
    return readModel;
}

- (NSMutableArray<USReaderChapterListModel *> *)showChapterListModels {
    return [self.chapterListModels usfilter:^BOOL(USReaderChapterListModel *chapterListModel, NSInteger index) {
        return index > 0;
    }];
}

/// 保存
- (void)save {
    [self.recordModel save];
    
    [USKeyedArchiver archiver:_bookID fileName:@"US_READER_OBJECT" object:self];
}

/// 移除当前书签
- (BOOL)removeMark:(NSInteger)index {
    [self.markModels removeObjectAtIndex:index];
    [self save];
    return YES;
}

- (UIImage *)avatar {
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.bookID = [coder decodeObjectForKey:@"bookID"];
        self.bookName = [coder decodeObjectForKey:@"bookName"];
        self.recordModel = [coder decodeObjectForKey:@"recordModel"];
        self.chapterListModels = [coder decodeObjectForKey:@"chapterListModels"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.bookID forKey:@"bookID"];
    [coder encodeObject:self.bookName forKey:@"bookName"];
    [coder encodeObject:self.recordModel forKey:@"recordModel"];
    [coder encodeObject:self.chapterListModels forKey:@"chapterListModels"];

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
