//
//  USReaderFontFile.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USReaderFontFile : NSObject

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSString *path;

@end

NS_ASSUME_NONNULL_END
