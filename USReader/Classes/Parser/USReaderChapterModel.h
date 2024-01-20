//
//  USReaderChapterModel.h
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "USReaderPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderChapterModel : NSObject

/// 小说ID
@property (nonatomic, copy) NSString *bookID;
/// 章节ID
@property (nonatomic, strong) NSNumber *idString;
/// 上一章ID
@property (nonatomic, strong, nullable) NSNumber *previousChapterID;
/// 下一章ID
@property (nonatomic, strong, nullable) NSNumber *nextChapterID;
/// 章节名称
@property (nonatomic, copy) NSString *name;
/// 内容
/// 此处 content 是经过排版好且双空格开头的内容。
/// 如果是网络数据需要确认是否处理好了,也就是在网络章节数据拿到之后, 使用排版接口进行排版并在开头加上双空格。(例如: DZM_READ_PH_SPACE + 排版好的content )
/// 排版内容搜索 contentTypesetting 方法
@property (nonatomic, copy) NSString *content;
/// 优先级 (一般章节段落都带有排序的优先级 从0开始)
@property (nonatomic, strong) NSNumber *priority;
/// 本章有多少页
@property (nonatomic, strong, readonly) NSNumber *pageCount;
/// 分页数据
@property (nonatomic, strong) NSArray <USReaderPageModel *>*pageModels;
/// 小说封面图片
@property (nonatomic, strong) UIImage *avatar;
/// 小说描述
@property (nonatomic, strong) NSString *bookDesc;
/// 小说作者
@property (nonatomic, strong) NSString *author;
/// 小说分类
@property (nonatomic, strong) NSString *catalog;

- (BOOL)isFirstChapter;
- (BOOL)isLastChapter;

- (NSURL *)chapterAudioURL;

- (NSString *)fullName;
/// 用来展示的章节名字，去掉收尾数字与扩展名
- (NSString *)showName;
- (NSAttributedString *)fullContent;

- (CGFloat)pageTotalHeight;

/// 更新字体
- (void)updateFont;

- (void)save;

/// 是否存在章节内容
+ (BOOL)isExist:(NSString *)bookID chapterID:(NSNumber *)chapterId;

/// 获取章节对象,如果则创建对象返回
+ (USReaderChapterModel *)model:(NSString *)bookID chapterId:(NSNumber *)chapterId isUpdateFont:(BOOL)isUpdateFont;

/// 获取存在指定坐标的页码
- (NSNumber *)page:(NSInteger)location;

/// 获取指定页码富文本
- (NSAttributedString *)contentAttributedString:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
