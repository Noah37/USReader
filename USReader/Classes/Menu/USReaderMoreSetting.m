//
//  USReaderMoreSetting.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/5.
//

#import "USReaderMoreSetting.h"

@interface USReaderMoreSetting ()

@property (nonatomic, assign) USReaderMoreSettingType type;

@property (nonatomic, assign) USReaderMoreSettingCellType cellType;

@property (nonatomic, strong) NSArray *segmentTitles;

@property (nonatomic, copy) NSString *title; // 左侧上面
@property (nonatomic, copy) NSString *subTitle; // 左侧下面

@end

@implementation USReaderMoreSetting

- (instancetype)initWithType:(USReaderMoreSettingType)type
                    cellType:(USReaderMoreSettingCellType)cellType
               segmentTitles:(NSArray *)segmentTitles
                       title:(NSString *)title
                    subTitle:(NSString *)subTitle
                 detailTitle:(NSString *)detailTitle
                       value:(NSNumber *)value {
    self = [super init];
    if (self) {
        self.type = type;
        self.cellType = cellType;
        self.segmentTitles = segmentTitles;
        self.title = title;
        self.subTitle = subTitle;
        self.detailTitle = detailTitle;
        self.value = value;
    }
    return self;
}

+ (NSArray <USReaderMoreSetting *>*)allSettings {
    NSMutableArray *array = [NSMutableArray array];
    USReaderMoreSetting *chinese = [[USReaderMoreSetting alloc] initWithType:(USReaderMoreSettingTypeChinese) cellType:(USReaderMoreSettingCellTypeSegment) segmentTitles:@[@"简体", @"繁体"] title:@"简繁体" subTitle:nil detailTitle:nil value:[NSNumber numberWithInt:0]];
    USReaderMoreSetting *idltime = [[USReaderMoreSetting alloc] initWithType:(USReaderMoreSettingTypeIdltime) cellType:(USReaderMoreSettingCellTypeTable) segmentTitles:@[] title:@"息屏时间" subTitle:@"自动阅读，边听边看状态下不会锁屏" detailTitle:@"跟随系统" value:[NSNumber numberWithInt:0]];
    USReaderMoreSetting *statusBar = [[USReaderMoreSetting alloc] initWithType:(USReaderMoreSettingTypeStatusBar) cellType:(USReaderMoreSettingCellTypeSwitch) segmentTitles:@[] title:@"手机状态栏常驻显示" subTitle:@"显示后台程序、通知、信号等" detailTitle:@"" value:[NSNumber numberWithInt:0]];
    USReaderMoreSetting *swipeOut = [[USReaderMoreSetting alloc] initWithType:(USReaderMoreSettingTypeSwipeout) cellType:(USReaderMoreSettingCellTypeSwitch) segmentTitles:@[] title:@"侧滑退出阅读器" subTitle:@"" detailTitle:@"" value:[NSNumber numberWithInt:0]];
    USReaderMoreSetting *progress = [[USReaderMoreSetting alloc] initWithType:(USReaderMoreSettingTypeProgress) cellType:(USReaderMoreSettingCellTypeTable) segmentTitles:@[] title:@"阅读进度设置" subTitle:@"" detailTitle:@"显示页码" value:[NSNumber numberWithInt:0]];


    [array addObject:chinese];
    [array addObject:idltime];
    [array addObject:statusBar];
    [array addObject:swipeOut];
    [array addObject:progress];

    return [array copy];
}

@end
