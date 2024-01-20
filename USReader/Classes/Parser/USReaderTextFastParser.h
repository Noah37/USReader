//
//  USReaderTextFastParser.h
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import <Foundation/Foundation.h>
#import "USReaderModel.h"
#import "USReaderChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderTextFastParser : NSObject

/// 异步解析本地链接
///
/// - Parameters:
///   - url: 本地文件地址
///   - completion: 解析完成
+ (void)parser:(NSURL *)url completion:(void(^)(USReaderModel *))completion;

+ (USReaderModel *)parserNovelURL:(NSURL *)url;

/// 解析本地链接
///
/// - Parameter url: 本地文件地址
/// - Returns: 阅读对象
+ (USReaderModel *)parser:(NSURL *)url;

/// 解析整本小说
///
/// - Parameters:
///   - readModel: readModel
///   - content: 小说内容
+ (void)parse:(USReaderModel *)readModel content:(NSString *)content;

/// 获取单个指定章节
+ (USReaderChapterModel *)parser:(USReaderModel *)readModel chapterId:(NSNumber *)chapterId isUpdateFont:(BOOL)isUpdateFont;

@end

NS_ASSUME_NONNULL_END
