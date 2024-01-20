//
//  USReaderRecordModel.h
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import <Foundation/Foundation.h>
#import "USReaderChapterModel.h"
#import "USReaderPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderRecordModel : NSObject

@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, strong) USReaderChapterModel *chapterModel;

@property (nonatomic, strong) NSNumber *page;

@property (nonatomic, strong, readonly) USReaderPageModel *pageModel;

@property (nonatomic, strong) NSNumber *locationFirst;
@property (nonatomic, strong) NSNumber *locationLast;
@property (nonatomic, assign) BOOL isLastChapter;
@property (nonatomic, assign) BOOL isFirstChapter;
@property (nonatomic, assign) BOOL isFirstPage;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong, readonly) NSAttributedString *contentAttributedString;

/// 是否存在阅读记录
+ (BOOL)isExist:(NSString *)bookID;

/// 获取阅读记录对象,如果则创建对象返回
+ (USReaderRecordModel *)model:(NSString *)bookId;

- (NSURL *)chapterUrl;

/// 修改阅读记录为指定章节位置
- (void)modify:(USReaderChapterModel *)chapterModel page:(NSInteger)page isSave:(BOOL)isSave;
/// 修改阅读记录为指定章节位置
- (void)modify:(NSNumber *)chapterId location:(NSInteger)location isSave:(BOOL)isSave;
/// 修改阅读记录为指定章节页码 (toPage == DZM_READ_LAST_PAGE 为当前章节最后一页)
- (void)modify:(NSNumber *)chapterId toPage:(NSInteger)toPage isSave:(BOOL)isSave;
/// 保存记录
- (void)save;
- (void)reload;

- (void)previousPage;
- (void)nextPage;
- (void)appointPage:(NSInteger)page;

- (BOOL)isExistPage:(NSInteger)page;

- (USReaderChapterModel *)firstChapter;

/// 用来展示的页码，从1开始
- (NSNumber *)showPageNum;

@end

NS_ASSUME_NONNULL_END
