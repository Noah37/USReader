//
//  USReaderParser.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <Foundation/Foundation.h>
#import "USReaderPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderParser : NSObject

/// 内容分页
///
/// - Parameters:
///   - attrString: 内容
///   - rect: 显示范围
///   - isFirstChapter: 是否为本文章第一个展示章节,如果是则加入书籍首页。(小技巧:如果不需要书籍首页,可不用传,默认就是不带书籍首页)
/// - Returns: 内容分页列表
+ (NSArray <USReaderPageModel *>*)pageing:(NSAttributedString *)attrString rect:(CGRect)rect isFirstChapter:(BOOL)isFirstChapter;

/// 内容排版整理
///
/// - Parameter content: 内容
/// - Returns: 整理好的内容
+ (NSString *)contentTypesetting:(NSString *)content;

/// 解码URL
///
/// - Parameter url: 文件路径
/// - Returns: 内容
+ (NSString *)encode:(NSURL *)url;

/// 解析URL
///
/// - Parameters:
///   - url: 文件路径
///   - encoding: 进制编码
/// - Returns: 内容
+ (NSString *)encode:(NSURL *)url encoding:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
