//
//  USReaderChapterListModel.m
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import "USReaderChapterListModel.h"
#import "NSString+Reader.h"

@implementation USReaderChapterListModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.idString = [coder decodeObjectForKey:@"idString"];
        self.bookId = [coder decodeObjectForKey:@"bookId"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.idString forKey:@"idString"];
    [coder encodeObject:self.bookId forKey:@"bookId"];

}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (dict != nil) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSString *)showName {
    NSString *lastName = [self.name componentsSeparatedByString:@"-"].lastObject;
    return [lastName componentsSeparatedByString:@"."].firstObject;
}

@end
