//
//  USReaderPageModel.h
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    USPageHeadTypeChapterName, /// 章节名
    USPageHeadTypeParagraph, /// 段落
    USPageHeadTypeLine, /// 行内容
} USPageHeadType;

NS_ASSUME_NONNULL_BEGIN

@interface USReaderPageModel : NSObject

@property (nonatomic, strong) NSAttributedString *content;

/// 当前内容Size (目前主要是(滚动模式 || 长按模式)使用)
@property (nonatomic, assign) CGSize contentSize;

/// 根据开头类型返回开头高度 (目前主要是滚动模式使用)
@property (nonatomic, assign) CGFloat headTypeHeight;
/// 当前内容头部类型 (目前主要是滚动模式使用)
@property (nonatomic, assign) USPageHeadType headType;

/// 当前内容头部类型 (目前主要是滚动模式使用)
@property (nonatomic, strong) NSNumber *headTypeIndex;

@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSNumber *page;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (USPageHeadType)headType;
- (CGFloat)cellHeight;
- (BOOL)isHomePage;
- (NSAttributedString *)showContent;

@end

NS_ASSUME_NONNULL_END
