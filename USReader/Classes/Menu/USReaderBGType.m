//
//  USReaderBGType.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/1.
//

#import "USReaderBGType.h"
#import "USConstants.h"

USReaderBgModeType const USReaderBgModeTypeWhite = @"white";
USReaderBgModeType const USReaderBgModeTypeNight = @"night";
USReaderBgModeType const USReaderBgModeTypeYellow = @"yellow";
USReaderBgModeType const USReaderBgModeTypeGreen = @"green";
USReaderBgModeType const USReaderBgModeTypeBlackGreen = @"blackGreen";
USReaderBgModeType const USReaderBgModeTypePink = @"pink";
USReaderBgModeType const USReaderBgModeTypeSheepSkin = @"sheepskin";
USReaderBgModeType const USReaderBgModeTypeViolet = @"violet";
USReaderBgModeType const USReaderBgModeTypeWater = @"water";
USReaderBgModeType const USReaderBgModeTypeWeekGreen = @"weekGreen";
USReaderBgModeType const USReaderBgModeTypeWeekPink = @"weekPink";
USReaderBgModeType const USReaderBgModeTypeCoffee = @"coffee";

@interface USReaderBGType ()

@property (nonatomic, copy) USReaderBgModeType modelType;

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, copy) NSString *bgImageName;

@property (nonatomic, copy) NSString *bgTitle;

@property (nonatomic, strong) UIColor *bgTextColor;

@end

@implementation USReaderBGType

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.modelType = [coder decodeObjectForKey:@"modelType"];
        self.bgImage = [coder decodeObjectForKey:@"bgImage"];
        self.bgImageName = [coder decodeObjectForKey:@"bgImageName"];
        self.bgTitle = [coder decodeObjectForKey:@"bgTitle"];
        self.bgTextColor = [coder decodeObjectForKey:@"bgTextColor"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.modelType forKey:@"modelType"];
    [coder encodeObject:self.bgImage forKey:@"bgImage"];
    [coder encodeObject:self.bgImageName forKey:@"bgImageName"];
    [coder encodeObject:self.bgTitle forKey:@"bgTitle"];
    [coder encodeObject:self.bgTextColor forKey:@"bgTextColor"];

}

- (instancetype)initWithModeType:(USReaderBgModeType)modeType {
    self = [super init];
    if (self) {
        _modelType = modeType;
        _bgImage = [USReaderBGType bgImageWithType:modeType];
        _bgImageName = [USReaderBGType bgImageNameWithType:modeType];
        _bgTitle = modeType;
        _bgTextColor = [USReaderBGType bgTextColorWithType:modeType];
    }
    return self;
}

+ (NSString *)bgImageNameWithType:(USReaderBgModeType)type {
    NSString *bgImageName = nil;
    NSString *bgTitle = type;
    bgImageName = [NSString stringWithFormat:@"%@_mode_bg", bgTitle];
    return bgImageName;
}

+ (UIImage *)bgImageWithType:(USReaderBgModeType)type {
    NSString *bgImageName = [USReaderBGType bgImageNameWithType:type];
    return USAssetBgImage(bgImageName, nil);
}

+ (UIColor *)bgTextColorWithType:(USReaderBgModeType)type {
    UIColor *bgTextColor = [UIColor blackColor];
    if (type == USReaderBgModeTypeWhite) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeNight) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeYellow) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeGreen) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeBlackGreen) {
        bgTextColor = [UIColor whiteColor];
    } else if (type == USReaderBgModeTypePink) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeSheepSkin) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeViolet) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeWater) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeWeekGreen) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeWeekPink) {
        bgTextColor = [UIColor blackColor];
    } else if (type == USReaderBgModeTypeCoffee) {
        bgTextColor = [UIColor whiteColor];
    }
    return bgTextColor;
}


@end
