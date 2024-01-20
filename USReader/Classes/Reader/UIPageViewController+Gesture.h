//
//  UIPageViewController+Gesture.h
//  USReader
//
//  Created by yung on 2023/11/29.
//

#import <UIKit/UIKit.h>

static NSString * const IsGestureRecognizerEnabled = @"IsGestureRecognizerEnabled";
static NSString * const TapIsGestureRecognizerEnabled = @"TapIsGestureRecognizerEnabled";


NS_ASSUME_NONNULL_BEGIN

@interface UIPageViewController (Gesture)

@property (nonatomic, assign) BOOL gestureRecognizerEnabled;

@property (nonatomic, assign) BOOL tapGestureRecognizerEnabled;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
