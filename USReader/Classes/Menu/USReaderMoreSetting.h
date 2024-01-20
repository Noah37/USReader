//
//  USReaderMoreSetting.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/5.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    USReaderMoreSettingTypeChinese,  /// 简繁体
    USReaderMoreSettingTypeIdltime,  /// 息屏时间
    USReaderMoreSettingTypeStatusBar,/// 手机状态栏常驻显示
    USReaderMoreSettingTypeSwipeout, /// 侧滑退出阅读器
    USReaderMoreSettingTypeProgress, /// 阅读进度设置
} USReaderMoreSettingType;

/// cell的展示样式
typedef enum : NSUInteger {
    USReaderMoreSettingCellTypeTable,  /// 下一级为tableview，展示箭头
    USReaderMoreSettingCellTypeSwitch, /// 右边为开关样式
    USReaderMoreSettingCellTypeSegment,/// 右边展示为分栏
} USReaderMoreSettingCellType;

NS_ASSUME_NONNULL_BEGIN

@interface USReaderMoreSetting : NSObject

@property (nonatomic, assign, readonly) USReaderMoreSettingType type;

@property (nonatomic, assign, readonly) USReaderMoreSettingCellType cellType;

@property (nonatomic, strong, readonly) NSArray *segmentTitles;
///开关的值或者分栏的值
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, copy, readonly) NSString *title; // 左侧上面
@property (nonatomic, copy, readonly) NSString *subTitle; // 左侧下面
@property (nonatomic, copy) NSString *detailTitle; // 右侧


- (instancetype)initWithType:(USReaderMoreSettingType)type
                    cellType:(USReaderMoreSettingCellType)cellType
               segmentTitles:(NSArray *)segmentTitles
                       title:(NSString *)title
                    subTitle:(NSString *_Nullable)subTitle
                 detailTitle:(NSString *_Nullable)detailTitle
                       value:(NSNumber *_Nullable)value;

+ (NSArray <USReaderMoreSetting *>*)allSettings;

@end

NS_ASSUME_NONNULL_END
