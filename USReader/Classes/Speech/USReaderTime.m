//
//  USReaderTime.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/14.
//

#import "USReaderTime.h"

@interface USReaderTime ()

@property (nonatomic, strong) NSNumber *value;

@end

@implementation USReaderTime

+ (USReaderTime *_Nullable)timeWithNumber:(nullable NSNumber *)aNumber {
    return [[self alloc] initWithNumber:aNumber];
}

+ (USReaderTime *_Nullable)timeWithInt:(int)aInt {
    return [[self alloc] initWithInt:aInt];
}


- (instancetype _Nullable )initWithNumber:(nullable NSNumber *)aNumber {
    self = [super init];
    if (self) {
        self.value = aNumber;
    }
    return self;
}

- (instancetype _Nullable )initWithInt:(int)aInt {
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithInt:aInt];
    }
    return self;
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%.2d", self.value.intValue];
}

- (NSString *)minuteStringValue {
    
    return [NSString stringWithFormat:@"%.2d:%.2d", self.value.intValue / 60, self.value.intValue % 60];
}

- (int)intValue {
    return self.value.intValue;
}


@end
