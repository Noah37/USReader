//
//  USKeyedArchiver.h
//  USReader
//
//  Created by nongyun.cao on 2023/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USKeyedArchiver : NSObject

+ (void)archiver:(NSString *)folderName fileName:(NSString *)fileName object:(id)object;
+ (id)unarchiver:(NSString *)folderName fileName:(NSString *)fileName;
+ (BOOL)remove:(NSString *)folderName fileName:(NSString *)fileName;
+ (BOOL)clear;
+ (BOOL)isExist:(NSString *)folderName fileName:(NSString *)fileName;
+ (BOOL)createFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
