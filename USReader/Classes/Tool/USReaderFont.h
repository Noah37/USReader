//
//  USReaderFont.h
//  Masonry
//
//  Created by nongyun.cao on 2024/1/5.
//

#import <Foundation/Foundation.h>
#import "USReaderFontFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderFont : NSObject

+ (NSArray <USReaderFontFile *>*)loadAllFontFamily;

+ (NSString *)registerFontWithPath:(NSString *)fontPath;

@end

NS_ASSUME_NONNULL_END
