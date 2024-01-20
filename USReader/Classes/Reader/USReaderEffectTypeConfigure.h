//
//  USReaderEffectTypeConfigure.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    USEffectTypeSimulation, /// 仿真
    USEffectTypeCover, /// 覆盖
    USEffectTypeTranslation, /// 平移
    USEffectTypeScroll, /// 滚动
    USEffectTypeNone    ///
} USEffectType;

NS_ASSUME_NONNULL_BEGIN

@interface USReaderEffectTypeConfigure : NSObject

@property (nonatomic, assign) USEffectType effectType;

@property (nonatomic, strong, readonly) NSNumber *effectTypeIndex;

/// 用来展示的名字
@property (nonatomic, strong) NSString *effectString;


- (instancetype)initWithEffectType:(USEffectType)effectType;


+ (NSDictionary<NSNumber*, USReaderEffectTypeConfigure *> *)effectTypes;

@end

NS_ASSUME_NONNULL_END
