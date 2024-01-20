//
//  USReaderMarkModel.h
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USReaderMarkModel : NSObject

/// 小说ID
@property (nonatomic, strong) NSString *bookID;
/// 章节ID
@property (nonatomic, strong) NSNumber *chapterID;
/// 章节名称
@property (nonatomic, strong) NSString *name;
/// 内容
@property (nonatomic, strong) NSString *content;
/// 时间戳
@property (nonatomic, strong) NSNumber *time;
/// 位置
@property (nonatomic, strong) NSNumber *location;

@end

NS_ASSUME_NONNULL_END
