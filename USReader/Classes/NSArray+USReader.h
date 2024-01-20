//
//  NSArray+USReader.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (USReader)

- (nullable id)usfirst:(BOOL (^)(id))predicate;

- (nullable id)usfilter:(BOOL (^)(id, NSInteger))predicate;

@end

NS_ASSUME_NONNULL_END
