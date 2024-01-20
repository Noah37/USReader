//
//  USPageViewController.m
//  USReader
//
//  Created by yung on 2023/11/29.
//

#import "USPageViewController.h"
#import "UIPageViewController+Gesture.h"

@interface USPageViewController ()

@end

@implementation USPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapGestureRecognizerEnabled = NO;
    
    self.customTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
    self.customTapGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:self.customTapGestureRecognizer];
}

- (void)touchTap:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.view];
    if (touchPoint.x < LeftWidth) {
        [self.USDelegate pageViewController:self getViewControllerBefore:self.viewControllers.firstObject];
    } else if (touchPoint.x > (ScreenWidth - LeftWidth)) {
        [self.USDelegate pageViewController:self getViewControllerAfter:self.viewControllers.firstObject];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
        gestureRecognizer == self.customTapGestureRecognizer) {
        CGPoint touchPoint = [self.customTapGestureRecognizer locationInView:self.view];
        if (touchPoint.x > LeftWidth && touchPoint.x < (ScreenWidth - LeftWidth)) {
            return YES;
        }
    }
    return NO;
}

@end
