//
//  USKeyedArchiver.m
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import "USKeyedArchiver.h"
#import "USConstants.h"

@implementation USKeyedArchiver

+ (NSString *)readerPathWithFolderName:(NSString *)folderName {
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", US_DOCUMENTPATH, US_READERFOLDER, folderName];
    return path;
}

+ (void)archiver:(NSString *)folderName fileName:(NSString *)fileName object:(id)object {
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", US_DOCUMENTPATH, US_READERFOLDER, folderName];
    if ([self createFile:path]) {
        path = [path stringByAppendingPathComponent:fileName];
        [NSKeyedArchiver archiveRootObject:object toFile:path];
    }
}

+ (id)unarchiver:(NSString *)folderName fileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/%@", US_DOCUMENTPATH, US_READERFOLDER, folderName, fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (BOOL)remove:(NSString *)folderName fileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", US_DOCUMENTPATH, US_READERFOLDER, folderName];
    if (fileName != nil && ![fileName isEqualToString:@""]) {
        path = [path stringByAppendingPathComponent:fileName];
    }
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

+ (BOOL)clear {
    NSString *path = [NSString stringWithFormat:@"%@/%@", US_DOCUMENTPATH, US_READERFOLDER];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

+ (BOOL)isExist:(NSString *)folderName fileName:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", US_DOCUMENTPATH, US_READERFOLDER, folderName];
    if (fileName != nil && ![fileName isEqualToString:@""]) {
        path = [path stringByAppendingPathComponent:fileName];
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)createFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    NSError *error;
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

@end
