//
//  USReaderBottomView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KTabBarHeight 49
#define kProgressHeight 30
#define KBottomSafeAreaHeight [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom
#define KBottomBarHeight ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom + KTabBarHeight + kProgressHeight + 40)

@class USReaderBottomView;
@protocol USReaderBottomViewDelegate <NSObject>

- (void)bottomViewClickMore:(USReaderBottomView *)bottomView;

@end

@class USReaderMenu;
@interface USReaderBottomView : UIView

@property (nonatomic, weak) id <USReaderBottomViewDelegate>delegate;

- (instancetype)initWithMenu:(USReaderMenu *)menu;

@end

NS_ASSUME_NONNULL_END
