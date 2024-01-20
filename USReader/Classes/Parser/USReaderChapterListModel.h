//
//  USReaderChapterListModel.h
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USReaderChapterListModel : NSObject<NSCoding>

/// 章节ID
@property (nonatomic, strong) NSNumber *idString;

/// 小说ID
@property (nonatomic, strong) NSString *bookId;

/// 章节名称
@property (nonatomic, strong) NSString *name;

/// 用来展示的章节名字，去掉收尾数字与扩展名
- (NSString *)showName;


@end

NS_ASSUME_NONNULL_END
