//
//  USReaderEffectTypeConfigure.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderEffectTypeConfigure.h"

@interface USReaderEffectTypeConfigure ()<NSCoding>

@property (nonatomic, strong) NSNumber *effectTypeIndex;

@end

@implementation USReaderEffectTypeConfigure

- (instancetype)initWithEffectType:(USEffectType)effectType {
    self = [super init];
    if (self) {
        self.effectType = effectType;
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    [coder encodeObject:self.effectTypeIndex forKey:@"effectTypeIndex"];
    [coder encodeObject:self.effectString forKey:@"effectString"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder { 
    self = [super init];
    if (self) {
        self.effectTypeIndex = [coder decodeObjectForKey:@"effectTypeIndex"];
        self.effectString = [coder decodeObjectForKey:@"effectString"];
        self.effectType = [self.effectTypeIndex integerValue];
    }
    return self;
}

- (void)setEffectType:(USEffectType)effectType {
    _effectType = effectType;
    _effectTypeIndex = [NSNumber numberWithInteger:effectType];
    _effectString = [self getEffectStringWithType:effectType];
}

+ (NSDictionary<NSNumber*, USReaderEffectTypeConfigure *> *)effectTypes {
    USReaderEffectTypeConfigure *simulation = [[USReaderEffectTypeConfigure alloc] initWithEffectType:USEffectTypeSimulation];
    USReaderEffectTypeConfigure *translation = [[USReaderEffectTypeConfigure alloc] initWithEffectType:USEffectTypeTranslation];
    USReaderEffectTypeConfigure *cover = [[USReaderEffectTypeConfigure alloc] initWithEffectType:USEffectTypeCover];
    USReaderEffectTypeConfigure *scroll = [[USReaderEffectTypeConfigure alloc] initWithEffectType:USEffectTypeScroll];
    USReaderEffectTypeConfigure *none = [[USReaderEffectTypeConfigure alloc] initWithEffectType:USEffectTypeNone];
    return @{
        @(USEffectTypeSimulation):simulation,
        @(USEffectTypeTranslation):translation,
        @(USEffectTypeCover):cover,
        @(USEffectTypeScroll):scroll,
        @(USEffectTypeNone):none,
    };
}

- (NSString *)getEffectStringWithType:(USEffectType)effectType {
    NSString *string;
    switch (effectType) {
        case USEffectTypeSimulation:
            string = @"仿真阅读";
            break;
        case USEffectTypeTranslation:
            string = @"左右平移";
            break;
        case USEffectTypeCover:
            string = @"左右覆盖";
            break;
        case USEffectTypeScroll:
            string = @"上下滚屏";
            break;
        case USEffectTypeNone:
            string = @"无";
            break;
        default:
            break;
    }
    return string;
}

@end
