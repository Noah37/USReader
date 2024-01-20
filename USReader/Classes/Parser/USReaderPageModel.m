//
//  USReaderPageModel.m
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import "USReaderPageModel.h"

@interface USReaderPageModel ()<NSCoding>

/// 当前内容总高(cell 高度)
@property (nonatomic, assign) CGFloat cellHeight;
/// 书籍首页
@property (nonatomic, assign) BOOL isHomePage;
/// 获取显示内容(考虑可能会变换字体颜色的情况)
@property (nonatomic, strong) NSAttributedString *showContent;


@end

@implementation USReaderPageModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.headTypeHeight = 0;
        self.contentSize = CGSizeZero;
        if (dict != nil) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _content = [coder decodeObjectForKey:@"content"];
        _range = [[coder decodeObjectForKey:@"range"] rangeValue];
        _page = [coder decodeObjectForKey:@"page"];
        _headTypeHeight = [coder decodeDoubleForKey:@"headTypeHeight"];
        _headTypeIndex = [coder decodeObjectForKey:@"headTypeIndex"];
        _contentSize = [[coder decodeObjectForKey:@"contentSize"] CGSizeValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeObject:[NSValue valueWithRange:self.range] forKey:@"range"];
    [coder encodeObject:self.page forKey:@"page"];
    [coder encodeDouble:self.headTypeHeight forKey:@"headTypeHeight"];
    [coder encodeObject:self.headTypeIndex forKey:@"headTypeIndex"];
    [coder encodeObject:[NSValue valueWithCGSize:self.contentSize] forKey:@"contentSize"];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (USPageHeadType)headType {
    return self.headTypeIndex.integerValue;
}

- (CGFloat)cellHeight {
    return self.contentSize.height + self.headTypeHeight;
}

- (BOOL)isHomePage {
    return self.range.location == -1;
}

/// 获取显示内容(考虑可能会变换字体颜色的情况)
- (NSAttributedString *)showContent {
//    UIColor *textColor = [UIColor blackColor];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithAttributedString:self.content];
//    [content addAttributes:@{NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, self.content.length)];
    return content;
}

@end


