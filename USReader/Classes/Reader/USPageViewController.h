//
//  USPageViewController.h
//  USReader
//
//  Created by yung on 2023/11/29.
//

#import <UIKit/UIKit.h>

#define LeftWidth [UIScreen mainScreen].bounds.size.width/3

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@class USPageViewController, USReaderRecordModel;
@protocol USPageViewControllerDelegate <NSObject>

/// 获取上一页
- (USReaderRecordModel *_Nullable)pageViewController:(USPageViewController *_Nullable)pageViewController getViewControllerBefore:(UIViewController *_Nullable)viewController;

/// 获取下一页
- (USReaderRecordModel *_Nullable)pageViewController:(USPageViewController *_Nullable)pageViewController getViewControllerAfter:(UIViewController *_Nullable)viewController;

@end

NS_ASSUME_NONNULL_BEGIN

@interface USPageViewController : UIPageViewController<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <USPageViewControllerDelegate>USDelegate;

@property (nonatomic, strong) UITapGestureRecognizer * customTapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
