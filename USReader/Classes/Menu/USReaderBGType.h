//
//  USReaderBGType.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* USReaderBgModeType NS_TYPED_EXTENSIBLE_ENUM;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeWhite;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeNight;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeYellow;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeGreen;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeBlackGreen;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypePink;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeSheepSkin;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeViolet;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeWater;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeWeekGreen;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeWeekPink;
FOUNDATION_EXPORT USReaderBgModeType const USReaderBgModeTypeCoffee;

@interface USReaderBGType : NSObject<NSCoding>

@property (nonatomic, copy, readonly) USReaderBgModeType modelType;

@property (nonatomic, strong, readonly) UIImage *bgImage;

@property (nonatomic, copy, readonly) NSString *bgImageName;

@property (nonatomic, copy, readonly) NSString *bgTitle;

@property (nonatomic, strong, readonly) UIColor *bgTextColor;

- (instancetype)initWithModeType:(USReaderBgModeType)modeType;
 
@end

NS_ASSUME_NONNULL_END
