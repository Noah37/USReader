//
//  UIPageViewController+Gesture.m
//  USReader
//
//  Created by yung on 2023/11/29.
//

#import "UIPageViewController+Gesture.h"
#import <objc/runtime.h>

@implementation UIPageViewController (Gesture)

@dynamic tapGestureRecognizer;


- (BOOL)gestureRecognizerEnabled {
    return [objc_getAssociatedObject(self, @selector(gestureRecognizerEnabled)) boolValue];
}

- (void)setGestureRecognizerEnabled:(BOOL)gestureRecognizerEnabled {
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        ges.enabled = gestureRecognizerEnabled;
    }
    objc_setAssociatedObject(self, @selector(gestureRecognizerEnabled), @(gestureRecognizerEnabled), OBJC_ASSOCIATION_ASSIGN);
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
            return (UITapGestureRecognizer *)ges;
        }
    }
    return nil;
}

- (BOOL)tapGestureRecognizerEnabled {
    return [objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) boolValue];
}

- (void)setTapGestureRecognizerEnabled:(BOOL)tapGestureRecognizerEnabled {
    self.tapGestureRecognizer.enabled = tapGestureRecognizerEnabled;
    objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled, @(tapGestureRecognizerEnabled), OBJC_ASSOCIATION_ASSIGN);
}

@end
