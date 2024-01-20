//
//  USReaderModel.h
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import <Foundation/Foundation.h>
#import "USReaderRecordModel.h"
#import "USReaderMarkModel.h"
#import "USReaderChapterListModel.h"

typedef enum : NSUInteger {
    USBookSourceTypeNetwork,
    USBookSourceTypeLocal,
} USBookSourceType;

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary<NSString *, NSValue *> USReaderRange;

@interface USReaderModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, assign) USBookSourceType bookSourceType;
@property (nonatomic, strong) USReaderRecordModel *recordModel;
@property (nonatomic, strong) NSMutableArray <USReaderMarkModel *>*markModels;
@property (nonatomic, strong) NSMutableArray <USReaderChapterListModel *>*chapterListModels;
@property (nonatomic, strong) NSMutableArray <USReaderChapterListModel *>*showChapterListModels;

@property (nonatomic, copy) NSString *fullText;
@property (nonatomic, strong) NSMutableDictionary <NSString *,USReaderRange *>*ranges;

@property (nonatomic, strong, readonly) UIImage *avatar;

/// 是否存在阅读对象
+ (BOOL)isExist:(NSString *)bookID;
/// 获取阅读对象,如果则创建对象返回
+ (USReaderModel *)model:(NSString *)bookId;
/// 保存
- (void)save;

/// 移除当前书签
- (BOOL)removeMark:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
