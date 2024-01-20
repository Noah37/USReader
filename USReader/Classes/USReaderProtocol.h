//
//  USReaderProtocol.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/4.
//

#import <Foundation/Foundation.h>

/**
 * 阅读协议，适用所有翻页协议类型。实现一种新的翻页方式时，需要遵循该协议
 */

NS_ASSUME_NONNULL_BEGIN

@class USPageViewController, USReaderModel, USReaderRecordModel;
@protocol USReaderProtocol <NSObject>

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel;

/// 获取当前的阅读记录
- (USReaderRecordModel *)recordModel;

/// 翻页
- (USReaderRecordModel *)nextPage;
- (USReaderRecordModel *)lastPage;
- (void)toPage:(NSInteger)page;

/// 翻章节
- (USReaderRecordModel *)nextChapter;
- (USReaderRecordModel *)lastChapter;
- (void)toChapter:(NSInteger)chapter; /// 默认翻到该章节第一页
- (void)toChapter:(NSInteger)chapter page:(NSInteger)page; /// 指定章节与页码

/// 刷新页面，可能涉及字体变更，间距变化等，需要重新计算page
- (void)reloadData;

/// 修改阅读视图背景图片
- (void)changeToBgImage:(UIImage *)bgImage;

@end

NS_ASSUME_NONNULL_END
