//
//  NSArray+USReader.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "NSArray+USReader.h"

static id __nullable usfirst(id<NSFastEnumeration> container, BOOL (^predicate)(id)) {
  for (id object in container) {
    if (predicate(object)) {
      return object;
    }
  }
  return nil;
}

static id usFilter(id<NSFastEnumeration, NSObject> container, BOOL (^predicate)(id, NSInteger)) {
  id result = [[[container class] new] mutableCopy];
    NSInteger index = 0;
  for (id object in container) {
    if (predicate(object, index)) {
      [result addObject:object];
    }
      index += 1;
  }
  return result;
}

@implementation NSArray (USReader)

- (nullable id)usfirst:(BOOL (^)(id))predicate {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(predicate);

  return usfirst((id<NSFastEnumeration>)self, predicate);
}

- (nullable id)usfilter:(BOOL (^)(id, NSInteger))predicate {
  NSParameterAssert([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]] ||
                    [self isKindOfClass:[NSOrderedSet class]]);
  NSParameterAssert(predicate);

  return usFilter((id<NSFastEnumeration, NSObject>)self, predicate);
}

@end
