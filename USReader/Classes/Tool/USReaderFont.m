//
//  USReaderFont.m
//  Masonry
//
//  Created by nongyun.cao on 2024/1/5.
//

#import "USReaderFont.h"
#import "USConstants.h"

@implementation USReaderFont

+ (NSArray <USReaderFontFile *>*)loadAllFontFamily {
    NSBundle *bundle = [USConstants resourceBundle];
    NSString *fontPath = [bundle pathForResource:@"Font" ofType:nil];
    return [self loadFontsWithPath:fontPath];
}

+ (NSArray <USReaderFontFile *>*)loadFontsWithPath:(NSString *)path {
    NSArray *fontsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray <USReaderFontFile *>*fontFiles = [NSMutableArray array];
    for (NSString *fontFile in fontsArray) {
        NSString *fontFilePath = [path stringByAppendingPathComponent:fontFile];
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fontFilePath isDirectory:&isDir];
        if (isDir) {
            NSArray <USReaderFontFile *>*subFontFiles = [self loadFontsWithPath:fontFilePath];
            [fontFiles addObjectsFromArray:subFontFiles];
        } else {
            NSDictionary<NSFileAttributeKey, id> * attributed = [[NSFileManager defaultManager] attributesOfItemAtPath:fontFilePath error:nil];
            USReaderFontFile *file = [[USReaderFontFile alloc] init];
            file.fontName = [self registerFontWithPath:fontFilePath];
            file.name = [fontFile stringByDeletingPathExtension];
            file.path = fontFilePath;
            file.extension = fontFile.pathExtension;
            file.size = [attributed[NSFileSize] integerValue];
            [fontFiles addObject:file];
        }
    }
    return fontFiles;
}

+ (NSString *)registerFontWithPath:(NSString *)fontPath {
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
    CGFontRef customfont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    
    NSString *fontName = (__bridge NSString *)CGFontCopyFullName(customfont);
    
    CFErrorRef error;
    
    CTFontManagerRegisterGraphicsFont(customfont, &error);
    
    if (error){
        
        // 为了可以重复注册
        
        CTFontManagerUnregisterGraphicsFont(customfont, &error);
        
        CTFontManagerRegisterGraphicsFont(customfont, &error);
        
    }
    
    CGFontRelease(customfont);
    
    return fontName;
}

+ (UIFont*)fontWithName:(NSString *)name size:(CGFloat)fontSize fontFamily:(NSArray <USReaderFontFile *>*)fontFamily {
    if (name) {
        UIFontDescriptor *originalDescriptor = [UIFont fontWithName:name size:fontSize].fontDescriptor;
        UIFontDescriptor *descriptor = [originalDescriptor fontDescriptorByAddingAttributes:@{
            UIFontDescriptorCascadeListAttribute: @[[UIFont systemFontOfSize:fontSize].fontDescriptor]
        }];
        UIFont *font = [UIFont fontWithDescriptor:descriptor size:fontSize];
        if (font) return font;
    }
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}

@end
