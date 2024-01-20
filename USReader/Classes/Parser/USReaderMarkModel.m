//
//  USReaderMarkModel.m
//  USReader
//
//  Created by yung on 2023/11/30.
//

#import "USReaderMarkModel.h"

@interface USReaderMarkModel () <NSCoding>

@end

@implementation USReaderMarkModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.bookID = [coder decodeObjectForKey:@"bookID"];
        self.chapterID = [coder decodeObjectForKey:@"chapterID"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.content = [coder decodeObjectForKey:@"content"];
        self.time = [coder decodeObjectForKey:@"time"];
        self.location = [coder decodeObjectForKey:@"location"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.bookID forKey:@"bookID"];
    [coder encodeObject:self.chapterID forKey:@"chapterID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeObject:self.time forKey:@"time"];
    [coder encodeObject:self.location forKey:@"location"];

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

@end
